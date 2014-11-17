//
//  GameBoardScene.m
//  Connect_4
//
//  Created by Krom on 11/11/14.
//  Copyright SomethingOrOther 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "GameBoardScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - GameBoardScene
// -----------------------------------------------------------------------

@implementation GameBoardScene
{
    CCSprite *_sprite;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameBoardScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------


- (id)init
{
    if ((self = [super init]))
    {
        self.userInteractionEnabled = YES;
        
        gameOver=false;
        animating=false;
        
        nodesPerRow=8;
        
        [self createGamePieces];
        
        player1Array=[[NSMutableArray alloc]init];
        player2Array=[[NSMutableArray alloc]init];
        
        // Create a back button
        CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
        backButton.positionType = CCPositionTypeNormalized;
        backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
        [backButton setTarget:self selector:@selector(onBackClicked:)];
        [self addChild:backButton];
    }
    
    // done
    return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(gameOver || animating)
        return;
    
    CGPoint touchLoc = [touch locationInNode:self];
    
    for (Slot *s in slotsArray)
    {
        if (CGRectContainsPoint(s->slot.boundingBox, touchLoc))// && s->pieceID==0)
        {
            [self findOpenSlot:s->slotRect _slotID:s->slotID];
            //[self placePlayerPiece:s->slotRect _slotID:s->slotID _startPos:ccp(s->slotRect.origin.x,[CCDirector sharedDirector].viewSize.height)];
        }
    }
    
    // Move our sprite to touch location
    //CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    //[_sprite runAction:actionMove];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------

-(void)findOpenSlot:(CGRect)_position _slotID:(NSInteger)_slotID
{
    Slot *slot=slotsArray[_slotID];
    if(slot->pieceID<0)
    {
        [self placePlayerPiece:_position _slotID:_slotID _startPos:ccp(slot->slotRect.origin.x,[CCDirector sharedDirector].viewSize.height)];
    }
    else
    {
        slot=slot->lowerSlot;
        [self findOpenSlot:slot->slot.boundingBox _slotID:slot->slotID];
    }
}

-(void)placePlayerPiece:(CGRect)_position _slotID:(NSInteger)_slotID _startPos:(CGPoint)_startPos
{
    Player *newPiece=[[Player alloc]init];
    [newPiece SetRect:_startPos.x _y:_startPos.y _w:_position.size.width _h:_position.size.height];
    
    if(playerTwo)
        [newPiece setSpriteName:@"green.png"];
    else
        [newPiece setSpriteName:@"red.png"];
    
    newPiece->piece = [CCSprite spriteWithImageNamed:newPiece->spriteName];
    [newPiece->piece setPosition:_startPos];
    
    newPiece->slotPlacedID=_slotID;
    /*
    Slot* slotCheck=[slotsArray objectAtIndex:_slotID];
    if(slotCheck->lowerSlot->pieceID<1)
    {
        [self placePlayerPiece:
                    slotCheck->lowerSlot->slotRect
                    _slotID: slotCheck->lowerSlot->slotID
                    _startPos:_startPos];
    }
    */
    
   // [self setAnimation:YES];
    id run=[CCActionMoveTo actionWithDuration:1 position:ccp(_position.origin.x,_position.origin.y)];
//    id action=[CCActionSequence actions:run, setAnimation:NO, nil];
    [newPiece->piece runAction:run];
    
    if(playerTwo)
    {
        newPiece->pieceID=2;
        [player2Array addObject:newPiece];
        playerTwo=false;
    }
    else
    {
        newPiece->pieceID=1;
        [player1Array addObject:newPiece];
        playerTwo=true;
    }
    
    [self addChild:newPiece->piece];
}

-(void)setAnimation:(bool)isOn
{
    animating=isOn;
}

-(void)createGamePieces
{
    slotsArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<8;i++)
    {
        for(int j=0;j<8;j++)
        {
            Slot *newObject=[[Slot alloc]init];
            [newObject setSpriteName:@"slot.png"];
            newObject->slot = [CCSprite spriteWithImageNamed:newObject->spriteName];
            
            [newObject SetRect:
                            j*newObject->slot.contentSize.width+(newObject->slot.contentSize.width/2)
                            _y: i*newObject->slot.contentSize.height+(newObject->slot.contentSize.height/2)
                            _w: newObject->slot.contentSize.width
                            _h: newObject->slot.contentSize.height];
            
            CCLOG(@"slotID %d",(i+j));
            [newObject setSlotID:i+j];
            
            [newObject setPieceID:0];
            
            [newObject->slot setPosition:ccp(newObject->slotRect.origin.x,newObject->slotRect.origin.y)];
            [self addChild:newObject->slot];
            
            [slotsArray addObject:newObject];
        }
    }
    
    [self assignSlotNeighbors];
}

-(void)assignSlotNeighbors
{
    for(Slot* curr in slotsArray)
    {
        //Upper
        NSInteger sID=curr->slotID + nodesPerRow;
        if([self inBounds:sID])
        {
//            [neighbors addObject:slotsArray[sID]];
            curr->upperSlot=slotsArray[sID];
        }
        
        //Lower
        sID=curr->slotID - nodesPerRow;
        if([self inBounds:sID])
        {
            //[neighbors addObject:slotsArray[sID]];
            //lowerSlot=slotsArray[sID];
            curr->lowerSlot=slotsArray[sID];
        }
        
        //Left
        sID=curr->slotID - 1;
        if([self inBounds:sID] && curr->slotID % nodesPerRow != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->leftSlot=slotsArray[sID];
        }
        
        //Right
        sID=curr->slotID + 1;
        if([self inBounds:sID] && (sID % nodesPerRow) != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->rightSlot=slotsArray[sID];
        }
        
        //UpperRight
        sID=curr->slotID + nodesPerRow + 1;
        if([self inBounds:sID] && ((curr->slotID+1) % nodesPerRow) != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->upperRightSlot=slotsArray[sID];
        }
        
        
        //UpperLeft
        sID=curr->slotID + nodesPerRow - 1;
        if([self inBounds:sID] && (curr->slotID % nodesPerRow) != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->upperLeftSlot=slotsArray[sID];
        }
        
        //LowerRight
        sID=curr->slotID + nodesPerRow + 1;
        if([self inBounds:sID] && (curr->slotID+1) % nodesPerRow != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->lowerRightSlot=slotsArray[sID];
        }
        
        //LowerLeft
        sID=curr->slotID - nodesPerRow - 1;
        if([self inBounds:sID] && curr->slotID % nodesPerRow != 0)
        {
            //[neighbors addObject:slotsArray[sID]];
            curr->lowerLeftSlot=slotsArray[sID];
        }
    }
}

-(bool)inBounds:(NSInteger) targetID
{
    if(targetID<0 || targetID>=slotsArray.count)
        return false;
    return true;
}

@end
