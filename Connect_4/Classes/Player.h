//
//  Player.h
//  Connect_4
//
//  Created by Krom on 11/13/14.
//  Copyright (c) 2014 SomethingOrOther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Player : NSObject
{
@public
    CGRect playerRect;
    
    NSInteger pieceID;
    NSInteger slotPlacedID;
    
    NSString *spriteName;
    
    CCSprite *piece;
    
    bool isAI;
}

-(void)SetRect:(NSInteger) _x _y:(NSInteger)_y _w:(NSInteger) _w _h:(NSInteger)_h;
-(void)setSlotPlaceID:(NSInteger) _id;
-(void)setPieceID:(NSInteger) _id;

-(void)setSpriteName:(NSString*)fileName;
-(void)setPieceSprite:(CCSprite*)sprite;

@end
