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
                                     json_KEY_string,
                                     json_TOKEN_string
                                     , nil];
    NSArray *credentialValues = [NSArray arrayWithObjects:
                                 [dopamineBase key],
                                 [dopamineBase token],
                                 nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:credentialValues forKeys:credentialFieldNames];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(jsonData);
    return jsonData;
}

-(NSString*)getInitRequest
{
    //GetBase <- Append to Base Init Specific fields (dicitonary)
    //
    NSString *jsonString;
    
    
    return jsonString;
    
}


@end
