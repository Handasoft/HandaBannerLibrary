//
//  ADBanner.h
//  ADBanner
//
//  Created by MezzoMedia on 13. 2. 1..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ADBannerDelegate;

/* 배너 광고
 */
@interface ADBanner : UIView {
}

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ADBannerDelegate>delegate;

/* 광고를 사용하는 유저의 성별 정보.
 남성: @"1"
 여성: @"2"
 */
@property (nonatomic, copy) NSString *gender;

/* 광고를 사용하는 유저의 나이 정보.
 age : @"20"
 */
@property (nonatomic, copy) NSString *age;

/* MAN SDK 사이트에서 발급받은 appID, windowID 입력(필수). 광고형태, 랜딩페이지를 띄울 뷰 세팅(선택옵션)
 */
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID;
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID useReachMedia:(BOOL*)useReachMedia useGotoSafari:(BOOL*)useGotoSafari;

/* 배너광고를 요청한다. (광고가 보이게 될 경우)
 */
- (void)startBannerAd;

/* 배너광고를 중지한다. (광고가 안보이게 될 경우)
 */
- (void)stopBannerAd;

/* 광고뷰의 숨김 여부를 SDK에 알려준다, 광고의 검수과정에 필요.
   광고뷰가 숨김 상태가 아니면 "YES" 숨김 상태이면 "NO".
 */
- (void)viewShowState:(BOOL)bShowViewState;

/* 위치정보를 파악 한다
   bLocationInfo 가 YES 이면 위치정보 파악 
   bLocationInfo 의 기본값은 NO
 */
- (void)setLocationInfo:(BOOL)bLocationInfo;

@end


/* 배너 프로토콜
 */
@protocol ADBannerDelegate <NSObject>

@optional

/* 배너 클릭에 따른 이벤트를 통보.
 */
- (void)adBannerClick:(ADBanner*)adBanner;

/* 광고 노출 준비가 되었음을 통보.
 */
- (void)adBannerParsingEnd:(ADBanner*)adBanner;

/* 광고 수신 성공
 chargedAdType 유료광고 인지 무료광고 인지 구별
 YES 이면 유료 광고, NO 이면 무료 광고.
 */
- (void)didReceiveAd:(ADBanner*)adBanner chargedAdType:(BOOL)bChargedAdType;

/* 배너 광고 수신 에러
 */
- (void)didFailReceiveAd:(ADBanner*)adBanner errorType:(NSInteger)errorType;

/* 배너 광고 클릭시 나타났던 랜딩 페이지가 닫힐 경우
 */
- (void)didCloseRandingPage:(ADBanner*)adBanner;

@end
