//
//  HandaAdController.h
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandaAdController : NSObject{
    NSMutableArray * arrADShowTypeInfo;
    NSMutableArray * arrClassName;
    NSMutableArray * arrBannerOrder;
    NSMutableArray * arrInterstitialOrder;
}

//광고 활성화 유무
@property (nonatomic, assign) BOOL isShowBanner;
@property (nonatomic, assign) BOOL isShowInterstitial;
@property (nonatomic, assign) BOOL isShowNative;
//한다를 제외한 나머지 매체 광고 실패 횟수
@property (nonatomic)int nFailCountBanner;
@property (nonatomic)int nFailCountInterstitial;
@property (nonatomic)int nShowInterval;//전면 노출 시간 컨트롤(초)
//@property (nonatomic)int nTargetGender;  //0=all, 1=male, 2=femal
@property (nonatomic)int nMyMemGrade;
@property (nonatomic)int nMyGender;
@property (nonatomic)int nMyAge;
@property (nonatomic)int nWillShowAdInterstitial;    //보여줘야 할 전면광고 번호
@property (nonatomic)int nWillShowAdBanner;          //보여줘야 할 배너광고 번호
@property (nonatomic)int nWillShowAdEnding;          //보여줘야 할 엔딩광고 번호
//@property (nonatomic)int nWillShowAdCount;           //로테이션 할 매체 갯수
@property (nonatomic)int nIndexOfBannerOrder;        //배너 순서의 인덱스
@property (nonatomic)int nIndexOfInterstitialOrder;  //전면 순서의 인덱스
@property (nonatomic)int nFirstActionTime;           //앱 설치 후 전면광고가 보여야 되는 시간(분)
@property (nonatomic)int nTargetMemGrade;            //광고 노출 대상 회원 등급&성별
@property (nonatomic)BOOL isAbleToShowInterstitial;  //타이머 체크로 전면 보여줄지 결정
@property (nonatomic)BOOL bShowAtFirstRun;           //광고 관리자에 앱 시작시 전면배너 실행 유무 YES:실행 NO:실행안함
@property (nonatomic)int nAppNo;                        //현재 앱 인덱스
@property (strong, nonatomic) NSString * strAppName;    //현재 앱 명
@property (strong, nonatomic)NSMutableArray * arrHandaAdList;
@property (strong, nonatomic)NSMutableArray * arrHouseAdList;
@property (strong, nonatomic)NSMutableArray * arrRecommendAppList;

+ (HandaAdController *)Access;
- (BOOL)isAbleToShowBanner;
- (void)setMyGender:(int)gen;
- (void)setMyAge:(int)age;
- (void)nextAdBanner;
- (void)nextInterstitial;
- (void)checkTime;
- (BOOL)checkValidClass:(NSString*)strName;
- (BOOL)setADInformation:(NSString*)strUrl;
- (void)resetADOrder:(int)type;
//- (int)getOrderLastIndex;
//- (int)getAdCount;
- (BOOL)checkHouseAd:(int)nType;//1=배너, 2=전면
- (int)getBannerCount;
- (int)getBannerLastIndex;
- (int)getInterstitialCount;
- (int)getInterstitialLastIndex;
@end
