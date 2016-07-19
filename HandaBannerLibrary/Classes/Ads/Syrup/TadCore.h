//
//  TadCore.h
//  TadCore
//
//  Created by SK 플래닛 on 13. 2. 4..
//  Copyright (c) 2013년 SK 플래닛. All rights reserved.
//

/* Tad 의 모든 광고를 관리 한다. */

// 슬롯 설정
typedef enum {
    TadSlotNone = 0,
    TadSlotInline = 2,
    TadSlotInterstitial = 3,
    TadSlotFloating100 = 4,
    TadSlotFloating150 = 101
}TadSlot;

typedef enum {
    NO_AD,                              // 광고 서버에서 송출 가능한 광고가 없는 경우
    MISSING_REQUIRED_PARAMETER_ERROR,   // 필수 파라메터 누락된 경우
    INVAILD_PARAMETER_ERROR,            // 잘못된 파라메터인 경우
    UNSUPPORTED_DEVICE_ERROR,           // 미지원 단말인 경우
    CLIENTID_DENIED_ERROR,              // 지정한 Client ID가 유효하지 않은 경우
    INVAILD_SLOT_NUMBER,                // 지정한 슬롯 번호가 유효하지 않은 경우
    CONNECTION_ERROR,                   // 네트워크 연결이 가능하지 않은 경우
    NETWORK_ERROR,                      // 광고의 수신 및 로딩 과정에서 네트워크 오류가 발생한 경우
    RECEIVE_AD_ERROR,                   // 광고를 수신하는 과정에서 에러가 발생한 경우
    LOAD_ERROR,                         // SDK에서 허용하는 시간 내에 광고를 재요청한 경우
    SHOW_ERROR,                         // 노출할 광고가 없는 경우
    INTERNAL_ERROR,                      // 광고의 수신 및 로딩 과정에서 내부적으로 오류가 발생한 경우
    ALREADY_SHOWN,                      // 이미 광고가 표시되어있는 경우(플로팅)
    NOT_INLINE_SHOW,                       // 띠 배너일 경우 show 기능 방지
    NOT_LOAD_AD,                 //로드된 광고가 없을경우.
    UNKNOWN_SEEDVIEWCONTROLLER // 부모뷰컨트롤러가 없을 경우.
}TadErrorCode;


#import <Foundation/Foundation.h>

@protocol TadDelegate;
@class TadRootViewController;
@interface TadCore : NSObject

/* 초기화 */
- (id)initWithSeedView:(UIView *)aSeedView delegate:(id <TadDelegate>)aDelegate;

/* 유저 메소드 */
- (void)getAdvertisement;                                               // 광고를 받는다. (광고 시작)
- (void)destroyAd;                                                       // 광고를 없앤다. (seedView의 background color 복구 여부 설정)
- (void)bringSubviewToFront:(UIView *)view;                             // 뷰를 최상위로 올린다.
- (BOOL)canLoadInterstitial;                                            // 전면 광고가 호출이 가능한지 아닌지 판단.
- (void)setLogMode:(BOOL)isLogMode;                                     // 로그를 보여줄지 아닐지 결정한다.
- (void)viewWillAppear:(BOOL)animated;                                  // viewWillAppear 호출
- (void)viewWillDisappear:(BOOL)animated;                               // viewWillDisappear 호출
- (void)setAdState:(BOOL)isPause;
//- (BOOL)loadAd;                                                         // 광고를 수동으로 load (autorefresh가 NO일 경우)
- (BOOL)showAd;                                                         // 광고를 수동으로 show (loadAd가 호출 되었고 autorefresh가 NO일 경우)
- (void)stopAd;                                                         // 광고를 정지함(View가 remove됨)
- (void)pauseAd;                                                        // autorefresh가 YES이고 inline 광고인 경우 광고 자동 갱신을 일시 정지
- (void)resumeAd;                                                       // 광고 자동 갱신이 일시 정지된 경우 resumeAd를 호출시 자동 갱신이 다시 실행
- (void)setAutoRefersh:(BOOL)isAutoRefersh;                             // 광고 자동 갱신 기능 여부를 설정(Default = YES)

