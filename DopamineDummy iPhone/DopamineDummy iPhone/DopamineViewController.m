//
//  DopamineViewController.m
//  DopamineDummy iPhone
//
//  Created by Akash Desai on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import "DopamineViewController.h"

@interface DopamineViewController ()

@end

@implementation DopamineViewController

//@synthesize adLink, adLinkButton, adImageView;

- (id)init
{
    self = [super initWithNibName:@"DopamineDummy" bundle:nil];
    if (self) {
        
    
        // Custom initialization.
        
        NSLog(@"Start test Dopamine initilization");
        [MyDopamine initDopamine];
        NSLog(@"End test Dopamine initilization");
        
        // [MyDopamine track:@"Tracking Request"];
        NSLog(@"This is the reinfocement: %@", [MyDopamine reinforce:@"reinforcedBehavior"]);
        
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSAssert(NO, @"Initialize with -init");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self callAdService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)callAdService{
//    //this is a typical url for REST webservice, where you can specify the method that you want to call and the parameters directly with GET
//    NSURL *url = [NSURL URLWithString:@"http://www.YOURWEBSERVER.com/api/adAPI.php?AdID=1"];
//    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    
//    [request setDidFinishSelector:@selector(requestCompleted:)];
//    [request setDidFailSelector:@selector(requestError:)];
//    
//    [request setDelegate:self];
//    [request startAsynchronous];
//}

@end
