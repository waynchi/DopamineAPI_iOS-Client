//
//  URIBuilder.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
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
//    switch(*type){
//        case INIT:
//            [uri appendString:@"/init/"];
//            break;
//        case TRACK:
//            [uri appendString:@"/track/"];
//            break;
//        case REWARD:
//            [uri appendString:@"/reinforce/"];
//            break;
//    }
    [uri appendString:requestType];
    url = [[NSURL alloc] initWithString:uri];
    return url;
}

@end
