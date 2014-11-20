//
//  DopamineAction.h
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DopamineAction : NSObject

@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSString *resultFunction;
@property (nonatomic, strong) NSMutableSet *rewardFunctions;
@property (nonatomic, strong) NSMutableSet *feedbackFunctions;

-(id)init:(NSString*) name;
-(void)pairFeedback:(NSString*) functionName;
-(void)pairReward:(NSString*) functionName;
-(NSString*)reinforce;

@end
