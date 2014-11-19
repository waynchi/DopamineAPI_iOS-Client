//
//  DopamineBase.m
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineBase.h"
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>

@implementation DopamineBase

-(id)initWithAppID:(NSString*)appID andVersionID:(NSString*)versionID andKey:(NSString*)key andToken:(NSString*)token
{
    self = [super init];
    _clientOS = @"iOS";
    [self setBuildID];
    [self setUUID];
    [self setIdent:@"DEVICE_ID" andUniqueID:_adid];
    _clientOSversion = [[UIDevice currentDevice] systemVersion];
    _clientAPIversion = @"1.2.0";
    _appID = appID;
    _versionID = versionID;
    _key = key;
    _token = token;
    
    return self;
}

-(void)addAction:(DopamineAction*) action
{
    if(_actions == NULL)
        _actions = [[NSMutableOrderedSet alloc] init];
    if(_rewardFunctions == NULL)
        _rewardFunctions = [[NSMutableSet alloc] init];
    if(_feedbackFunctions == NULL)
        _feedbackFunctions = [[NSMutableSet alloc] init];
    
    
    [_actions addObject:action];
    NSLog(@"Added Action in Base: %@", action);
    for(NSString* reward in [action rewardFunctions])
    {
        [_rewardFunctions addObject:reward];
        NSLog(@"Added Reward in Base: %@",reward);
    }
    for(NSString* feedback in [action feedbackFunctions])
    {
        [_feedbackFunctions addObject:feedback];

    }
}


-(void) setIdent:(NSString *)IDTYPE andUniqueID:(NSString *)uniqueID
{
    if(self.identity == NULL)
    {
        self.identity = [[NSMutableDictionary alloc] init];
    }
    
    [self.identity setObject:uniqueID forKey:IDTYPE];
}

-(void)setUUID
{
    if(_advertisingIdentifier == nil)
    {
        _advertisingIdentifier = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    }
    if(_adid == nil)
    {
        _adid = [_advertisingIdentifier UUIDString];
    }
}

//Setter function

-(NSString*)setBuildID
{
    NSString *SHA1BuildID;
    NSMutableString *buildID = nil;
    
    //Loop Through actions
    [buildID appendString:(@"pairings:")];
    for(DopamineAction* action in _actions)
    {
        [buildID appendString:(action.actionName)];
        NSLog(@"Adding Action %@", action.actionName);
        //Loop through feedback
        for(NSString* feedback in action.feedbackFunctions)
        {
            [buildID appendString:(feedback)];
            NSLog(@"Adding Feedback %@", feedback);
        }
        for(NSString* reward in action.rewardFunctions)
        {
            [buildID appendString:(reward)];
            NSLog(@"Adding Reward %@", reward);
        }
        //Loop through rewards
    }
    
    //Not sure what we want to happen for a nil string. Right now it returns the nil SHA1 which is
    //da39a3ee5e6b4b0d3255bfef95601890afd80709
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [buildID dataUsingEncoding: NSUTF8StringEncoding]; /* or some other encoding */
    if(CC_SHA1([stringBytes bytes], [stringBytes length], digest))
    {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *buffer = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
            [buffer appendFormat:@"%02x", digest[i]];
        }
        SHA1BuildID = buffer;
        _build = SHA1BuildID;
        return SHA1BuildID;
    }
    return nil;
}


// ///////////////////////////////////
//
// Request functions
//
// ///////////////////////////////////

-(void) sendInitRequest
{
    if(_dopamineRequest == nil)
    {
        _dopamineRequest = [[DopamineRequest alloc] init:self];
    }
    RequestType* requestType = INIT;
    [_dopamineRequest sendRequest:requestType andEventName:@"Init Request"];
}

-(void) track:(NSString *)eventName
{
    if(_dopamineRequest == nil)
    {
        _dopamineRequest = [[DopamineRequest alloc] init:self];
    }
    [_dopamineRequest sendRequest:TRACK andEventName:eventName];
}
-(NSString*) reinforce:(NSString *)eventName
{
    if(_dopamineRequest == nil)
    {
        _dopamineRequest = [[DopamineRequest alloc] init:self];
    }
    return [_dopamineRequest sendRequest:REWARD andEventName:eventName];
}

//+(NSJSONSerialization*) getBaseRequest
//{
//    // put stuff into json object
//    // utc time and local time
//    return nil;
//}
//
//+(NSString*) getInitRequest
//{
//    
//    // put stuff into json object
//    // utc time and local time
//    return nil;
//}

//////////////////////////////////////
//
// Setter functions
//
//////////////////////////////////////

-(void)addMetaData:(NSString*) key andValue:(NSObject*) value
{
    if (_metaData == NULL) {
        _metaData = [[NSMutableDictionary alloc] init];
    }
    [self clearMetaData:key];
    [_metaData setObject:value forKey:key];
    
    
}
-(void)clearMetaData:(NSString*) key
{
    if (_metaData == NULL) return;
    [_metaData removeObjectForKey:key];
    
}
-(void)addPersistentMetaData:(NSString*) key andValue:(NSObject*) value
{
    if (_persistentMetaData == NULL) {
        _persistentMetaData = [[NSMutableDictionary alloc] init];
    }
    [self clearPersistentMetaData:key];
    [_persistentMetaData setObject:value forKey:key];
}
-(void)clearPersistentMetaData:(NSString*) key
{
    if (_persistentMetaData == NULL) return;
    [_persistentMetaData removeObjectForKey:key];
}


@end
