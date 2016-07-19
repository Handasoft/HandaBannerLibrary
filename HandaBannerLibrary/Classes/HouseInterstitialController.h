//
//  HouseInterstitialController.h
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseInterstitialViewController.h"
#import "ADData.h"

@class HouseInterstitialController;
@protocol HouseInterstitialControllerDelegate <NSObject>
- (void) onLoadSuccessInterstitial_House:(NSString *)strBannerNo;
- (void) onLoadFailInterstitial_House;
- (void) onClosedInterstitial_House;
- (void) onClickADInterstitial_House:(NSString *)strBannerNo;
@end

@interface HouseInterstitialController : NSObject<HouseInterstitialViewControllerDelegate>{
    BOOL isReady;
    ADData * adData;
}

@property (weak, nonatomic)UIViewController * vcParent;
@property (weak, nonatomic) id<HouseInterstitialControllerDelegate> delegate;

- (void)showAD;
- (void)requestAD;
@end
