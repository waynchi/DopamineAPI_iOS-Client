//
//  DopamineBase.h
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/4/14.
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
@property (nonatomic, readonly) NSUUID *advertisingIdentifier;
@property (nonatomic, strong) NSString *adid;
@property (nonatomic, strong) DopamineRequest *dopamineRequest;

-(id)initWithAppID:(NSString*)appID andVersionID:(NSString*)versionID andKey:(NSString*)key andToken:(NSString*)token;
-(NSString*) setBuildID;
-(void) setIdent:(NSString*) IDTYPE andUniqueID:(NSString*)uniqueID;
-(void)addAction:(DopamineAction*) action;
-(void)sendInitRequest;
-(void) track:(NSString*) eventName;
-(NSString*)reinforce:(NSString*)eventName;
-(void)setUUID;
-(void)addMetaData:(NSString*) key andValue:(NSObject*) value;
-(void)clearMetaData:(NSString*) key;
-(void)addPersistentMetaData:(NSString*) key andValue:(NSObject*) value;
-(void)clearPersistentMetaData:(NSString*) key;
@end
