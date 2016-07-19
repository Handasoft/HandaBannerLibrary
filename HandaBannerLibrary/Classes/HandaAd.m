//
//  HandaAd.m
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaAd.h"
#import "HandaAdController.h"
#import "HandaAdEnvironment.h"
#import "HandaAppRecommendViewController.h"
#import "UserDefaults.h"
#import "IMSdk.h"
#import "Global.h"
#import "IMCommonConstants.h"

@implementation HandaAd
@synthesize allowMultipleShow,isAlreadyShowInterstitial,isCalledInternal,isShowingInterstitial, isAutoLayout;
//@synthesize tadController;
@synthesize tadInterstitial, tadBanner;
@synthesize mezzoBanner;

- (id)init{
    self = [super init];
    if(self) {
        CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
        [CaulyAdSetting setLogLevel:CaulyLogLevelRelease];              //  Cauly Log 레벨
        adSetting.appCode               = [HandaAdEnvironment AD_ID_CAULY];                 //  Cauly AppCode
        adSetting.useGPSInfo            = NO;                       //  GPS 수집 허용여부
        adSetting.adSize                = CaulyAdSize_IPhone;       //  광고 크기
        adSetting.reloadTime            = CaulyReloadTime_30;       //  광고 갱신 시간
        adSetting.useDynamicReloadTime  = YES;                      //  동적 광고 갱신 허용 여부
        adSetting.animType = CaulyAnimNone;
        
        handaInterstitial = [[HandaInterstitialController alloc] init];
        handaInterstitial.delegate = self;
        handaInterstitial.vcParent = vcParent;
        
        houseInterstitial = [[HouseInterstitialController alloc] init];
        houseInterstitial.delegate = self;
        houseInterstitial.vcParent = vcParent;
        
        [IMSdk initWithAccountID:[HandaAdEnvironment ACCOUNT_ID_INMOBI]];
    }
    return self;
}

- (void)sendStatisticDisplay:(int)nAdType platform:(int)nPlatformNo banner:(int)nBannerNo advertiser:(NSString*)strAdvertiserNo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *stringParam = [NSString stringWithFormat:@"method=set.ad.display&partner_code=mobile_ios&app_no=%d&ad_type=%d&platform_no=%d&banner_no=%d&advertiser_no=%@", [HandaAdController Access].nAppNo, nAdType, nPlatformNo, nBannerNo, strAdvertiserNo];
        NSLog(@"%@?%@", [NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]], stringParam);
        [[Global Access] SendPost:[NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]] withParam:stringParam];
    });
}

- (void)sendStatisticClick:(int)nAdType platform:(int)nPlatformNo banner:(int)nBannerNo advertiser:(NSString*)strAdvertiserNo{
    NSString *stringParam = [NSString stringWithFormat:@"method=set.ad.click&partner_code=mobile_ios&app_no=%d&ad_type=%d&platform_no=%d&banner_no=%d&advertiser_no=%@", [HandaAdController Access].nAppNo, nAdType, nPlatformNo, nBannerNo, strAdvertiserNo];
    NSLog(@"%@?%@", [NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]], stringParam);
    [[Global Access] SendPost:[NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]] withParam:stringParam];
}

- (void)attachBannerAD:(UIViewController*)vc parentView:(UIView*)view calledClass:(NSString*)strName{
    vcParent = vc;
    viewForAD = view;
    strClassName = strName;
    
    for(id view in viewForAD.subviews){
        if([view isKindOfClass:[UIView class]]){
            if(((UIView*)view).tag == 345){//이미 배너가 있으면
                return;
            }
        }
    }
    
    if([[HandaAdController Access] checkValidClass:strClassName]){
        [[HandaAdController Access] resetADOrder:[HandaAdEnvironment ADTYPE_BANNER]];
        [self showAdBanner];
    }
}
#pragma mark - 배너 생성

