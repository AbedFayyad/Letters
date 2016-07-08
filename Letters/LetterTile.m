//
//  LetterTile.m
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import "LetterTile.h"

static const CGSize defaultTileSize = { 96.0f, 128.0f };
static const CGFloat defaultTileBorderRadius = 16.0f;

@interface LetterTile ()

@property (readonly) SKLabelNode *letterNode;

@end

@implementation LetterTile

// Designated initializer
- (LetterTile *)initWithSize:(const CGSize)size andChar:(const char)letter {
    self = [super init];
    
    if (!self) return nil;
    
    SKShapeNode *tileNode = [SKShapeNode shapeNodeWithRect:CGRectMake(size.width / -2.0f, size.height / -2.0f, size.width, size.height) cornerRadius:defaultTileBorderRadius];
    tileNode.fillColor = [SKColor whiteColor];
    tileNode.strokeColor = [SKColor blackColor];
    
    SKLabelNode *letterNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%c", letter]];
    letterNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    letterNode.fontSize = size.width;
    letterNode.fontColor = [SKColor blackColor];
    
    [tileNode addChild:letterNode];
    
    _tileNode = tileNode;
    _letterNode = letterNode;
    
    return self;
}

- (LetterTile *)initWithChar:(const char)letter {
    return [self initWithSize:defaultTileSize andChar:letter];
}

- (LetterTile *)init {
    return [self initWithSize:defaultTileSize andChar:' '];
}

@end
