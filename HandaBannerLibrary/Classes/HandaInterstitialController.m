//
//  HandaInterstitialController.m
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaInterstitialController.h"
#import "HandaAdController.h"
#import "Global.h"
#import "HandaAdEnvironment.h"

@implementation HandaInterstitialController
@synthesize vcParent;

- (void)showAD{
    if(isReady){
        HandaInterstitialViewController * v = [[HandaInterstitialViewController alloc] init];
        v.adData = adData;
        v.delegate = self;
        [vcParent presentViewController:v animated:YES completion:nil];
    }
}
- (void)requestAD{
    isReady = NO;    
    NSArray * array = [HandaAdController Access].arrHandaAdList;
    if(array != nil && array.count > 0){
        adData = [array objectAtIndex:arc4random() % array.count];
        if(adData){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if([adData.strInterstitialImage compare:@""]){
                    NSURL * url = [NSURL URLWithString:adData.strInterstitialImage];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(data != nil){
                            isReady = YES;
                            [self.delegate onLoadSuccessInterstitial:adData.strAdNo advertiser:adData.strAdvertiser];
                        }else{
                            [self.delegate onLoadFailInterstitial];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate onLoadFailInterstitial];
                    });
                }
            });
        }else{
            [self.delegate onLoadFailInterstitial];
        }
    }else{
        [self.delegate onLoadFailInterstitial];
    }
}

#pragma mark - HandaInterstitialViewControllerDelegate

- (void)onClose{
    [self.delegate onClosedInterstitial];
}

- (void) onClickAD:(NSString *)strAppNo advertiser:(NSString *)strAdvertiserNo{
    NSLog(@"onClickAD strAppNo %@ strAdvertiserNo %@", strAppNo, strAdvertiserNo);
    [self.delegate onClickADInterstitial:strAppNo advertiser:strAdvertiserNo];
}

@end
