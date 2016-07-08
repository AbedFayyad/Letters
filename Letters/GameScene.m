//
//  GameScene.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright (c) 2016 Abed Fayyad. All rights reserved.
//

#import "GameScene.h"
#import "LetterGrid.h"

@interface GameScene ()

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

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
