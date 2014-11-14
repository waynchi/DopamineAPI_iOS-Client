//
//  DopamineRequest.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineRequest.h"
#import "DopamineBase.h"
#include <CommonCrypto/CommonDigest.h>

@implementation DopamineRequest

@synthesize dopamineBase, uriBuilder;

-(id)init:(DopamineBase*) base{
    self = [super init];
    dopamineBase = base;
    uriBuilder = [[URIBuilder alloc] init:[dopamineBase appID]];
    return self;
}

#pragma mark NSURLConnection Delegate Methods

/*- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    NSLog(@"Received a Response");
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    NSLog(@"Received Data");
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString* dataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Connection Finished Loading With a Response: %@", dataString);
    [dopamineBase processResponse:dataString];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"There was an error");
}*/

-(NSString*)sendRequest:(RequestType*) requestType andEventName:(NSString *)eventName{
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
    NSString *requestString = eventName;
    if(requestType == INIT)
        jsonString = [self getInitRequest];
    else if (requestType == TRACK)
        jsonString = [self getTrackRequest:requestString];
    else if (requestType == REWARD)
        jsonString = [self getReinforceRequest:requestString];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create url connection and fire request
  //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //NSURLRequest * urlRequest = [NSURLRequest re];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        if(requestType == REWARD)
        {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                  error:&error];
       
            NSString* dataString = [[NSString alloc] initWithString: [dataDict objectForKey:@"reinforcementFunction"]];
            NSLog(@"Response is %@", dataString);
            return dataString;
        }
        return @"NULL";
    }
    
    NSLog(@"There was a connection error");
    return @"Failure";
   
    
    /*[request setValue:[NSString stringWithFormat:@"%d", [jsonString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSURLConnection *connection = [[NSURLConnection alloc] init];
    //[connection initWithRequest:request delegate:self startImmediately:YES];
    NSData* responseData;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
    
    NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //To Debug buildID
    NSLog(@"This is %@", [self getBuildID]);
    
    // parse response
    NSLog(@"This is the Response: %@", response);*/
    
}

-(NSDictionary*)getBaseRequest
{
    NSArray *credentialFieldNames = [NSArray arrayWithObjects:
                                     json_CLIENTOS_string,
                                     json_CLIENTOSVERSION_int,
                                     json_CLIENTAPIVERSION_string,
                                     json_KEY_string,
                                     json_TOKEN_string,
                                     json_VERSIONID_string,
                                     json_IDENTITY_keyvaluearray,
                                     json_BUILD_string,
                                     json_UTC_long,
                                     json_LOCALTIME_long,
                                     nil];
    //Setting Times
    long utcTime = CFAbsoluteTimeGetCurrent();
    long localTime = utcTime + [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:([NSDate date])];
    
     _utcTime = [[NSNumber alloc] initWithLong:utcTime];
    _localTime =[[NSNumber alloc] initWithLong:localTime];
    
    
    //Turning Identity into a NSDictionary from a NSMutableDictionary
    
    NSDictionary* identity = [[NSDictionary alloc] initWithDictionary:[dopamineBase identity]];
    
    NSArray* keyArray = [identity allKeys];
    NSArray* valueArray = [identity allValues];
    NSMutableArray* mutableIdentityArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [keyArray count]; i++)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[valueArray objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
        [mutableIdentityArray addObject:tempDict];
    }
    
   // NSArray* identityArray = [[NSArray alloc] initWithObjects:mutableIdentityArray, nil];
    
    
    NSNumber *OSversion = [[NSNumber alloc] initWithDouble:[[dopamineBase clientOSversion] doubleValue]];
    NSLog(@"double vale %@", OSversion);
    
    
    NSArray *credentialValues = [NSArray arrayWithObjects:
                                 [dopamineBase clientOS],
                                 OSversion, //Do you want this to be a number or a string.
                                 [dopamineBase clientAPIversion],
                                 [dopamineBase key],
                                 [dopamineBase token],
                                 [dopamineBase versionID],
                                 mutableIdentityArray,
                                 [dopamineBase build],
                                 _utcTime,
                                 _localTime,
                                 nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:credentialValues forKeys:credentialFieldNames];
    
    NSLog(@"Base Dictionary : %@", dict);
    
    //Changed slightly to return the NSDictionary instead
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    return dict;
}

