//
//  MyDopamine.h
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DopamineBase.h"
#import "DopamineAction.h"

@interface MyDopamine : NSObject


@property (nonatomic,strong) DopamineBase* dopamineBase;
// Declare Actions with their ActionNames
@property (nonatomic, strong) DopamineAction* clickReinforcementButton;

// Declare Feedback Function names
@property (nonatomic, strong) NSString* FEEDBACKFUNCTION1;
@property (nonatomic, strong) NSString* FEEDBACKFUNCTION2;
@property (nonatomic, strong) NSString* FEEDBACKFUNCTION3;

// Declare Reward Function names
@property (nonatomic, strong) NSString* REWARDFUNCTION1;
@property (nonatomic, strong) NSString* REWARDFUNCTION2;

+(MyDopamine*)initDopamine;
+(void)track:(NSString*) eventName;
+(NSString*)reinforce:(NSString*) eventName;

@end
