//
//  MyDopamine.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "MyDopamine.h"

@implementation MyDopamine
static MyDopamine* sharedInstance;

+(MyDopamine*)initDopamine
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[MyDopamine alloc ] initSharedInstance];
    }
    return sharedInstance;
}

-(id)initSharedInstance
{
    self = [super init];
    
    // Declare Feedback Function names
    _FEEDBACKFUNCTION1 = @"feedBackFunction1";
    _FEEDBACKFUNCTION2 = @"feedBackFunction2";
    _FEEDBACKFUNCTION3 = @"feedbackFunction3";
    
    // Declare Reward Function names
    _REWARDFUNCTION1 = @"rewardFunction1";
    _REWARDFUNCTION2 = @"rewardFunction2";
    
    // Pair actions to Feedback and Reward functions
    _clickReinforcementButton = [[DopamineAction alloc] init:@"reinforcedBehavior"];
    [_clickReinforcementButton pairFeedback:_FEEDBACKFUNCTION1];
    [_clickReinforcementButton pairReward:_REWARDFUNCTION1];
    
    _dopamineBase = [[DopamineBase alloc] initWithAppID:@"53bf3dfbf572f3b63ee628de"
                                           andVersionID:@"WayneDopamineDummy"
                                                 andKey:@"db07887eec605bff3a9ae5ae5374152ced642ed5"
                                               andToken:@"493245694786310253bf3dfbf572f3b63ee628de"
                     ];
    
    [_dopamineBase addAction:_clickReinforcementButton];
    
    //[_dopamineBase sendInitRequest];
    
    [_dopamineBase addPersistentMetaData:@"Day" andValue:@"Saturday"];
    [_dopamineBase addMetaData:@"firstMetaData" andValue:@"15"];
    
    [self sendTest];
    return self;
}

-(void) sendTest
{
    DopamineRequest* dopamineRequest = [[DopamineRequest alloc] init:_dopamineBase];
    RequestType* requestType = TRACK;
    //        NSAssert(requestType!=NULL, @"INIT not working");
    [dopamineRequest sendRequest:requestType];
}

@end