-(NSString*)getInitRequest
{
    //GetBase <- Append to Base Init Specific fields (dicitonary)
    NSMutableString *jsonString;
    NSError* error;
    
    NSMutableDictionary* initDict = [[NSMutableDictionary alloc] initWithDictionary:[self getBaseRequest]];
    NSArray* rewardArray = [[NSArray alloc] initWithArray:[[dopamineBase rewardFunctions] allObjects]];
    NSArray* feedbackArray = [[NSArray alloc] initWithArray:[[dopamineBase feedbackFunctions] allObjects]];

    [initDict setObject:rewardArray   forKey:json_REWARDFUNCTIONS_stringarray];
    [initDict setObject:feedbackArray forKey:json_FEEDBACKFUNCTIONS_stringarray];
    
    //Action Pairing
    NSMutableArray* actionPairingArray = [[NSMutableArray alloc] init];
    
    for(DopamineAction* action in [dopamineBase actions])
    {
        NSMutableDictionary* actionPairingDict = [[NSMutableDictionary alloc] init];
        [actionPairingDict setObject:[action actionName] forKey:json_ACTIONNAME_string];
        NSMutableArray* reinforcersArray = [[NSMutableArray alloc] init];
        
        for(NSString* feedbackName in [action feedbackFunctions])
        {
            NSMutableDictionary* feedbackDict = [[NSMutableDictionary alloc] init];
            [feedbackDict setObject:feedbackName forKey:json_PAIREDFUNCTIONNAME_string];
            [feedbackDict setObject:@"Feedback" forKey:json_PAIREDFUNCTIONTYPE_string];
            [feedbackDict setObject:[[NSArray alloc] init] forKey:json_PAIREDFUNCTIONOBJECTIVES_stringarray];
            [feedbackDict setObject:[[NSArray alloc] init] forKey:json_PAIREDFUNCTIONCONSTRAINTS_stringarray];
            [reinforcersArray addObject: feedbackDict];
        }
        for(NSString* rewardName in [action rewardFunctions])
        {
            NSMutableDictionary* rewardDict = [[NSMutableDictionary alloc] init];
            [rewardDict setObject:rewardName forKey:json_PAIREDFUNCTIONNAME_string];
            [rewardDict setObject:@"Reward" forKey:json_PAIREDFUNCTIONTYPE_string];
            [rewardDict setObject:[[NSArray alloc] init] forKey:json_PAIREDFUNCTIONOBJECTIVES_stringarray];
            [rewardDict setObject:[[NSArray alloc] init] forKey:json_PAIREDFUNCTIONCONSTRAINTS_stringarray];
            [reinforcersArray addObject: rewardDict];
        }
        
        [actionPairingDict setObject:reinforcersArray forKey:json_PAIREDFUNCTION_jsonarray];
        
        [actionPairingArray addObject:actionPairingDict];
    }
    

    [initDict setObject:actionPairingArray forKey:json_ACTIONPAIRINGS_jsonarray];
   // NSMutableData* base = [[NSMutableData alloc] initWithData:([self getBaseRequest])];
    
    NSData* initRequest = [NSJSONSerialization dataWithJSONObject:initDict options:NSJSONWritingPrettyPrinted error:&error];
    
    //[base appendData:initRequest];
    
    jsonString = [[NSMutableString alloc] initWithData:initRequest encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Init Request: %@", jsonString);
    
    return jsonString;
    
}

-(NSString*)getTrackRequest: (NSString*) eventName
{
    NSString* jsonString;
    NSError* error;
    
    
    NSArray* keyArray = [[dopamineBase metaData] allKeys];
    NSArray* valueArray = [[dopamineBase metaData] allValues];
    NSMutableArray* mutableMetaDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [keyArray count]; i++)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[valueArray objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
        [mutableMetaDataArray addObject:tempDict];
    }
    
    NSArray* pKeyArray = [[dopamineBase persistentMetaData] allKeys];
    NSArray* pValueArray = [[dopamineBase persistentMetaData] allValues];
    NSMutableArray* mutablePMetaDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [pKeyArray count]; i++)
    {
        NSMutableDictionary* PTempDict = [[NSMutableDictionary alloc] init];
        [PTempDict setObject:[pValueArray objectAtIndex:i] forKey:[pKeyArray objectAtIndex:i]];
        [mutablePMetaDataArray addObject:PTempDict];
    }
    
    [mutableMetaDataArray addObject:mutablePMetaDataArray];
    
    
    //Creating MetaData JSONString
    NSData* metaDataData = [NSJSONSerialization dataWithJSONObject:mutableMetaDataArray options:NSJSONWritingPrettyPrinted error:&error];
    
    //Creating trackDict
    NSMutableDictionary* trackDict = [[NSMutableDictionary alloc] initWithDictionary:[self getBaseRequest]];
    [trackDict setObject:eventName forKey:json_EVENTNAME_string];
    [trackDict setObject:mutableMetaDataArray forKey:json_METADATA_keyvaluearray];
    
    NSData* trackRequest = [NSJSONSerialization dataWithJSONObject:trackDict options:NSJSONWritingPrettyPrinted error:&error];
    
    jsonString = [[NSMutableString alloc] initWithData:trackRequest encoding:NSUTF8StringEncoding];
    
    if([dopamineBase metaData] != NULL)
    {
        [[dopamineBase metaData] removeAllObjects];
    }
    
    NSLog(@"This is the Track Request: %@", jsonString);
    
    return jsonString;
}