//카울리 autolayout 적용된 배너가 출력됨
- (void) CreateCaulyView{
    NSLog(@"CreateCaulyView");
    if(caulyBanner == nil){
        NSLog(@"CreateCaulyView1");
        caulyBanner = [[CaulyAdView alloc] init];
        [caulyBanner setParentController:vcParent];
//        [caulyBanner setFrame:CGRectMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 50, 320, 50)];
        
        [caulyBanner setFrame:CGRectMake(0, viewForAD.frame.size.height - 50, viewForAD.frame.size.width, 50)];
        [viewForAD addSubview:caulyBanner];
        caulyBanner.showPreExpandableAd = NO;
        caulyBanner.delegate = self;
        caulyBanner.tag = 345;
        
        NSLog(@"viewForAD = %@", NSStringFromCGRect(viewForAD.frame));
        NSLog(@"caulyBanner = %@", NSStringFromCGRect(caulyBanner.frame));
    }else{
        [caulyBanner setHidden:NO];
    }
    [caulyBanner startBannerAdRequest];
}
- (void) CreateTadView{
    NSLog(@"CreateTadView");
    if(tadBanner) {
        [tadBanner destroyAd];
        tadBanner = nil;
    }
    
    tadBanner = [[TadCore alloc] initWithSeedView:viewForAD delegate:self];
    // 공통적용
    [tadBanner setClientID:[HandaAdEnvironment AD_ID_SYRUP_BANNER]];       // 클라이언트 아이디
    NSLog(@"티애드ID : %@", [HandaAdEnvironment AD_ID_SYRUP_BANNER]);
    [tadBanner setSlotNo:TadSlotInline];  // 슬롯 설정
    [tadBanner setOffset:CGPointMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 48)]; // 광고의 오프셋을 결정한다. (Default 0.0)
    //[tadController setOffset:CGPointMake(0, viewForAD.frame.size.height - 50)]; // 광고의 오프셋을 결정한다. (Default 0.0)
    [tadBanner setUseBackFillColor:YES];
    //릴리즈
    [tadBanner setIsTest:NO];
    [tadBanner setLogMode:NO];
    [tadBanner setSeedViewController:vcParent];
    [tadBanner getAdvertisement];
    tadBanner.getMediationView.tag = 345;
}
- (void) CreateMezzoMediaView{
    NSLog(@"CreateMezzoMediaView");
    if(mezzoBanner == nil){
        mezzoBanner = [[ADBanner alloc] initWithFrame:CGRectMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 50, 320, 50)];
        [mezzoBanner applicationID:[HandaAdEnvironment AD_ID_MEZZO] adWindowID:@"banner"];
        NSLog(@"메조ID : %@", [HandaAdEnvironment AD_ID_MEZZO]);
        mezzoBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        mezzoBanner.delegate = self;
        mezzoBanner.tag = 345;
        [viewForAD addSubview:mezzoBanner];
    }else{
        [mezzoBanner setHidden:NO];
    }
    [mezzoBanner startBannerAd];
}
- (void) CreateAdamView{
    
}

//인모비 배너 320*50 고정사이즈
- (void) CreateInmobiView{
    if(inmobiBanner == nil){
        inmobiBanner = [[IMBanner alloc] initWithFrame:CGRectMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 50, 320, 50) placementId:[HandaAdEnvironment AD_ID_INMOBI_BANNER] delegate:self];
        inmobiBanner.tag = 345;
        [inmobiBanner load];
        [viewForAD addSubview:inmobiBanner];
    }
}
//한다 배너 320*50 고정사이즈
- (void) CreateHandasoftView{
    NSLog(@"CreateHandasoftView");
    if(handaBanner){
        handaBanner = nil;
    }
    handaBanner = [[HandaBannerView alloc] init];
    handaBanner.delegate = self;
    handaBanner.tag = 345;
    [handaBanner setFrame:CGRectMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 50, 320, 50)];
    [handaBanner start];
    [viewForAD addSubview:handaBanner];
}

//하우스 배너 320*50 고정사이즈
- (void) CreateHouseView{
    NSLog(@"CreateHandasoftView");
    if(houseBanner){
        houseBanner = nil;
    }
    houseBanner = [[HouseBannerView alloc] init];
    houseBanner.delegate = self;
    houseBanner.tag = 345;
    [houseBanner setFrame:CGRectMake(isAutoLayout == YES ? (viewForAD.frame.size.width - 320) / 2 : 0, isAutoLayout == YES ? 0 : viewForAD.frame.size.height - 50, 320, 50)];
    [houseBanner start];
    [viewForAD addSubview:houseBanner];
}

#pragma mark - 배너 컨트롤
- (void) showAdBanner{
    if(![[HandaAdController Access] checkHouseAd:[HandaAdEnvironment ADTYPE_BANNER]] &&//보여줄 매체들 중 한다배너가 없고
       [HandaAdController Access].nFailCountBanner >= [[HandaAdController Access] getBannerCount]){//배너호출 실패 횟수가 총 매체수보다 많거나 같을 때
        return;//보여주지 않음
    }
    NSLog(@"showAdBanner = %d", [HandaAdController Access].nWillShowAdBanner);
    switch ([HandaAdController Access].nWillShowAdBanner) {
        case CAULY:
            [self CreateCaulyView];
            break;
        case SYRUP:
            [self CreateTadView];
            break;
        case MEZZO:
            [self CreateMezzoMediaView];
            break;
        case ADAM:
            [self CreateAdamView];
            break;
        case INMOBI:
            [self CreateInmobiView];
            break;
        case HANDASOFT:
            [self CreateHandasoftView];
            break;
        case HOUSE:
            [self CreateHouseView];
            break;
        default:
            break;
    }
}

