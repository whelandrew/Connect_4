//
//  Player.m
//  Connect_4
//
//  Created by Krom on 11/13/14.
//  Copyright (c) 2014 SomethingOrOther. All rights reserved.
//

#import "Player.h"
#import "Slot.h"

@implementation Player

-(void)SetRect:(NSInteger) _x _y:(NSInteger)_y _w:(NSInteger) _w _h:(NSInteger)_h
{
    playerRect.origin.x=_x;
    playerRect.origin.y=_y;
    playerRect.size.width=_w;
    playerRect.size.height=_h;
}

-(void)setSlotPlaceID:(NSInteger) _id
{
    slotPlacedID=_id;
}

-(void)setPieceID:(NSInteger) _id
{
    pieceID=_id;
}

-(void)setSpriteName:(NSString*)fileName
{
    spriteName=fileName;
}


-(void)setPieceSprite:(CCSprite*)sprite
{
    piece=sprite;
}
@end
