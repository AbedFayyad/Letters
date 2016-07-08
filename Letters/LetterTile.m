//
//  LetterTile.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import "LetterTile.h"

static const CGFloat defaultTileBorderRadius = 16.0;

@implementation LetterTile

- (LetterTile *)initWithSize:(const CGSize)size andChar:(const char)letter {
    self = [super init];
    if (!self) return nil;
    
    // Set origin points to width or height multiplied by -0.5 so position property points to center
    SKShapeNode *tileNode = [SKShapeNode shapeNodeWithRect:CGRectMake(size.width * -0.5,
                                                                      size.height * -0.5,
                                                                      size.width,
                                                                      size.height)
                                              cornerRadius:defaultTileBorderRadius];
    
    // TODO: Prettify tiles
    tileNode.fillColor = [SKColor whiteColor];
    tileNode.strokeColor = [SKColor blackColor];
    
    SKLabelNode *letterNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%c", letter]];
    letterNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    letterNode.fontSize = size.width;
    
    // TODO: Import and use more suitable tile font
    letterNode.fontColor = [SKColor blackColor];
    
    [tileNode addChild:letterNode];
    
    _tileNode = tileNode;
    
    return self;
}

@end
