//
//  HandaAd.h
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaulyAdView.h"
#import "CaulyInterstitialAd.h"

#import "TadCore.h"
#import "ADBanner.h"
#import "ManInterstitial.h"
#import "HandaBannerView.h"
#import "HandaInterstitialController.h"
#import "HouseInterstitialController.h"
#import "IMBanner.h"
#import "IMInterstitial.h"
#import "IMBannerDelegate.h"
#import "IMInterstitialDelegate.h"
#import "IMRequestStatus.h"
#import "HouseBannerView.h"


@interface HandaAd : NSObject<CaulyAdViewDelegate, CaulyInterstitialAdDelegate, TadDelegate, ADBannerDelegate, ManInterstitialDelegate, HandaBannerViewDelegate, HandaInterstitialControllerDelegate, HouseBannerViewDelegate, HouseInterstitialControllerDelegate, IMBannerDelegate, IMInterstitialDelegate>{
    UIViewController * vcParent;
    
    NSString * strClassName;
    UIView * viewForAD;
    
    //카울리
    CaulyAdView * caulyBanner;
    CaulyInterstitialAd * caulyInterstitial;
    //TAD

    //AdView tadBanner;
    //AdInterstitial tadInterstitial;
    //메조미디어
    ADBanner * mezzoBanner;
    //AdInterstitialView mezzoInterstitial;
    
    //인모비
    IMBanner * inmobiBanner;
    IMInterstitial * inmobiInterstitial;
    //한다소프트
    HandaBannerView * handaBanner;
    HandaInterstitialController * handaInterstitial;
    //하우스
    HouseBannerView * houseBanner;
    HouseInterstitialController * houseInterstitial;
}
@property (nonatomic)BOOL allowMultipleShow;
@property (nonatomic)BOOL isCalledInternal;          //내부에서 호출 했는지
@property (nonatomic)BOOL isAlreadyShowInterstitial;
@property (nonatomic)BOOL isShowingInterstitial;     //전면 배너가 노출 중 인지(전면배너로 인한 onPause시 nextAD 무시하기위해)
@property (nonatomic)BOOL isAutoLayout;
//@property (strong, nonatomic)TadCore * tadController;
@property (strong, nonatomic)TadCore * tadBanner;
@property (strong, nonatomic)TadCore * tadInterstitial;
@property (strong, nonatomic)ADBanner * mezzoBanner;

//- (void) nextAD;
- (void)attachBannerAD:(UIViewController*)vc parentView:(UIView*)view calledClass:(NSString*)strName;
- (void) showInterstitial:(UIViewController*)vc calledClass:(NSString*)strName;
- (void)showRecommendApp:(UIViewController*)vc;
@end
