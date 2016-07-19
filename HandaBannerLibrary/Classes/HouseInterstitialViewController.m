//
//  HouseInterstitialViewController.m
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HouseInterstitialViewController.h"
#import "HandaAdController.h"
#import "HandaAdEnvironment.h"
#import "Global.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HouseInterstitialViewController ()

@end

@implementation HouseInterstitialViewController
@synthesize adData;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void) loadView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    ivInterstitial = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [view addSubview:ivInterstitial];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"HandaAd.bundle/handa_close.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"HandaAd.bundle/handa_close_on.png"] forState:UIControlStateHighlighted];
    [closeBtn setFrame:CGRectMake(screenWidth - 45, 45, 45, 45)];
    [closeBtn addTarget:self action:@selector(actionClose:)forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIActivityIndicatorView * indicator;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    indicator.center = CGPointMake(ivInterstitial.frame.size.width/2, ivInterstitial.frame.size.height/2);
    [indicator startAnimating];
    [ivInterstitial addSubview:indicator];
    

    
    ivInterstitial.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [ivInterstitial addGestureRecognizer:tapRecognizer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([adData.strInterstitialImage compare:@""]){
            NSURL * url = [NSURL URLWithString:adData.strInterstitialImage];
            NSData * data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(data != nil){
                    ivInterstitial.image = [[UIImage alloc] initWithData:data];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
            });
        }
    });
}
- (void)viewDidLayoutSubviews{
    [self.view bringSubviewToFront:closeBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - selector

- (void)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self.delegate onClose];
    }];
}

- (void)imageTapped:(UIImageView*)image{
    if(adData){
        [self.delegate onClickAD:adData.strAdNo advertiser:adData.strAdvertiser];
        
        NSURL* redirectToURL = [NSURL URLWithString:adData.strInterstitialLandingUrl];
        [[UIApplication sharedApplication] openURL:redirectToURL];
        
        // 전면을 닫는다
        [self dismissViewControllerAnimated:YES completion:^(void){
            [self.delegate onClose];
        }];
    }
}

@end