- (void) removeAdBanner{
    NSLog(@"removeAdBanner %d", [HandaAdController Access].nWillShowAdBanner);
    switch ([HandaAdController Access].nWillShowAdBanner) {
        case CAULY:
            if(caulyBanner){
                NSLog(@"remove banner CAULY");
                [caulyBanner stopAdRequest];
                [caulyBanner setHidden:YES];
            }
            break;
        case SYRUP:
            if(tadBanner) {
                NSLog(@"remove banner SYRUP");
                if(tadBanner.slotNo == TadSlotInline){
                    [tadBanner destroyAd];
                    tadBanner = nil;
                }
            }
            break;
        case MEZZO:
            if(mezzoBanner){
                NSLog(@"remove banner MEZZO");
                [mezzoBanner stopBannerAd];
                [mezzoBanner setHidden:YES];
            }
            break;
        case ADAM:
            break;
        case INMOBI:
            if(inmobiBanner){
                NSLog(@"remove banner INMOBI");
                [inmobiBanner removeFromSuperview];
                inmobiBanner = nil;
            }
            break;
        case HANDASOFT:
            if(handaBanner){
                NSLog(@"remove banner HANDA");
                [handaBanner stop];
                [handaBanner removeFromSuperview];
                handaBanner = nil;
            }
            break;
        case HOUSE:
            if(houseBanner){
                NSLog(@"remove banner HOUSE");
                [houseBanner stop];
                [houseBanner removeFromSuperview];
                houseBanner = nil;
            }
            break;
        default:
            break;
    }
}
#pragma mark - 전면 컨트롤
- (void) showInterstitial:(UIViewController*)vc calledClass:(NSString*)strName{
    NSLog(@"showInterstitial %@", strName);
    vcParent = vc;
    strClassName = strName;
    if(isCalledInternal){
        isCalledInternal = NO;
        NSLog(@"showInterstitial1");
        if(![[HandaAdController Access] checkHouseAd:[HandaAdEnvironment ADTYPE_INTERSTITIAL]] &&//보여줄 매체들 중 한다 전면이 없고
           [HandaAdController Access].nFailCountInterstitial >= [[HandaAdController Access] getInterstitialCount]
           ){//광고호출 실패 횟수가 총 매체수보다 많거나 같을 때
            return;//보여주지 않음
        }
    }else{
        [[HandaAdController Access] resetADOrder:[HandaAdEnvironment ADTYPE_INTERSTITIAL]];
    }
    NSString * str = [UserDefaults loadUserDefaults:[NSString stringWithFormat:@"%@_installed_time", [[NSBundle mainBundle] bundleIdentifier]]];
    if(str != nil){
        int lValidTime = [str intValue];
        if(lValidTime > 0){//설치 후 광고동작시간 체크
            int nCurrent = (int)[NSDate timeIntervalSinceReferenceDate];
            lValidTime += [HandaAdController Access].nFirstActionTime * 60;
            if(lValidTime > nCurrent)
                return;//인스톨 한 시점으로 부터 서버에서 받은시간이 지나지 않았으면 보여주지 않음
        }
    }
   
    if([HandaAdController Access].isAbleToShowInterstitial){
        if(![HandaAdController Access].bShowAtFirstRun){//광고바로실행이 체크해제면
            [HandaAdController Access].bShowAtFirstRun = YES;
            return;
        }
        //if(([HandaAdController Access].nMyMemGrade & [HandaAdController Access].nTargetMemGrade) > 0){//서버에서 설정한 등급중 해당사항이 있으면
            //이미 한번 보여줬는지
            if(!isAlreadyShowInterstitial || allowMultipleShow){
                NSLog(@"showInterstitial3");
                //현재 클래스 유효한(관리자에서 승인한)클래스인지
                if([[HandaAdController Access] checkValidClass:strClassName]){
                    switch ([HandaAdController Access].nWillShowAdInterstitial) {
                        case CAULY:
                            NSLog(@"showInterstitial CAULY");
                            if(caulyInterstitial)
                                caulyInterstitial = nil;
                            NSLog(@"%@", vcParent);
                            caulyInterstitial = [[CaulyInterstitialAd alloc] initWithParentViewController:vcParent];    //  전면광고 객체 생성
                            caulyInterstitial.delegate = self;                                                          //  전면 delegate 설정
                            isAlreadyShowInterstitial = YES;
                            isShowingInterstitial = YES;
                            [caulyInterstitial startInterstitialAdRequest];                                             //  전면광고 요청
                            break;
                        case SYRUP:
                            NSLog(@"showInterstitial SYRUP");
                            if(tadInterstitial) {
                                [tadInterstitial destroyAd];
                                tadInterstitial = nil;
                            }
                            
                            tadInterstitial = [[TadCore alloc] initWithSeedView:viewForAD delegate:self];
                            // 공통적용
                            [tadInterstitial setClientID:[HandaAdEnvironment AD_ID_SYRUP_INTERSTITIAL]];       // 클라이언트 아이디
                            [tadInterstitial setSlotNo:TadSlotInterstitial];  // 슬롯 설정
                            [tadInterstitial setIsTest:NO];
                            [tadInterstitial setLogMode:NO];
                            [tadInterstitial setSeedViewController:vcParent];
                            // 전면광고 5초후 자동 닫힘
                            [tadInterstitial setAutoCloseWhenNoInteraction:NO];
                            // 전면광고 랜딩 후 광고 닫힘.
                            [tadInterstitial setAutoCloseAfterLeaveApplication:NO];
                            isAlreadyShowInterstitial = YES;
                            isShowingInterstitial = YES;
                            [tadInterstitial getAdvertisement];
                            break;
                        case MEZZO:{
                            NSLog(@"showInterstitial MEZZO");
                            ManInterstitial *manInterstitial = [ManInterstitial shareInstance];
                            if (manInterstitial) {
                                manInterstitial.delegate = self;
                                [manInterstitial applicationID:[HandaAdEnvironment AD_ID_MEZZO] adWindowID:@"interstitial"];
                                isAlreadyShowInterstitial = YES;
                                isShowingInterstitial = YES;
                                [manInterstitial startInterstitial];
                            }
                            break;
                        }
                        case INMOBI:{
                            NSLog(@"showInterstitial INMOBI");
                            if(inmobiInterstitial == nil){
                                inmobiInterstitial = [[IMInterstitial alloc] initWithPlacementId:[HandaAdEnvironment AD_ID_INMOBI_INTERSTITIAL] delegate:self];
                            }
                            isAlreadyShowInterstitial = YES;
                            isShowingInterstitial = YES;
                            [inmobiInterstitial load];
                            break;
                        }
                        case HANDASOFT:
                            NSLog(@"showInterstitial HANDA");
                            isAlreadyShowInterstitial = YES;
                            isShowingInterstitial = YES;
                            handaInterstitial.vcParent = vcParent;
                            [handaInterstitial requestAD];
                            break;
                        case HOUSE:
                            NSLog(@"showInterstitial HOUSE");
                            isAlreadyShowInterstitial = YES;
                            isShowingInterstitial = YES;
                            houseInterstitial.vcParent = vcParent;
                            [houseInterstitial requestAD];
                            break;
                        default:
                            break;
                    }	
                }
            }	
        //}
    }
}

