//
//  DopamineBase.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/4/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineBase.h"

@implementation DopamineBase

-(id)initWithAppID:(NSString*)appID andVersionID:(NSString*)versionID andKey:(NSString*)key andToken:(NSString*)token
{
    self = [super init];
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
    
    [_actions addObject:action];
}


// ///////////////////////////////////
//
// Request functions
//
// ///////////////////////////////////

-(void) sendInitRequest
{
    DopamineRequest* dopamineRequest = [[DopamineRequest alloc] init:self];
    RequestType* requestType = INIT;
    //        NSAssert(requestType!=NULL, @"INIT not working");
    [dopamineRequest sendRequest:requestType];
}

+(NSJSONSerialization*) getBaseRequest
{
    // put stuff into json object
    // utc time and local time
    return nil;
}

+(NSString*) getInitRequest
{
    
    // put stuff into json object
    // utc time and local time
    return nil;
}

@end
