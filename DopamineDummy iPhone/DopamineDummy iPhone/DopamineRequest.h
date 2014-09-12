//
//  DopamineRequest.h
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URIBuilder.h"
#import "DopamineConstants.h"
@class DopamineBase;

@interface DopamineRequest : NSObject

@property (nonatomic, strong) DopamineBase *dopamineBase;
@property (nonatomic, strong) URIBuilder *uriBuilder;

typedef enum{
    INIT=0,
    TRACK=1,
    REWARD=2
} RequestType;

-(id)init:(DopamineBase*) base;
-(void)sendRequest:(RequestType*) requestType;

@end
