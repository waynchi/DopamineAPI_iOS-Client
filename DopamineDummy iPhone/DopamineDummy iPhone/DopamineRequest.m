//
//  DopamineRequest.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineRequest.h"
#import "DopamineBase.h"
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>

@implementation DopamineRequest

@synthesize dopamineBase, uriBuilder;

-(id)init:(DopamineBase*) base{
    self = [super init];
    dopamineBase = base;
    uriBuilder = [[URIBuilder alloc] init:[dopamineBase appID]];
    [self setUUID];
    return self;
}

-(void)sendRequest:(RequestType*) requestType{
    NSURL* url = [NSURL alloc];
    
    if(requestType == INIT)
        url = [uriBuilder getURI:@"/init/"];
    else if (requestType == TRACK)
        url = [uriBuilder getURI:@"/track/"];
    else if (requestType == REWARD)
        url = [uriBuilder getURI:@"/reinforce/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *jsonString;
    if(requestType == INIT)
        jsonString = [self getInitRequest];
    else if (requestType == TRACK)
        url = [uriBuilder getURI:@"/track/"];
    else if (requestType == REWARD)
        url = [uriBuilder getURI:@"/reinforce/"];
   
    
    [request setValue:[NSString stringWithFormat:@"%d", [jsonString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSURLConnection *connection = [[NSURLConnection alloc] init];
//    [connection initWithRequest:request delegate:self startImmediately:YES];
    NSData* responseData;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
    
    NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //To Debug buildID
    NSLog(@"This is %@", [self getBuildID]);
    
    // parse response
    NSLog(response);
    
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

-(NSData*)getBaseRequest
{
    NSArray *credentialFieldNames = [NSArray arrayWithObjects:
                                     json_CLIENTOS_string,
                                     json_CLIENTOSVERSION_int,
                                     json_CLIENTAPIVERSION_string,
                                     json_KEY_string,
                                     json_TOKEN_string,
                                     json_VERSIONID_string,
                                     //json_IDENTITY_keyvaluearray,
                                     json_BUILD_string,
                                     json_UTC_long,
                                     json_LOCALTIME_long,
                                     nil];
    //Setting Times
    long utcTime = CFAbsoluteTimeGetCurrent();
    long localTime = utcTime + [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:([NSDate date])];
    
     _utcTime = [[NSNumber alloc] initWithLong:utcTime];
    _localTime =[[NSNumber alloc] initWithLong:localTime];
    
    
    
    
    NSArray *credentialValues = [NSArray arrayWithObjects:
                                 [dopamineBase clientOS],
                                 [dopamineBase clientOSversion],
                                 [dopamineBase clientAPIversion],
                                 [dopamineBase key],
                                 [dopamineBase token],
                                 [dopamineBase versionID],
                                 //[dopamineBase identity],
                                 [dopamineBase build],
                                 _utcTime,
                                 _localTime,
                                 nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:credentialValues forKeys:credentialFieldNames];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", jsonData);
    return jsonData;
}

-(NSString*)getInitRequest
{
    //GetBase <- Append to Base Init Specific fields (dicitonary)
    NSMutableString *jsonString;
    
    NSArray *initFieldNames = [NSArray arrayWithObjects:
                           json_REWARDFUNCTIONS_stringarray,
                           json_FEEDBACKFUNCTIONS_stringarray
                           , nil];
    NSArray *initValues = [NSArray arrayWithObjects:
                           [dopamineBase rewardFunctions],
                           [dopamineBase feedbackFunctions]
                           , nil];
    
    
    //NSDictionary* initDict = [NSDictionary dictionaryWithObjects:initValues forKeys:initFieldNames];
    
    //Completely wrong
    NSMutableData* base = [[NSMutableData alloc] initWithData:([self getBaseRequest])];
    
    NSError* error;
    //NSData* initRequest = [NSJSONSerialization dataWithJSONObject:initDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //[base appendData:initRequest];
    
    jsonString = [[NSMutableString alloc] initWithData:base encoding:NSUTF8StringEncoding];
    
    [jsonString appendString:[self getBuildID]];
    
   // NSLog(@"%@", jsonString);
    
    return jsonString;
    
}

-(NSString*)getBuildID
{
    NSString *SHA1BuildID;
    NSMutableString *buildID = nil;
    
    //Loop Through actions
    [buildID appendString:(@"pairings:")];
    for(DopamineAction* action in dopamineBase.actions)
    {
        [buildID appendString:(action.actionName)];
        NSLog(@"Adding Action %@", action.actionName);
        //Loop through feedback
        for(NSString* feedback in action.feedbackFunctions)
        {
            [buildID appendString:(feedback)];
            [buildID appendString:@"Feedback"];
            NSLog(@"Adding Feedback %@", feedback);
        }
        for(NSString* reward in action.rewardFunctions)
        {
            [buildID appendString:(reward)];
            [buildID appendString:@"Reward"];
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
        return SHA1BuildID;
    }
    return nil;
}


@end
