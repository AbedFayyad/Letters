//
//  LetterTile.h
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface LetterTile : NSObject

@property (readonly) SKShapeNode *tileNode;

- (LetterTile *)initWithSize:(const CGSize)size andChar:(const char)letter;

@end