@property (nonatomic, assign) UIViewController  *seedController;         // 윈도우의 루트컨트롤러
@property (nonatomic, assign) UIView            *seedView;               // 개발자가 광고를 붙일 뷰
@property (nonatomic, assign) id <TadDelegate>  delegate;                // Tad 의델리게이트
@property (nonatomic, assign) BOOL isReady;
/* 개발자 셋팅 필요 */

// required
@property (nonatomic, retain) NSString  *clientID;                       // 클라이언트 아이디
@property (nonatomic, assign) TadSlot   slotNo;                          // 개발자가 슬롯을 선택한다.
@property (nonatomic, assign) BOOL      isMediation;                     // MEdiation 여부

// optional
@property (nonatomic, assign) BOOL      isTest;                          // YES : 테스트 서버, NO : 운영서버 (Default : YES)

@property (nonatomic, assign) CGPoint   offset;                          // 광고의 위치를 결정한다. (Default (0, 0))
@property (nonatomic, assign) CGFloat   refershInterval;                 // 리프레쉬 타이밍 (15~60sec Default : 20sec)
@property (nonatomic, retain) NSString *inlineAutoInterval;
@property (nonatomic, assign) int autoClose; // floating 자동닫힘 타이밍 (미정~미정sec)
@property (nonatomic, assign) BOOL isAutoClose;
@property (nonatomic, assign) BOOL      useBackFillColor;                // Inline일 경우 광고뒤 배경색 사용 여부
@property (nonatomic, assign) BOOL autoCloseWhenNoInteraction; //전면 광고 노출 후 5초에 닫힘
@property (nonatomic, assign) BOOL autoCloseAfterLeaveApplication; // 랜딩페이지 호출 후 닫힘

@property (nonatomic, retain) UIView            *inlineView;
@property (nonatomic, retain) UIViewController *seedViewController;
@property (nonatomic, retain) UIViewController  *interstialViewController;
@property (nonatomic, retain) UIViewController  *floatingViewController;
@property (nonatomic, assign) BOOL isManual;
@property (nonatomic, assign) BOOL stopBeingDelegate;
-(void) floatingShowAd:(CGPoint)point;
-(void) floatingMoveAd:(CGPoint) point;
- (UIView *) getMediationView;
- (UIViewController *) getInterstialMediationViewController;
@end


/* 프로토콜 선언 */

@protocol TadDelegate <NSObject>

@optional

- (void)tadOnAdWillLoad:(TadCore *)tadCore;                // 광고를 요청하기 직전에 호출 됩니다.
- (void)tadOnAdLoaded:(TadCore *)tadCore;                  // 광고 전문을 받은 경우 호출 됩니다.

- (void)tadOnAdClicked:(TadCore *)tadCore;                 // 사용자가 광고를 클릭한 경우 호출 됩니다.
- (void)tadOnAdTouchDown:(TadCore *)tadCore;               // 사용자에 의해 광고 영역에서 Touch Down이벤트가 발생한 경우
// 전면형 추가 프로토콜
- (void)tadOnAdClosed:(TadCore *)tadCore;                  // 전면형 광고가 사라질 때 호출 됩니다.

// Mraid 추가 프로토콜
- (void)tadOnAdExpanded:(TadCore *)tadCore;                // 사용자에 의해 전체 확장이 일어날 때 호출이 됩니다.
- (void)tadOnAdExpandClose:(TadCore *)tadCore;             // 사용자에 의해 전체 화면이 닫힐 때 호출이 됩니다.
- (void)tadOnAdResized:(TadCore *)tadCore;                 // 사용자에 의해 일부 확장이 일어날 때 호출이 됩니다.
- (void)tadOnAdResizeClosed:(TadCore *)tadCore;            // 사용자에 의해 전체 확장 화면이 닫힐 때 호출이 됩니다.

// 에러 처리
- (void)tadCore:(TadCore *)tadCore tadOnAdFailed:(TadErrorCode)errorCode;  // 에러 메세지를 전달 한다.

/* For Admob Mediation Delegate */
//===>
- (void)tadOnAdWillPresentModal:(TadCore *)tadCore;
- (void)tadOnAdDidPresentModal:(TadCore *)tadCore;
- (void)tadOnAdWillDismissModal:(TadCore *)tadCore;
- (void)tadOnAdDidDismissModal:(TadCore *)tadCore;
- (void)tadOnAdWillLeaveApplication:(TadCore *)tadCore;

//<===

@end
