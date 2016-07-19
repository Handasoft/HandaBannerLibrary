//
//  HouseInterstitialController.m
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HouseInterstitialController.h"
#import "HandaAdController.h"
#import "Global.h"
#import "HandaAdEnvironment.h"

@implementation HouseInterstitialController
@synthesize vcParent;

- (void)showAD{
    if(isReady){
        HouseInterstitialViewController * v = [[HouseInterstitialViewController alloc] init];
        v.adData = adData;
        v.delegate = self;
        [vcParent presentViewController:v animated:YES completion:nil];
    }
}
- (void)requestAD{
    isReady = NO;    
    NSArray * array = [HandaAdController Access].arrHouseAdList;
    adData = [array objectAtIndex:arc4random() % array.count];
    if(adData){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([adData.strInterstitialImage compare:@""]){
                NSURL * url = [NSURL URLWithString:adData.strInterstitialImage];
                NSData * data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(data != nil){
                        isReady = YES;
                        [self.delegate onLoadSuccessInterstitial_House:adData.strAdNo];
                    }else{
                        [self.delegate onLoadFailInterstitial_House];
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate onLoadFailInterstitial_House];
                });
            }
        });
    }else{
        [self.delegate onLoadFailInterstitial_House];
    }
}

#pragma mark - HouseInterstitialViewControllerDelegate

- (void)onClose{
    [self.delegate onClosedInterstitial_House];
}

- (void) onClickAD:(NSString *)strAppNo advertiser:(NSString *)strAdvertiserNo{
    [self.delegate onClickADInterstitial_House:strAppNo];
}

@end
