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

@interface LetterGrid ()

@property NSMutableArray *tiles;

@end

@implementation LetterGrid

- (LetterGrid *)initWithSize:(const CGSize)size {
    self = [super init];
    if (!self) return nil;
    
    SKShapeNode *gridNode = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:gridCornerRadius];
    
    // TODO: Prettify grid
    gridNode.fillColor = [SKColor lightGrayColor];
    gridNode.strokeColor = [SKColor darkGrayColor];
    
    self.tiles = [NSMutableArray arrayWithCapacity:numRows * numColumns];
    
    // Calculate tile dimensions and padding
    const CGFloat horizontalPadding = columnPaddingMultiplier * gridNode.frame.size.width;
    const CGFloat verticalPadding = rowPaddingMultiplier * gridNode.frame.size.height;
    const CGFloat tileWidth = tileWidthMultiplier * gridNode.frame.size.width;
    const CGFloat tileHeight = tileHeightMultiplier * gridNode.frame.size.height;
    
    // The point at which the bottom-left-most tile will be placed
    const CGPoint gridOrigin = CGPointMake(gridNode.frame.origin.x + horizontalPadding,
                                           gridNode.frame.origin.y + verticalPadding);
    
    // Distribute the tiles along the grid
    for (int i = 0; i < numColumns; ++i) {
        for (int j = 0; j < numRows; ++j) {
            LetterTile *tile = [[LetterTile alloc] initWithSize:CGSizeMake(tileWidth, tileHeight)
                                                        andChar:('A' + ((i * 4) + j))];
            tile.tileNode.position = CGPointMake(gridOrigin.x + (j * (horizontalPadding + tileWidth)),
                                                 gridOrigin.y + (i * (verticalPadding + tileHeight)));
            [self.tiles addObject:tile];
            [gridNode addChild:tile.tileNode];
        }
    }
    
    _gridNode = gridNode;
    
    return self;
}

@end