#pragma mark - 추천앱

- (void)showRecommendApp:(UIViewController *)vc{
    HandaAppRecommendViewController* v = [[HandaAppRecommendViewController alloc] init];
    v.arrData = [HandaAdController Access].arrRecommendAppList;
    [vc presentViewController:v animated:YES completion:nil];
    
}

#pragma mark - 배너 리스너
#pragma mark 카울리
// 광고 정보 수신 성공
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"카울리 배너 didReceiveAd");
    if(!isChargeableAd){//무료광고
        if([[HandaAdController Access] getBannerCount] >= 1){
            [HandaAdController Access].nFailCountBanner++;
            [self removeAdBanner];
            [[HandaAdController Access] nextAdBanner];
            [self showAdBanner];
        }
    }else{
        [self sendStatisticDisplay:1 platform:CAULY banner:-1 advertiser:@"0"];
        [HandaAdController Access].nFailCountBanner = 0;
    }
}
// 광고 정보 수신 실패
- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"카울리 배너 didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    if([[HandaAdController Access] getBannerCount] >= 1){
        [HandaAdController Access].nFailCountBanner++;
        [self removeAdBanner];
        [[HandaAdController Access] nextAdBanner];
        [self showAdBanner];
    }
}
// 랜딩 화면 표시
- (void)willShowLandingView:(CaulyAdView *)adView {
    [self sendStatisticClick:1 platform:CAULY banner:-1 advertiser:@"0"];
}
// 랜딩 화면이 닫혔을 때
- (void)didCloseLandingView:(CaulyAdView *)adView {
}
#pragma mark 티애드 배너 + 전면
- (void)tadOnAdLoaded:(TadCore *)tadCore{
    NSLog(@"티애드 광고로딩 성공");
    if(tadCore.slotNo == TadSlotInterstitial){
        [self sendStatisticDisplay:2 platform:SYRUP banner:-1 advertiser:@"0"];
        [HandaAdController Access].nFailCountInterstitial = 0;
        [tadCore showAd];
    }else if(tadCore.slotNo == TadSlotInline){
        [self sendStatisticDisplay:1 platform:SYRUP banner:-1 advertiser:@"0"];
        [HandaAdController Access].nFailCountBanner = 0;
        if(isAutoLayout){
            tadCore.getMediationView.frame = CGRectMake((viewForAD.frame.size.width - tadCore.getMediationView.frame.size.width) / 2, 0, tadCore.getMediationView.frame.size.width, tadCore.getMediationView.frame.size.height);
        }
    }
}
- (void)tadOnAdClicked:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdClosed:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdExpanded:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdExpandClose:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdResized:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdResizeClosed:(TadCore *)tadCore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdWillPresentModal:(TadCore *)tadCore
{
    if(tadCore.slotNo == TadSlotInterstitial){//뜨는 페이지가 전면 광고이면
        isShowingInterstitial = NO;
        [[HandaAdController Access] checkTime];
        [[HandaAdController Access] nextInterstitial];
    }
}
- (void)tadOnAdDidPresentModal:(TadCore *)tadCore
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdWillDismissModal:(TadCore *)tadCore
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdDidDismissModal:(TadCore *)tadCore
{
    isShowingInterstitial = NO;
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadOnAdWillLeaveApplication:(TadCore *)tadCore
{
    if(tadCore.slotNo == TadSlotInterstitial){
        [self sendStatisticClick:2 platform:SYRUP banner:-1 advertiser:@"0"];
    }else if(tadCore.slotNo == TadSlotInline){
        [self sendStatisticClick:1 platform:SYRUP banner:-1 advertiser:@"0"];
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)tadCore:(TadCore *)tadCore tadOnAdFailed:(TadErrorCode)errorCode {
    NSString *string = nil;
    if (errorCode == NO_AD) //NSLog(@"<Tad Error> 광고 서버에서 송출 가능한 광고가 없는 경우 바형태 배너 일 경우 자동으로 재호출 됩니다. (전면 형태의 배너일 경우 자동 으로 호출 되지 않습니다.)");
        string = @"<Tad Error> 광고 서버에서 송출 가능한 광고가 없는 경우 바형태 배너 일 경우 자동으로 재호출 됩니다. (전면 형태의 배너일 경우 자동 으로 호출 되지 않습니다.)";
    else if (errorCode == MISSING_REQUIRED_PARAMETER_ERROR) string = @"<Tad Error> 필수 파라메터 누락된 경우";
    else if (errorCode == INVAILD_PARAMETER_ERROR) string = @"<Tad Error> 잘못된 파라메터인 경우";
    else if (errorCode == UNSUPPORTED_DEVICE_ERROR) string = @"<Tad Error> 미지원 단말인 경우";
    else if (errorCode == CLIENTID_DENIED_ERROR) string = @"<Tad Error> 지정한 Client ID가 유효하지 않은 경우";
    else if (errorCode == INVAILD_SLOT_NUMBER) string = @"<Tad Error> 지정한 슬롯 번호가 유효하지 않은 경우";
    else if (errorCode == CONNECTION_ERROR) string = @"<Tad Error> 네트워크 연결이 가능하지 않은 경우";
    else if (errorCode == NETWORK_ERROR) string = @"<Tad Error> 광고의 수신 및 로딩 과정에서 네트워크 오류가 발생한 경우";
    else if (errorCode == RECEIVE_AD_ERROR) string = @"Tad Error 광고를 수신하는 과정에서 에러가 발생한 경우";
    else if (errorCode == LOAD_ERROR) string = @"<Tad Error> SDK에서 허용하는 시간 내에 광고를 재요청한 경우";
    else if (errorCode == SHOW_ERROR) string = @"<Tad Error> 노출할 광고가 없는 경우";
    else if (errorCode == INTERNAL_ERROR) string = @"<Tad Error> 광고의 수신 및 로딩 과정에서 내부적으로 오류가 발생한 경우";
    else if (errorCode == ALREADY_SHOWN) string = @"<ALREADY_SHOWN> 이미 광고가 표시되어있음.";
    else if (errorCode == NOT_INLINE_SHOW) string = @"<NOT_INLINE_SHOW> Inline 광고 show 실행 불가.";
    else if (errorCode == UNKNOWN_SEEDVIEWCONTROLLER) string = @"<NOT_SEEDVIEWCONTROLLER> 광고가 표시될 부모 뷰 컨트롤러 없음.";
  
    NSString *totalString = [NSString stringWithFormat:@"%@\n%@", string,@"다시 요청 하시려면 getAdvertisement 를 호출 하세요"];
    NSLog(@"%@", totalString);
    if(tadCore.slotNo == TadSlotInline){
        NSLog(@"시럽 띠 실패");
        if([[HandaAdController Access] getBannerCount] >= 1){
            [HandaAdController Access].nFailCountBanner++;
            [self removeAdBanner];
            [[HandaAdController Access] nextAdBanner];
            [self showAdBanner];
        }
    }else if(tadCore.slotNo == TadSlotInterstitial){
        NSLog(@"시럽 전면 실패");
        isShowingInterstitial = NO;
        if([[HandaAdController Access] getInterstitialCount] >= 1){
            isAlreadyShowInterstitial = NO;
            [HandaAdController Access].nFailCountInterstitial++;
            [[HandaAdController Access] nextInterstitial];
            isCalledInternal = YES;
            [self showInterstitial:vcParent calledClass:strClassName];
        }
    }
}
#pragma mark 메조
- (void)adBannerClick:(ADBanner*)adBanner {// 배너 광고 클릭
    //안드로이드도 메조 클릭은 없고 ios에 전면도 클릭이 없어서 일관성을 위해 메조 배너 클릭 통계 넣지않음
    NSLog(@"메조 배너 클릭");
}
- (void)didCloseRandingPage:(ADBanner*)adBanner {// 배너 광고 클릭시 나타났던 랜딩 페이지가 닫힐 경우
    NSLog(@"메조 배너 랜딩페이지 닫힘");
}

- (void)adBannerParsingEnd:(ADBanner*)adBanner {// 배너광고 파싱 완료
}
- (void)didReceiveAd:(ADBanner*)adBanner chargedAdType:(BOOL)bChargedAdType {
    NSLog(@"메조 배너 didReceiveAd");
    if(!bChargedAdType){//무료광고
        if([[HandaAdController Access] getBannerCount] >= 1){
            [HandaAdController Access].nFailCountBanner++;
            [self removeAdBanner];
            [[HandaAdController Access] nextAdBanner];
            [self showAdBanner];
        }
    }else{
        [self sendStatisticDisplay:1 platform:MEZZO banner:-1 advertiser:@"0"];
        [HandaAdController Access].nFailCountBanner = 0;
    }
}
- (void)didFailReceiveAd:(ADBanner*)adBanner errorType:(NSInteger)errorType {
    //NSLog(@"메조 배너 에러 %d", (int)errorType);
    if(errorType != 0 && [[HandaAdController Access] getBannerCount] >= 1){
        [HandaAdController Access].nFailCountBanner++;
        [self removeAdBanner];
        [[HandaAdController Access] nextAdBanner];
        [self showAdBanner];
    }
    /*
    ManAdSuccess            = 0,           // 성공
    ManAdNetworkError       = -100,        // 네트워크 에러
    ManAdServerError        = -200,        // 광고 서버 에러
    ManAdApiTypeError       = -300,        // API Type 에러
    ManAdAppIDError         = -400,        // App ID값 에러
    ManAdWindowIDError      = -500,        // Window ID값 에러
    ManAdNotNormalIDError   = -600,        // 해당 ID값이 정상적이지 않음
    ManAdNotExistAd         = -700         // 해당 ID의 광고가 존재하지 않음
    */
}
#pragma mark 인모비
/**
 * The banner has finished loading
 */
-(void)bannerDidFinishLoading:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self sendStatisticDisplay:1 platform:INMOBI banner:-1 advertiser:@"0"];
    [HandaAdController Access].nFailCountBanner = 0;
}
/**
 * The banner has failed to load with some error.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", [NSString stringWithFormat:@"Inmobi Banner loading Error code: %ld, message: %@", (long)[error code], [error localizedDescription]]);
    
    if([[HandaAdController Access] getBannerCount] >= 1){
        [HandaAdController Access].nFailCountBanner++;
        [self removeAdBanner];
        [[HandaAdController Access] nextAdBanner];
        [self showAdBanner];
    }
}
/**
 * The banner was interacted with.
 */
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"params : %@", params);
    [self sendStatisticClick:1 platform:INMOBI banner:-1 advertiser:@"0"];
}
/**
 * The user would be taken out of the application context.
 */
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The banner would be presenting a full screen content.
 */
