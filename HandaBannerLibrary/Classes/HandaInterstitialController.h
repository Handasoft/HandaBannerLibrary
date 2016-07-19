//
//  HandaInterstitialController.h
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandaInterstitialViewController.h"
#import "ADData.h"

@class HandaInterstitialController;
@protocol HandaInterstitialControllerDelegate <NSObject>
- (void) onLoadSuccessInterstitial:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo;
- (void) onLoadFailInterstitial;
- (void) onClosedInterstitial;
- (void) onClickADInterstitial:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo;
@end

@interface HandaInterstitialController : NSObject<HandaInterstitialViewControllerDelegate>{
    BOOL isReady;
    ADData * adData;
}

@property (weak, nonatomic)UIViewController * vcParent;
@property (weak, nonatomic) id<HandaInterstitialControllerDelegate> delegate;

- (void)showAD;
- (void)requestAD;
@end
