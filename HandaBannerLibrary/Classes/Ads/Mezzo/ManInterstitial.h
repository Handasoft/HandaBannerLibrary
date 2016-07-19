//
//  ManInterstitial.h
//  ManAdView
//
//  Created by mezzomedia on 13. 8. 16..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ManAdDefine.h"

@protocol ManInterstitialDelegate;

/* 전면광고
 */
@interface ManInterstitial : NSObject

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManInterstitialDelegate>delegate;

/* 광고를 사용하는 유저의 성별 정보.
 남성: @"1"
 여성: @"2"
 */
@property (nonatomic, copy) NSString *gender;

/* 광고를 사용하는 유저의 나이 정보.
 age : @"20"
 */
@property (nonatomic, copy) NSString *age;

/* MAN SDK 사이트에서 발급받은 appID 입력
 */
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID;

/* 전면광고 객체생성
 */
+ (ManInterstitial*)shareInstance;

/* 전면광고를 요청한다.
 */
- (void)startInterstitial;

/* 위치정보를 파악 한다
 bLocationInfo 가 YES 이면 위치정보 파악
 bLocationInfo 의 기본값은 NO
 */
- (void)setLocationInfo:(BOOL)bLocationInfo;

@end


/* 전면광고 프로토콜
 */
@protocol ManInterstitialDelegate <NSObject>

@optional

/* 전면 광고 수신 성공
 */
- (void)didReceiveInterstitial;

/* 전면 광고 수신 에러
 */
- (void)didFailReceiveInterstitial:(NSInteger)errorType;

/* 전면 광고 닫기
 */
- (void)didCloseInterstitial;

@end