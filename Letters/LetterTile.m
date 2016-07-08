//
//  LetterTile.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import "LetterTile.h"

static const CGFloat tileBorderRadius = 16.0;

@implementation LetterTile

- (LetterTile *)initWithSize:(const CGSize)size andChar:(const char)letter {
    self = [super init];
    if (!self) return nil;
    
    // Set origin points to width or height multiplied by -0.5 so that the position property points to center
    SKShapeNode *tileNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0,//size.width * -0.5,
                                                                      0,//size.height * -0.5,
                                                                      size.width,
                                                                      size.height)
                                              cornerRadius:tileBorderRadius];
    
    // TODO: Prettify tiles
    tileNode.fillColor = [SKColor whiteColor];
    tileNode.strokeColor = [SKColor blackColor];
    
    SKLabelNode *letterNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%c", letter]];
    letterNode.position = CGPointMake(letterNode.position.x + size.width / 2,
                                      letterNode.position.y + size.height / 2);
    letterNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    letterNode.fontSize = size.width;
    
    // TODO: Import and use more suitable tile font
    letterNode.fontColor = [SKColor blackColor];
    
    [tileNode addChild:letterNode];
    
    _tileNode = tileNode;
    _letterNode = letterNode;
    
    return self;
}

@end
