//
//  ManMovieAdView.h
//  ManAdView
//
//  Created by mezzomedia on 2014. 5. 28..
//  Copyright (c) 2014년 MezzoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManAdDefine.h"

@protocol ManMovieAdViewDelegate;

@interface ManMovieAdView : UIView

/* 전달받는 뷰컨트롤러의 객체
 */
@property (nonatomic, assign) id<ManMovieAdViewDelegate>delegate;

/* 광고를 사용하는 유저의 성별 정보.
 남성: @"1"
 여성: @"2"
 */
@property (nonatomic, copy) NSString *gender;

/* 광고를 사용하는 유저의 나이 정보.
 age : @"20"
 */
@property (nonatomic, copy) NSString *age;

/* MAN SDK 사이트에서 발급받은 동영상광고의 appID, windowID 입력(필수). categoryID, categoryCd 입력.(매체사 선택입력)
 */
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID;
- (void)applicationID:(NSString*)manAppID adWindowID:(NSString*)adWindowID categoryID:(NSString*)categoryID categoryCD:(NSString*)categoryCD;

/* 동영상 광고를 요청한다.
 */
- (void)startMovieAd;

/* 동영상 광고를 중지한다.
 */
- (void)stopMovieAd;

/* 동영상 광고 ORIENTATION 변경
 */
- (void)setOrientation:(UIInterfaceOrientation)orientation;

/* 동영상 플레이 사이즈 변경
 */
- (void)setScreenMode:(MOVIE_SCREEN_MODE)movieScreenMode;

/* iOS 버전이 7.0 이상일때만 ViewController의 edgesForExtendedLayout를 알려준다
 */
- (void)setEdgesForExtendedLayout:(UIRectEdge)edgesForExtendedLayout NS_AVAILABLE_IOS(7_0);

- (void)requestMovieAdURL;

- (void)requestDidMovieAd;

@end


/* 동영상 광고 프로토콜
*/
@protocol ManMovieAdViewDelegate <NSObject>

@optional

/* 동영상 광고 정보 수신 성공
 */
- (void)didReceiveMovieAd:(ManMovieAdView*)manMovieAdView;

/* 동영상 광고 정보 수신 에러
 */
- (void)didFailReceiveMovieAd:(ManMovieAdView*)manMovieAdView errorType:(NSInteger)errorType;

/* 동영상 광고 종료
 */
- (void)didFinishMovieAd:(ManMovieAdView*)manMovieAdView;

/* 동영상 광고 스킵
 */
- (void)didSkipMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 없음
 */
- (void)didNotExistMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 클릭
 */
- (void)didClickMovieAd:(ManMovieAdView*)manMovieAd;

/* 동영상 광고 URL 전달
 */
- (void)responseMovieAdURL:(ManMovieAdView*)manMovieAd moveieAdURL:(NSString*)moveieAdURL;

/* 랜딩페이지 클로즈버튼 클릭
 */
- (void)didCloseRandingPage:(ManMovieAdView*)manMovieAd;

@end