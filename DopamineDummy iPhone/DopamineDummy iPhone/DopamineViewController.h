//
//  DopamineViewController.h
//  DopamineDummy iPhone
//
//  Created by Wayne Chi on 9/2/14.
//  Copyright (c) 2014 Dopamine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URIBuilder.h"
#import "MyDopamine.h"

@interface DopamineViewController : UIViewController

//@property (nonatomic, strong) NSString *adLink;
//@property (nonatomic, strong) IBOutlet UIView *adView;
//@property (nonatomic, strong) IBOutlet UIButton *adLinkButton;
//@property (nonatomic, strong) IBOutlet UIImageView *adImageView;


@property (strong, nonatomic) IBOutlet UILabel *response;

- (IBAction)iButton:(id)sender;
- (IBAction)tButton:(id)sender;
- (IBAction)rButton:(id)sender;



//- (void)callAdService;
//- (IBAction)adButtonPushed:(id) sender;

- (id)init;

@end
