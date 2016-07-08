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
    
    self.grid = [[LetterGrid alloc] initWithSize:CGSizeMake(414.0f, 552.0f)];
    self.grid.gridNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.grid.gridNode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        [self.grid setActivePosition:[touch locationInNode:self.grid.gridNode]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    
    [self.grid resetActivePosition];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* Called when a touch moves */
    
    for (UITouch *touch in touches) {
        [self.grid slideTo:[touch locationInNode:self.grid.gridNode]];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
