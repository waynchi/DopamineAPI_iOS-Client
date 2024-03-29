//
//  DopamineRequest.h
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "URIBuilder.h"
#import "DopamineConstants.h"
@class DopamineBase;

@interface DopamineRequest : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (nonatomic, strong) DopamineBase *dopamineBase;
@property (nonatomic, strong) URIBuilder *uriBuilder;
@property (nonatomic, strong) NSNumber* utcTime;
@property (nonatomic, strong) NSNumber* localTime;


typedef enum{
    INIT=0,
    TRACK=1,
    REWARD=2
} RequestType;

-(id)init:(DopamineBase*) base;
-(NSString*)sendRequest:(RequestType*) requestType andEventName:(NSString*) eventName;

@end

