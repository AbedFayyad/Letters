//
//  GameScene.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright (c) 2016 Abed Fayyad. All rights reserved.
//

#import "GameScene.h"
#import "LetterGrid.h"

@interface GameScene () {
    CGPoint firstTouch;
    bool firstTouchIsOutOfBounds;
    enum MovementType {
        HorizontalMovement,
        VerticalMovement,
        NoMovement
    };
    NSInteger row;
    NSInteger column;
    NSUInteger movementType;
}

@property LetterGrid *grid;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor whiteColor];
    
    const CGFloat gridWidth = self.size.width * 0.85;
    const CGFloat gridHeight = gridWidth * (4.0 / 3.0);
    self.grid = [[LetterGrid alloc] initWithSize:CGSizeMake(gridWidth, gridHeight)];
    self.grid.gridNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.grid.gridNode];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        // Determine the row and column at the touch's coordinates
        row = [self.grid rowAtPoint:[touch locationInNode:self.grid.gridNode]];
        column = [self.grid columnAtPoint:[touch locationInNode:self.grid.gridNode]];
        
        // Determine if touch was out of bounds
        firstTouchIsOutOfBounds = row == -1 || column == -1;
        
        // Record first touch and reset movement type until it is known
        if (!firstTouchIsOutOfBounds) {
            firstTouch = [touch locationInNode:self.grid.gridNode];
            movementType = NoMovement;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (firstTouchIsOutOfBounds) return;
    
    for (UITouch *touch in touches) {
        
        // Record current touch and determine direction of movement if not already known
        CGPoint nextTouch = [touch locationInNode:self.grid.gridNode];
        if (movementType == NoMovement) {
            movementType = fabs(firstTouch.x - nextTouch.x) > fabs(firstTouch.y - nextTouch.y) ? HorizontalMovement : VerticalMovement;
        }
        
        // Respond to touch movements
        switch (movementType) {
            case HorizontalMovement:
                [self.grid moveRowAtIndex:row by:nextTouch.x - firstTouch.x];
                break;
            case VerticalMovement:
                [self.grid moveColumnAtIndex:column by:nextTouch.y - firstTouch.y];
                break;
        }
        
        firstTouch = nextTouch;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (firstTouchIsOutOfBounds) return;
    
    [self.grid snapTilesToGrid];
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
