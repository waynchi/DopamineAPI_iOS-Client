//
//  DopamineAction.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineAction.h"

@implementation DopamineAction

-(id)init:(NSString*) name
{
    _actionName = name;
    // need some way to automatically add this DopamineAction to [DopamineBase actions]
    
    return self;
}

-(void)pairFeedback:(NSString*) functionName
{
    if(_feedbackFunctions == NULL)
        _feedbackFunctions = [[NSMutableSet alloc] init];
    
    [_feedbackFunctions addObject:functionName];
}

-(void)pairReward:(NSString*) functionName
{
    if(_rewardFunctions == NULL)
        _rewardFunctions = [[NSMutableSet alloc] init];
    
    [_rewardFunctions addObject:functionName];
}

-(NSString*)reinforce
{
    // finsih this
    return _resultFunction;
}

@end
