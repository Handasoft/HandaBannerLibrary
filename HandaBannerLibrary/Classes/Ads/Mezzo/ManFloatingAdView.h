//
//  ManFloatingAdView.h
//  ManAdView
//
//  Created by MezzoMedia on 13. 2. 19..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

/* IOS 버전 5.0 부터 지원합니다.
 */

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ManFloatingAdViewDelegate;

/* 플로팅 광고
 */
@interface ManFloatingAdView : UIView

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManFloatingAdViewDelegate>delegate;

/* 광고를 사용하는 유저의 성별 정보.
 남성: @"1"
 여성: @"2"
 */
@property (nonatomic, copy) NSString *gender;

/* 광고를 사용하는 유저의 나이 정보.
 age : @"20"
 */
@property (nonatomic, copy) NSString *age;

/* MAN SDK 사이트에서 발급받은 appID, windowID 입력.
 */
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID;

/* 위치정보를 파악 한다
 bLocationInfo 가 YES 이면 위치정보 파악
 bLocationInfo 의 기본값은 NO
 */
- (void)setLocationInfo:(BOOL)bLocationInfo;

/* 플로팅 광고를 시작한다.
 */
- (void)startFloatingAd:(id)parentView;

/* 스크롤 이벤트 "- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView",
 "(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)"
 함수들을 오버라이딩 해서 각각 함수에서 moveEndFloatingAd를 호출 해준다.
 */
- (void)moveEndFloatingAd:(id)parentView;

/* 광고뷰의 숨김 여부를 SDK에 알려준다, 광고의 검수과정에 필요.
   광고뷰가 숨김 상태가 아니면 "YES" 숨김 상태이면 "NO".
 */
- (void)viewShowState:(BOOL)bShowViewState;

@end


/* 플로팅 배너 프로토콜
 */
@protocol ManFloatingAdViewDelegate <NSObject>

@optional

/* 배너 클릭에 따른 이벤트를 통보.
 */
- (void)adFloatingBannerClick:(ManFloatingAdView*)manFloatingBanner;

/* 광고 노출 준비가 되었음을 통보.
 */
- (void)adFloatingBannerParsingEnd:(ManFloatingAdView*)manFloatingBanner;

/* 광고 수신 성공
 chargedAdType 유료광고 인지 무료광고 인지 구별
 YES 이면 유료 광고, NO 이면 무료 광고.
 */
- (void)didReceiveAd:(ManFloatingAdView*)manFloatingBanner chargedAdType:(BOOL)bChargedAdType;

/* 광고 수신 에러
 */
- (void)didFailReceiveAd:(ManFloatingAdView*)manFloatingBanner errorType:(NSInteger)errorType;

@end