-(void)bannerWillPresentScreen:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The banner has finished presenting screen.
 */
-(void)bannerDidPresentScreen:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The banner will start dismissing the presented screen.
 */
-(void)bannerWillDismissScreen:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The banner has dismissed the presented screen.
 */
-(void)bannerDidDismissScreen:(IMBanner*)banner {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The user has completed the action to be incentivised with.
 */
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"rewards : %@", rewards);
}
#pragma mark 한다

- (void)onLoadSuccess:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo{
    [self sendStatisticDisplay:1 platform:HANDASOFT banner:strBannerNo.intValue  advertiser:strAdvertiserNo];
    NSLog(@"한다 배너 onLoadSuccess");
    [HandaAdController Access].nFailCountBanner = 0;
}
- (void)onLoadFail{
    NSLog(@"한다 배너 onLoadFail");
    if([[HandaAdController Access] getBannerCount] >= 1){
        [HandaAdController Access].nFailCountBanner++;
        [self removeAdBanner];
        [[HandaAdController Access] nextAdBanner];
        [self showAdBanner];
    }
}
- (void)onClickAD:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo{
    [self sendStatisticClick:1 platform:HANDASOFT banner:strBannerNo.intValue  advertiser:strAdvertiserNo];
}
#pragma mark - 하우스