-(NSString*)getReinforceRequest: (NSString*) eventName
{
    NSString* jsonString;
    NSError* error;
    
    
    NSArray* keyArray = [[dopamineBase metaData] allKeys];
    NSArray* valueArray = [[dopamineBase metaData] allValues];
    NSMutableArray* mutableMetaDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [keyArray count]; i++)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:[valueArray objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
        [mutableMetaDataArray addObject:tempDict];
    }
    
    NSArray* pKeyArray = [[dopamineBase persistentMetaData] allKeys];
    NSArray* pValueArray = [[dopamineBase persistentMetaData] allValues];
    NSMutableArray* mutablePMetaDataArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [pKeyArray count]; i++)
    {
        NSMutableDictionary* PTempDict = [[NSMutableDictionary alloc] init];
        [PTempDict setObject:[pValueArray objectAtIndex:i] forKey:[pKeyArray objectAtIndex:i]];
        [mutablePMetaDataArray addObject:PTempDict];
    }
    
    [mutableMetaDataArray addObject:mutablePMetaDataArray];
    
    
    //Creating MetaData JSONString
    NSData* metaDataData = [NSJSONSerialization dataWithJSONObject:mutableMetaDataArray options:NSJSONWritingPrettyPrinted error:&error];
    
    //Creating trackDict
    NSMutableDictionary* reinforceDict = [[NSMutableDictionary alloc] initWithDictionary:[self getBaseRequest]];
    [reinforceDict setObject:eventName forKey:json_EVENTNAME_string];
    [reinforceDict setObject:mutableMetaDataArray forKey:json_METADATA_keyvaluearray];
    
    NSData* reinforceRequest = [NSJSONSerialization dataWithJSONObject:reinforceDict options:NSJSONWritingPrettyPrinted error:&error];
    
    jsonString = [[NSMutableString alloc] initWithData:reinforceRequest encoding:NSUTF8StringEncoding];
    
    if([dopamineBase metaData] != NULL)
    {
        [[dopamineBase metaData] removeAllObjects];
    }
    
    NSLog(@"This is the Reinforce Request: %@", jsonString);
    
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
    NSData *stringBytes = [buildID dataUsingEncoding: NSUTF8StringEncoding]; // or some other encoding
    if(CC_SHA1([stringBytes bytes], [stringBytes length], digest))
    {
        // SHA-1 hash has been calculated and stored in 'digest'.
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
