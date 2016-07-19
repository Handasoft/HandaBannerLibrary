//
//  ManAdView.h
//  ManAdView
//
//  Created by mezzomedia on 2014. 10. 21..
//  Copyright (c) 2014년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

/* 컨텐츠 광고 모드
 */
#define SMALL_BANNER_ID         @"small_banner"
#define MIDDLE_BANNER_ID        @"middle_banner"
#define CONTENT_BANNER_ID       @"content_banner"

/* 컨텐츠 광고 사이즈별 높이
 */
#define SMALL_BANNER_HEIGHT     50
#define MIDDLE_BANNER_HEIGHT    100
#define CONTENT_BANNER_HEIGHT   200

@protocol ManContentAdViewDelegate;

/* 컨텐츠 광고
 */
@interface ManContentAdView : UIView {
}

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManContentAdViewDelegate>delegate;

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

/* 컨텐츠 광고를 요청한다.
 */
- (void)startBannerAd;

/* 위치정보를 파악 한다
   bLocationInfo 가 YES 이면 위치정보 파악
   bLocationInfo 의 기본값은 NO
 */
- (void)setLocationInfo:(BOOL)bLocationInfo;

@end


/* 컨텐츠 광고 프로토콜
 */
@protocol ManContentAdViewDelegate <NSObject>

@optional

/* 컨텐츠 광고 클릭에 따른 이벤트를 통보.
 */
- (void)contentAdClick:(ManContentAdView*)manContentAdView;

/* 광고 노출 준비가 되었음을 통보.
 */
- (void)contentAdParsingEnd:(ManContentAdView*)manContentAdView;

/* 컨텐츠 광고 수신 에러
 */
- (void)didFailReceiveAd:(ManContentAdView*)manContentAdView errorType:(NSInteger)errorType;

/* 컨텐츠 광고 클릭시 나타났던 랜딩 페이지가 닫힐 경우
 */
- (void)didCloseRandingPage:(ManContentAdView*)manContentAdView;

@end