- (void)onLoadSuccess_House:(NSString *)strBannerNo{
    [self sendStatisticDisplay:1 platform:HOUSE banner:strBannerNo.intValue  advertiser:@"0"];
    NSLog(@"하우스 배너 onLoadSuccess");
    [HandaAdController Access].nFailCountBanner = 0;
}
- (void)onLoadFail_House{
    NSLog(@"하우스 배너 onLoadFail");
    if([[HandaAdController Access] getBannerCount] >= 1){
        [HandaAdController Access].nFailCountBanner++;
        [self removeAdBanner];
        [[HandaAdController Access] nextAdBanner];
        [self showAdBanner];
    }
}
- (void)onClickAD_House:(NSString *)strBannerNo{
    [self sendStatisticClick:1 platform:HOUSE banner:strBannerNo.intValue  advertiser:@"0"];
}
#pragma mark 아담

#pragma mark - 전면 리스너
#pragma mark 카울리
// 광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd {
    NSLog(@"카울리 전면 didReceiveInterstitialAd");
    if (!isChargeableAd){
        if([[HandaAdController Access] getInterstitialCount] >= 1){
            isAlreadyShowInterstitial = NO;
            [HandaAdController Access].nFailCountInterstitial++;
            [[HandaAdController Access] nextInterstitial];
            isCalledInternal = YES;
            [self showInterstitial:vcParent calledClass:strClassName];
        }
    }else{
        [self sendStatisticDisplay:2 platform:CAULY banner:-1  advertiser:@"0"];
        [HandaAdController Access].nFailCountInterstitial = 0;
        [caulyInterstitial show];
        caulyInterstitial = nil;
    }
}

