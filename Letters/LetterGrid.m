//
//  LetterGrid.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import "LetterGrid.h"

#import "LetterTile.h"

static const NSUInteger numRows = 4;
static const NSUInteger numColumns = 4;
static const CGFloat gridCornerRadius = 16.0f;

// Multiply these values by the width or height of the grid node to determine its tiles' size and spacing
static const CGFloat columnPaddingMultiplier = 0.1 / (numColumns + 1);
static const CGFloat rowPaddingMultiplier = 0.1 / (numRows + 1);
static const CGFloat tileWidthMultiplier = (1.0 - (columnPaddingMultiplier * (numColumns + 1))) / numColumns;
static const CGFloat tileHeightMultiplier = (1.0 - (rowPaddingMultiplier * (numRows + 1))) / numRows;

@interface LetterGrid () {
    CGFloat horizontalPadding, verticalPadding;
    CGFloat tileWidth, tileHeight;
    CGPoint tileOrigin;
}

@property CGSize size;
@property NSMutableArray *tiles;
@property LetterTile *spareTile;

@end

@implementation LetterGrid

- (LetterGrid *)initWithSize:(const CGSize)size {
    self = [super init];
    if (!self) return nil;
    
    self.size = size;
    
    SKShapeNode *gridNode = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:gridCornerRadius];
    
    // TODO: Prettify grid
    gridNode.fillColor = [SKColor lightGrayColor];
    gridNode.strokeColor = [SKColor darkGrayColor];
    
    SKCropNode *cropNode = [SKCropNode node];
    SKShapeNode *maskNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(size.width - 2, size.height - 2)
                                                    cornerRadius:gridCornerRadius];
    maskNode.fillColor = [SKColor blackColor];
    cropNode.maskNode = maskNode;
    [gridNode addChild:cropNode];
    
    self.tiles = [NSMutableArray arrayWithCapacity:numRows * numColumns];
    
    // Calculate tile dimensions and padding
    horizontalPadding = columnPaddingMultiplier * gridNode.frame.size.width;
    verticalPadding = rowPaddingMultiplier * gridNode.frame.size.height;
    tileWidth = tileWidthMultiplier * gridNode.frame.size.width;
    tileHeight = tileHeightMultiplier * gridNode.frame.size.height;
    
    // The point at which the bottom-left-most tile will be placed
    tileOrigin = CGPointMake(gridNode.frame.origin.x + horizontalPadding,
                              gridNode.frame.origin.y + verticalPadding);
    
    
    self.spareTile = [[LetterTile alloc] initWithSize:CGSizeMake(tileWidth, tileHeight) andChar:' '];
    self.spareTile.tileNode.hidden = true;
    [cropNode addChild:self.spareTile.tileNode];
    
    // Distribute the tiles along the grid
    for (int i = 0; i < numColumns; ++i) {
        for (int j = 0; j < numRows; ++j) {
            LetterTile *tile = [[LetterTile alloc] initWithSize:CGSizeMake(tileWidth, tileHeight)
                                                        andChar:('A' + ((i * 4) + j))];
            tile.tileNode.position = CGPointMake(tileOrigin.x + (j * (horizontalPadding + tileWidth)),
                                                 tileOrigin.y + (i * (verticalPadding + tileHeight)));
            [self.tiles addObject:tile];
            [cropNode addChild:tile.tileNode];
        }
    }
    
    _gridNode = gridNode;
    
    return self;
}

// TODO: Use padding and tile dimension values instead of calculating them
- (NSUInteger)rowAtPoint:(const CGPoint)point {
    NSUInteger row = 0;
    while (!(tileOrigin.y + (row * self.size.height / numRows) <= point.y &&
             point.y < tileOrigin.y + ((row + 1) * self.size.height / numRows))) {
        row++;
        if (row == numRows) return -1;
    }
    
    return row;
}

// TODO: Use padding and tile dimension values instead of calculating them
- (NSUInteger)columnAtPoint:(const CGPoint)point {
    NSUInteger column = 0;
    while (!(tileOrigin.x + (column * self.size.width / numColumns) <= point.x &&
             point.x < tileOrigin.x + ((column + 1) * self.size.width / numColumns))) {
        column++;
        if (column == numColumns) return -1;
    }
    
    return column;
}

// TODO: Limitless horizontal scrolling
- (void)moveRowAtIndex:(NSInteger)row by:(CGFloat)amount {
    if (row < 0 || row >= numRows) return;
    
    for (LetterTile *tile in [self getTilesAtRow:row])
        tile.tileNode.position = CGPointMake(tile.tileNode.position.x + amount,
                                             tile.tileNode.position.y);
}

// TODO: Limitless vertical scrolling
- (void)moveColumnAtIndex:(NSInteger)column by:(CGFloat)amount {
    if (column < 0 || column >= numColumns) return;
    
    for (LetterTile *tile in [self getTilesAtColumn:column])
        tile.tileNode.position = CGPointMake(tile.tileNode.position.x,
                                             tile.tileNode.position.y + amount);
}

- (NSSet<LetterTile *> *)getTilesAtRow:(NSInteger)row {
    LetterTile *tiles[numColumns];
    
    for (int i = 0; i < numColumns; ++i)
        tiles[i] = [self.tiles objectAtIndex:(row * numColumns) + i];
    
    return [NSSet setWithObjects:tiles count:numColumns];
}

- (NSSet<LetterTile *> *)getTilesAtColumn:(NSInteger)column {
    LetterTile *tiles[numRows];
    
    for (int i = 0; i < numRows; ++i)
        tiles[i] = [self.tiles objectAtIndex:(i * numRows) + column];
    
    return [NSSet setWithObjects:tiles count:numRows];
}

- (void)snapTilesToGrid {
    // All x-coords are at (gridOrigin) + (n * (tileWidth + offsetX))
    // Take x-coord - (gridOrigin) and round to nearest (tileWidth + offsetX)
    // All y-coords are at (gridOrigin) + (n * (tileHeight + offsetY))
    // Take y-coord - (gridOrigin) and round to nearest (tileHeight + offsetY)
    
    for (LetterTile *tile in self.tiles) {
        tile.tileNode.position = [self getTilePositionNearestTo:tile.tileNode.position];
    }
}

- (CGPoint)getTilePositionNearestTo:(CGPoint)position {
    
    NSInteger column = -numColumns;
    while (fabsf(tileOrigin.x + column * (tileWidth + horizontalPadding) - position.x) >= (tileWidth + horizontalPadding) / 2) {
        column++;
    }
    
    NSInteger row = -numRows;
    while (fabsf(tileOrigin.y + row * (tileHeight + verticalPadding) - position.y) >= (tileHeight + verticalPadding) / 2) {
        row++;
    }
    
    return CGPointMake(tileOrigin.x + column * (tileWidth + horizontalPadding),
                       tileOrigin.y + row * (tileHeight + verticalPadding));
}

@end
