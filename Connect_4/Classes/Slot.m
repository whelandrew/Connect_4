//
//  Slot.m
//  Connect_4
//
//  Created by Krom on 11/12/14.
//  Copyright (c) 2014 SomethingOrOther. All rights reserved.
//

#import "Slot.h"

@implementation Slot

-(void)SetRect:(NSInteger) _x _y:(NSInteger)_y _w:(NSInteger) _w _h:(NSInteger)_h
{
    slotRect.origin.x=_x;
    slotRect.origin.y=_y;
    slotRect.size.width=_w;
    slotRect.size.height=_h;
}


-(void)setSlotID:(NSInteger) _id
{
    slotID=_id;
}

-(void)setPieceID:(NSInteger) _id
{
    pieceID=_id;
}

-(void)setSpriteName:(NSString*)fileName
{
    spriteName=fileName;
}

-(void)setSlotSprite:(CCSprite*)sprite
{
    slot=sprite;
}

@end
