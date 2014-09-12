//
//  DopamineBase.h
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DopamineAction.h"
#import "DopamineRequest.h"

@interface DopamineBase : NSObject

// Data objects
@property (nonatomic, strong) NSString* appID;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* versionID;
@property (nonatomic, strong) NSString* build;
@property (nonatomic, strong) NSMutableSet* rewardFunctions;
@property (nonatomic, strong) NSMutableSet* feedbackFunctions;
@property (nonatomic, strong) NSMutableOrderedSet* actions;
@property (nonatomic, strong) NSMutableDictionary* identity;
@property (nonatomic, strong) NSMutableDictionary* metaData;
@property (nonatomic, strong) NSMutableDictionary* persistentMetaData;
@property (nonatomic, strong) NSString* clientOS;
@property (nonatomic, strong) NSString* clientOSversion;
@property (nonatomic, strong) NSString* clientAPIversion;

-(id)initWithAppID:(NSString*)appID andVersionID:(NSString*)versionID andKey:(NSString*)key andToken:(NSString*)token;
//+(NSArray*) reinforce:(DopamineAction*) action;
-(void) track:(NSString*) eventName;
-(void)addAction:(DopamineAction*) action;

@end
