//
//  MyDopamine.m
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/4/14.
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
                                                 andKey:@"9163194080684f5b4fa074a7c498c8eb6f06d83f"
                                               andToken:@"493245694786310253bf3dfbf572f3b63ee628de"
                     ];
    
    [_dopamineBase addAction:_clickReinforcementButton];
    
    //Modifiable values. These are just examples
    [_dopamineBase addPersistentMetaData:@"Day" andValue:@"Saturday"];
    [_dopamineBase addMetaData:@"firstMetaData" andValue:@"15"];

    //Sending Init Request to the Server
    [_dopamineBase sendInitRequest];
    return self;
}

+(void)track:(NSString *)eventName
{
    [[sharedInstance dopamineBase] track:eventName];
}

+(NSString*)reinforce:(NSString *)eventName
{
    return [[sharedInstance dopamineBase] reinforce:eventName];
}



@end
