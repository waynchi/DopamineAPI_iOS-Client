//
//  URIBuilder.h
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URIBuilder : NSObject

@property (nonatomic, strong) NSString *appID;

//typedef enum{
//    INIT,
//    TRACK,
//    REWARD
//} URItype;

-(id)init:(NSString*) token;
-(NSURL*)getURI:(NSString*) requestType;

@end