// Interstitial 형태의 광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    isShowingInterstitial = NO;
    [[HandaAdController Access] checkTime];
    [[HandaAdController Access] nextInterstitial];

    caulyInterstitial = nil;
}

// Interstitial 형태의 광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd {
    [self sendStatisticClick:2 platform:CAULY banner:-1  advertiser:@"0"];
}

// 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {
    NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
    isShowingInterstitial = NO;
    if([[HandaAdController Access] getInterstitialCount] >= 1){
        isAlreadyShowInterstitial = NO;
        [HandaAdController Access].nFailCountInterstitial++;
        [[HandaAdController Access] nextInterstitial];
        isCalledInternal = YES;
        [self showInterstitial:vcParent calledClass:strClassName];
    }
    caulyInterstitial = nil;
}
#pragma mark 메조
- (void)didReceiveInterstitial {
    NSLog(@"메조 전면 수신 성공");
    // 전면 광고 수신 성공
    [self sendStatisticDisplay:2 platform:MEZZO banner:-1 advertiser:@"0"];
    [HandaAdController Access].nFailCountInterstitial = 0;
    
    isShowingInterstitial = NO;
    [[HandaAdController Access] checkTime];
    [[HandaAdController Access] nextInterstitial];
}

- (void)didFailReceiveInterstitial:(NSInteger)errorType {
    //NSLog(@"메조 전면 에러 %ld", errorType);
    // 전면 광고 수신 실패
    isShowingInterstitial = NO;
    if(errorType != 0){
        if([[HandaAdController Access] getInterstitialCount] >= 1){
            isAlreadyShowInterstitial = NO;
            [HandaAdController Access].nFailCountInterstitial++;
            [[HandaAdController Access] nextInterstitial];
            isCalledInternal = YES;
            [self showInterstitial:vcParent calledClass:strClassName];
        }
    }
}

