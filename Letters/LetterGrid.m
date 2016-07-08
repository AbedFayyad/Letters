//
//  LetterGrid.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import "LetterGrid.h"

#import "LetterTile.h"

static const CGSize defaultGridSize = { 100.0f, 100.0f };
static const CGFloat defaultGridCornerRadius = 16.0f;
static const NSUInteger numRows = 4;
static const NSUInteger numColumns = 4;

@interface LetterGrid ()

@property NSMutableArray *letterTiles;
@property NSMutableArray *rowOffsets;
@property NSMutableArray *columnOffsets;
@property NSUInteger currentRow;
@property NSUInteger currentColumn;
@property CGPoint initialPosition;
@property BOOL isSlidingHorizontally;
@property BOOL isSlidingVertically;

- (void)snapToGrid;

@end

@implementation LetterGrid

CGFloat getNearestX(CGFloat posX) {
    int correctionFactor = 0;
    bool isNegative = posX < 0;
    if (isNegative) posX *= -1;
    
    while (posX - (51.75f + (103.5f * correctionFactor)) > 103.5f) correctionFactor++;
    
    if (posX - (51.75f + (103.5f * correctionFactor)) > 51.75f) correctionFactor++;
    
    return (isNegative ? -1.0f : 1.0f) * (51.75f + (103.5f * correctionFactor));
}

CGFloat getNearestY(CGFloat posY) {
    int correctionFactor = 0;
    bool isNegative = posY < 0;
    if (isNegative) posY *= -1;
    
    while (posY - (69.0f + (138.0f * correctionFactor)) > 138.0f) correctionFactor++;
    
    if (posY - (69.0f + (138.0f * correctionFactor)) > 69.0f) correctionFactor++;
    
    return (isNegative ? -1.0f : 1.0f) * (69.0f + (138.0f * correctionFactor));
}

- (LetterGrid *)initWithSize:(const CGSize)size {
    self = [super init];
    
    if (!self) return nil;
    
    SKShapeNode *gridNode = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:defaultGridCornerRadius];
    gridNode.fillColor = [SKColor lightGrayColor];
    gridNode.strokeColor = [SKColor darkGrayColor];
    
    self.letterTiles = [NSMutableArray arrayWithCapacity:4 * 4];
    self.rowOffsets = [NSMutableArray arrayWithCapacity:numRows];
    self.columnOffsets = [NSMutableArray arrayWithCapacity:numColumns];
    [self.rowOffsets addObjectsFromArray:@[@0.0f, @0.0f, @0.0f, @0.0f]];
    [self.columnOffsets addObjectsFromArray:@[@0.0f, @0.0f, @0.0f, @0.0f]];
    
    self.currentRow = -1;
    self.currentColumn = -1;
    self.initialPosition = CGPointMake(-1.0f, -1.0f);
    self.isSlidingHorizontally = false;
    self.isSlidingVertically = false;
    
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            LetterTile *tile = [[LetterTile alloc] initWithSize:CGSizeMake(96.0f, 128.0f) andChar:('A' + ((i * 4) + j))];
            tile.tileNode.position = CGPointMake(tile.tileNode.position.x + ((96.0f + 6.0f) * (-1.5f + j)),
                                                 tile.tileNode.position.y + ((128.0f + 8.0f) * (-1.5f + i)));
            [self.letterTiles addObject:tile];
            [gridNode addChild:tile.tileNode];
        }
    }
    
    _gridNode = gridNode;
    
    return self;
}

- (LetterGrid *)init {
    return [self initWithSize:defaultGridSize];
}

- (void)slideTo:(CGPoint)position {
    if (self.currentRow == -1 || self.currentColumn == -1) return;
    
    if (self.initialPosition.x == -1 && self.initialPosition.y == -1) {
        self.initialPosition = position;
        return;
    } else {
        CGFloat offsetX = position.x - self.initialPosition.x;
        CGFloat offsetY = position.y - self.initialPosition.y;

        if (!self.isSlidingHorizontally && !self.isSlidingVertically) {
            if (fabsf(offsetX) > fabsf(offsetY)) {
                self.isSlidingHorizontally = true;
                self.isSlidingVertically = false;
            } else if (fabsf(offsetX) < fabsf(offsetY)) {
                self.isSlidingVertically = true;
                self.isSlidingHorizontally = false;
            }
        }
        
        if (self.isSlidingHorizontally) {
            for (int i = 0; i < 4; ++i) {
                LetterTile *tile = [self.letterTiles objectAtIndex:((self.currentRow * 4) + i)];
                tile.tileNode.position = CGPointMake(tile.tileNode.position.x + offsetX,
                                                     tile.tileNode.position.y);
            }
        } else if (self.isSlidingVertically) {
            for (int i = 0; i < 4; ++i) {
                LetterTile *tile = [self.letterTiles objectAtIndex:((i * 4) + self.currentColumn)];
                tile.tileNode.position = CGPointMake(tile.tileNode.position.x,
                                                     tile.tileNode.position.y + offsetY);
            }
            
        }
        
        self.initialPosition = position;
    }
}

- (void)setActivePosition:(CGPoint)position {
    if (position.y >= -276.0f && position.y < -138.0f) self.currentRow = 0;
    else if (position.y >= -138.0f && position.y < 0.0f) self.currentRow = 1;
    else if (position.y >= 0.0f && position.y < 138.0f) self.currentRow = 2;
    else if (position.y >= 138.0f && position.y < 276.0f) self.currentRow = 3;
    else self.currentRow = -1;
    
    if (position.x >= -207.0f && position.x < -103.5f) self.currentColumn = 0;
    else if (position.x >= -103.5f && position.x < 0.0f) self.currentColumn = 1;
    else if (position.x >= 0.0f && position.x < 103.5f) self.currentColumn = 2;
    else if (position.x >= 103.5f && position.x < 207.0f) self.currentColumn = 3;
    else self.currentColumn = -1;
    
    self.initialPosition = CGPointMake(-1.0f, -1.0f);
    self.isSlidingHorizontally = false;
    self.isSlidingVertically = false;
}

- (void)resetActivePosition {
    [self snapToGrid];
    
    self.currentRow = -1;
    self.currentColumn = -1;
    self.initialPosition = CGPointMake(-1.0f, -1.0f);
    self.isSlidingHorizontally = false;
    self.isSlidingVertically = false;
}

- (void)snapToGrid {
    if (self.isSlidingHorizontally) {
        for (int i = 0; i < 4; ++i) {
            LetterTile *tile = [self.letterTiles objectAtIndex:((self.currentRow * 4) + i)];
            [tile.tileNode runAction:[SKAction moveToX:getNearestX(tile.tileNode.position.x) duration:0.01]];
        }
    } else if (self.isSlidingVertically) {
        for (int i = 0; i < 4; ++i) {
            LetterTile *tile = [self.letterTiles objectAtIndex:((i * 4) + self.currentColumn)];
            [tile.tileNode runAction:[SKAction moveToY:getNearestY(tile.tileNode.position.y) duration:0.01]];
        }
    }
}

@end
