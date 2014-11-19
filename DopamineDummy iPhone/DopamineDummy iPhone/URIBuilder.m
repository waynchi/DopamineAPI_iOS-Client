//
//  URIBuilder.m
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "URIBuilder.h"

@implementation URIBuilder

@synthesize appID;

-(id)init:(NSString*) token{
    appID = token;
    return self;
}

-(NSURL*)getURI:(NSString*) requestType{
    NSURL* url;
    NSMutableString *uri = [NSMutableString stringWithString:@"https://api.usedopamine.com/v2/app/"];
    [uri appendString:appID];
    //appends the string of the request type : Init Track Reinforce
    [uri appendString:requestType];
    url = [[NSURL alloc] initWithString:uri];
    NSLog(@"This is the URL: %@" , url);
    return url;
}

@end
