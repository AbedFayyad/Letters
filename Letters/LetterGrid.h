//
//  LetterGrid.h
//  Letters
//
//  Created by Abed Fayyad on 2016-07-05.
//  Copyright © 2016 Abed Fayyad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface LetterGrid : NSObject

@property (readonly) SKShapeNode *gridNode;

- (LetterGrid *)initWithSize:(const CGSize)size;

@end
