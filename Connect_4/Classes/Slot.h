//
//  Slot.h
//  Connect_4
//
//  Created by Krom on 11/12/14.
//  Copyright (c) 2014 SomethingOrOther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Slot : NSObject
{
@public
    CGRect slotRect;
    
    NSInteger slotID;
    NSInteger pieceID;
    
    NSString *spriteName;
   
    CCSprite *slot;
    
    Slot *upperSlot;
    Slot *lowerSlot;
    Slot *rightSlot;
    Slot *leftSlot;
    Slot *upperRightSlot;
    Slot *upperLeftSlot;
    Slot *lowerRightSlot;
    Slot *lowerLeftSlot;
}

-(void)SetRect:(NSInteger) _x _y:(NSInteger)_y _w:(NSInteger) _w _h:(NSInteger)_h;

-(void)setSlotID:(NSInteger) _id;
-(void)setPieceID:(NSInteger) _id;

-(void)setSpriteName:(NSString*)fileName;
-(void)setSlotSprite:(CCSprite*)sprite;

-(void)setSlotNeighbors:(NSMutableArray*)_neighbors;
@end
