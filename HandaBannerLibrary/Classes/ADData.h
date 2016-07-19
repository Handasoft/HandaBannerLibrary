//
//  ADData.h
//  HandaAd
//
//  Created by 개발1팀_김덕기 on 2016. 1. 20..
//  Copyright © 2016년 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADData : NSObject

@property (strong, nonatomic) NSString * strAdNo;
@property (strong, nonatomic) NSString * strAdvertiser;
@property (strong, nonatomic) NSString * strBannerLandingUrl;
@property (strong, nonatomic) NSString * strInterstitialLandingUrl;
@property (strong, nonatomic) NSString * strBannerImage;
@property (strong, nonatomic) NSString * strBannerBgColor;
@property (strong, nonatomic) NSString * strInterstitialImage;
@property (nonatomic) int nAdType;      //비트연산
@property (nonatomic) int nBannerAdType;//배너 노출 형태 1:비율유지+좌우 여백채우기 2:확대

@end