- (void)didCloseInterstitial {
    NSLog(@"메조 전면 닫힘");
    isShowingInterstitial = NO;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *stringParam = @"method=set.stats.banner&type=close";
//        [[Global Access] SendPostReceiveJson:@"http://www-jumsin.handaunse.co.kr/office/api.free.php" withParam:stringParam];
//    });
}

#pragma mark 인모비

/**
 * The interstitial has finished loading
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [HandaAdController Access].nFailCountInterstitial = 0;
    if([interstitial isReady])
        [interstitial showFromViewController:vcParent withAnimation:kIMInterstitialAnimationTypeCoverVertical];
}
/**
 * The interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error {
    NSLog(@"%@", [NSString stringWithFormat:@"Inmobi Interstitial Error code: %ld, message: %@", (long)[error code], [error localizedDescription]]);
    if([[HandaAdController Access] getInterstitialCount] >= 1){
        isAlreadyShowInterstitial = NO;
        [HandaAdController Access].nFailCountInterstitial++;
        [[HandaAdController Access] nextInterstitial];
        isCalledInternal = YES;
        [self showInterstitial:vcParent calledClass:strClassName];
    }
}
/**
 * The interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has been presented.
 */
-(void)interstitialDidPresent:(IMInterstitial *)interstitial {
    [self sendStatisticDisplay:2 platform:INMOBI banner:-1 advertiser:@"0"];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has failed to present with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 * The interstitial has been interacted with.
 */
-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params {
    [self sendStatisticClick:2 platform:INMOBI banner:-1 advertiser:@"0"];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"params : %@", params);
}
/**
 * The user has performed the action to be incentivised with.
 */
-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"rewards : %@", rewards);
}
/**
 * The user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark 한다
- (void)onLoadSuccessInterstitial:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo{
    [self sendStatisticDisplay:2 platform:HANDASOFT banner:strBannerNo.intValue advertiser:strAdvertiserNo];
    [HandaAdController Access].nFailCountInterstitial = 0;
    [handaInterstitial showAD];
}
- (void)onLoadFailInterstitial{
    isShowingInterstitial = NO;
    if([[HandaAdController Access] getInterstitialCount] >= 1){
        isAlreadyShowInterstitial = NO;
        [HandaAdController Access].nFailCountInterstitial++;
        [[HandaAdController Access] nextInterstitial];
        isCalledInternal = YES;
        [self showInterstitial:vcParent calledClass:strClassName];
    }
}
- (void)onClosedInterstitial{
    isShowingInterstitial = NO;
    [[HandaAdController Access] checkTime];
    [[HandaAdController Access] nextInterstitial];
}
- (void)onClickADInterstitial:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo{
    NSLog(@"onClickADInterstitial strBannerNo %@ strAdvertiserNo %@", strBannerNo, strAdvertiserNo);
    [self sendStatisticClick:2 platform:HANDASOFT banner:strBannerNo.intValue advertiser:strAdvertiserNo];
}
#pragma mark 하우스
- (void)onLoadSuccessInterstitial_House:(NSString *)strBannerNo{
    NSLog(@"하우스 전면 onLoadSuccess");
    
    [self sendStatisticDisplay:2 platform:HOUSE banner:strBannerNo.intValue advertiser:@"0"];
    [HandaAdController Access].nFailCountInterstitial = 0;
    [houseInterstitial showAD];
}
- (void)onLoadFailInterstitial_House{
     NSLog(@"하우스 전면 onLoadFail");
    isShowingInterstitial = NO;
    if([[HandaAdController Access] getInterstitialCount] >= 1){
        isAlreadyShowInterstitial = NO;
        [HandaAdController Access].nFailCountInterstitial++;
        [[HandaAdController Access] nextInterstitial];
        isCalledInternal = YES;
        [self showInterstitial:vcParent calledClass:strClassName];
    }
}
- (void)onClosedInterstitial_House{
    isShowingInterstitial = NO;
    [[HandaAdController Access] checkTime];
    [[HandaAdController Access] nextInterstitial];
}
- (void)onClickADInterstitial_House:(NSString *)strBannerNo{
    [self sendStatisticClick:2 platform:HOUSE banner:strBannerNo.intValue advertiser:@"0"];
}
#pragma mark 아담
@end
