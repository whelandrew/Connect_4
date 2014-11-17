//
//  GameBoardScene.h
//  Connect_4
//
//  Created by Krom on 11/11/14.
//  Copyright SomethingOrOther 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Slot.h"
#import "Player.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@class Slot;
@class Player;
@interface GameBoardScene : CCScene
{
    NSMutableArray *slotsArray;
    NSMutableArray *player1Array;
    NSMutableArray *player2Array;
    
    bool gameOver;
    bool animating;
    bool playerTwo;
    
    NSInteger nodesPerRow;
}

// -----------------------------------------------------------------------

+ (GameBoardScene *)scene;
- (id)init;
-(void)createGamePieces;
-(void)placePlayerPiece:(CGRect)_position _slotID:(NSInteger)_slotID _startPos:(CGPoint)_startPos;
-(void)findOpenSlot:(CGRect)_position _slotID:(NSInteger)_slotID;
-(void)assignSlotNeighbors;
-(bool)inBounds:(NSInteger) targetID;

-(void)setAnimation:(bool)isOn;
// -----------------------------------------------------------------------
@end