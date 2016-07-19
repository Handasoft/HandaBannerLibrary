//
//  HandaAdController.m
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaAdController.h"
#import "HandaAdEnvironment.h"
#import "Global.h"
#import "UserDefaults.h"
#import "ADData.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation HandaAdController
@synthesize nFailCountBanner,nFailCountInterstitial,nShowInterval,nMyAge,nMyGender;
@synthesize nFirstActionTime,nWillShowAdInterstitial,nWillShowAdBanner,nIndexOfBannerOrder,nIndexOfInterstitialOrder,nWillShowAdEnding,nTargetMemGrade,nMyMemGrade,nAppNo;
@synthesize strAppName;
@synthesize isAbleToShowInterstitial, bShowAtFirstRun;
@synthesize arrHouseAdList,arrHandaAdList,arrRecommendAppList;
@synthesize isShowBanner, isShowInterstitial, isShowNative;

static HandaAdController * globalValue = nil;

+ (id)alloc{
    @synchronized([HandaAdController class])
    {
        globalValue = [super alloc];
        globalValue.isAbleToShowInterstitial = YES;
        globalValue.nMyAge = 100;
        globalValue.nMyGender = 0;
        globalValue.nMyMemGrade = [HandaAdEnvironment MEMTYPE_NONE];
        globalValue.nShowInterval = 20;
        globalValue.nTargetMemGrade = 0;
        return globalValue;
    }
    return nil;
}

+ (HandaAdController *)Access{
    @synchronized([HandaAdController class])
    {
        if(!globalValue)
            globalValue = [[self alloc] init];
        
        return globalValue;
    }
    return nil;
}

- (BOOL)isAbleToShowBanner{
    if ([self checkHouseAd:[HandaAdEnvironment ADTYPE_BANNER]] &&//보여줄 매체들 중 하우스배너가 없고
        nFailCountBanner >= [self getBannerCount]) {//배너호출 실패 횟수가 총 매체수보다 많거나 같을 때
        return NO;//보여주지 않음
    }
    return YES;
}
- (void)setMyGender:(int)gen{
    if(gen != 1 && gen != 2)
        gen = 0;
    
    nMyGender = gen;
}
- (void)setMyAge:(int)age{
    if(age > 100)
        age = 100;
    
    nMyAge = age;
}

- (int)getBannerCount{
    if(arrBannerOrder == nil)
        return 0;
    return (int)arrBannerOrder.count;
}
- (int)getBannerLastIndex{
    return [arrBannerOrder[arrBannerOrder.count - 1] intValue];
}
- (int)getInterstitialCount{
    if(arrInterstitialOrder == nil)
        return 0;
    return (int)arrInterstitialOrder.count;
}
- (int)getInterstitialLastIndex{
    return [arrInterstitialOrder[arrInterstitialOrder.count - 1] intValue];
}
- (void)nextAdBanner{
    if(arrBannerOrder == nil || arrBannerOrder.count == 0)
        return;
    int nTemp = -1;
    if([self checkHouseAd:[HandaAdEnvironment ADTYPE_BANNER]]){//하우스 광고가 있으면
        if(nFailCountBanner >= arrBannerOrder.count){//하우스배너도 실패했으면
            nTemp = -1;
        }else{
            if(nIndexOfBannerOrder >= arrBannerOrder.count - 1){
                nIndexOfBannerOrder = 0;
            }else{
                nIndexOfBannerOrder++;
            }
            nTemp = [arrBannerOrder[nIndexOfBannerOrder] intValue];
        }
    }else{
        if(nFailCountBanner >= arrBannerOrder.count - 1){//실패한 횟수가 총 보여줘야 할 갯수보다 많거나 같다면 동작안함
            nTemp = -1;
        }else{
            if(nIndexOfBannerOrder >= arrBannerOrder.count - 1){
                nIndexOfBannerOrder = 0;
            }else{
                nIndexOfBannerOrder++;
            }
            
            nTemp = [arrBannerOrder[nIndexOfBannerOrder] intValue];
        }
        
    }
    nWillShowAdBanner = nTemp;
    
}
- (void)nextInterstitial{
    if(arrInterstitialOrder == nil || arrInterstitialOrder.count == 0)
        return;
    int nTemp = 0;
    if([self checkHouseAd:[HandaAdEnvironment ADTYPE_INTERSTITIAL]]){//하우스 광고가 있으면
        if(nFailCountInterstitial >= arrInterstitialOrder.count){//하우스배너도 실패했으면
            nTemp = -1;
        }else{
            if(nIndexOfInterstitialOrder >= arrInterstitialOrder.count - 1){
                nIndexOfInterstitialOrder = 0;
            }else{
                nIndexOfInterstitialOrder++;
            }
            nTemp = [arrInterstitialOrder[nIndexOfInterstitialOrder] intValue];
        }
    }else{
        if(nIndexOfInterstitialOrder >= arrInterstitialOrder.count - 1){
            nIndexOfInterstitialOrder = 0;
        }else{
            nIndexOfInterstitialOrder++;
        }
        
        nTemp = [arrInterstitialOrder[nIndexOfInterstitialOrder] intValue];
    }
    nWillShowAdInterstitial = nTemp;
}
- (void)endTimer{
    NSLog(@"endTimer");
    isAbleToShowInterstitial = YES;
}
- (void)checkTime{
    isAbleToShowInterstitial = NO;
    if(nShowInterval == 0){
        isAbleToShowInterstitial = YES;
    }else{
        [NSTimer scheduledTimerWithTimeInterval:nShowInterval target:self selector:@selector(endTimer) userInfo:nil repeats:NO];
    }
}
- (BOOL)checkValidClass:(NSString*)strName{
    for(NSString * str in arrClassName){
        if(str != nil && [strName rangeOfString:str].length > 0)
            return YES;
    }
    return NO;
}
- (BOOL)checkHouseAd:(int)nType{
    BOOL bExist = NO;
    for(ADData * data in arrHouseAdList){
        if((data.nAdType & nType) == nType){
            bExist = YES;
            break;
        }
    }
    return bExist;
}

- (NSString *) platform
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return platform;
}

- (NSString*) getPlatform
{
    NSString *platform = [self platform];
    
    /* iPhone */
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,3"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 PLUS";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S PLUS";
    
    /* iPod Touch */
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 6G";
    /* iPad */
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad3,5"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad3,6"]) return @"New iPad";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad mini Retina";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini Retina";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air2";
    
    /* Simulator */
    if ([platform isEqualToString:@"i386"]) return @"Simulator";
    return @"iPhone OS";
}

- (BOOL)setADInformation:(NSString*)strUrl{
    if(arrBannerOrder != nil){
        [arrBannerOrder removeAllObjects];
        arrBannerOrder = nil;
    }
    if(arrInterstitialOrder != nil){
        [arrInterstitialOrder removeAllObjects];
        arrInterstitialOrder = nil;
    }
    
    //디바이스 정보 세팅
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *stringParam = [NSString stringWithFormat:@"method=set.stat.device&partner_code=mobile_ios&device_name=%@&device_os_ver=%@", [self getPlatform], [[UIDevice currentDevice] systemVersion]];
        [[Global Access] SendPostReceiveJson:[NSString stringWithFormat:@"http://%@/office/ㅁpi_v2.php", [HandaAdEnvironment AD_API_DOMAIN]] withParam:stringParam];
    });
    
    NSString *stringParam = [NSString stringWithFormat:@"method=get.ad.info&os=ios&store=apple&package_id=%@", [[NSBundle mainBundle] bundleIdentifier]];
    NSLog(@"%@?%@", [NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]],stringParam);
    NSDictionary * jsonData = [[Global Access] SendPostReceiveJson:[NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]] withParam:stringParam];
    NSLog(@"%@", jsonData);
    if([[jsonData objectForKey:@"result"] boolValue] == YES){
        NSDictionary * dicInfo = [jsonData objectForKey:@"app_ad_info"];
        NSDictionary * dicAppInfo = [jsonData objectForKey:@"app_info"];
        nAppNo = [[dicInfo objectForKey:@"app_no"] intValue];
        strAppName = [dicAppInfo objectForKey:@"name"];
        NSLog(@"line_ad_is_display %@", [dicInfo objectForKey:@"line_ad_is_display"]);
        isShowBanner = [[dicInfo objectForKey:@"line_ad_is_display"] isEqualToString:@"Y"];
        NSLog(@"full_ad_is_display %@", [dicInfo objectForKey:@"full_ad_is_display"]);
        isShowInterstitial = [[dicInfo objectForKey:@"full_ad_is_display"] isEqualToString:@"Y"];
        NSLog(@"native_ad_is_display %@", [dicInfo objectForKey:@"native_ad_is_display"]);
        isShowNative = [[dicInfo objectForKey:@"native_ad_is_display"] isEqualToString:@"Y"];

        //보여줘야 할 메뉴
        arrClassName = [[NSMutableArray alloc] init];
        NSArray * arrMenuList = [jsonData objectForKey:@"app_ad_monitor_list"];
        for(NSDictionary * dic in arrMenuList){
            NSLog(@"is_display %@", [dic objectForKey:@"is_display"]);
            if([[dic objectForKey:@"is_display"] isEqualToString:@"Y"]){
                [arrClassName addObject:[dic objectForKey:@"id"]];
            }
        }
        
        //띠 광고순서
        if(isShowBanner){
            arrBannerOrder = [[NSMutableArray alloc] init];
            NSArray * arrList = [[dicInfo objectForKey:@"line_ad_platform_no"] componentsSeparatedByString:@","];
            for(NSString * strNo in arrList){
                [arrBannerOrder addObject:[NSNumber numberWithInt:[strNo intValue]]];
            }
            if(arrBannerOrder.count > 0){
                nWillShowAdBanner = [[arrBannerOrder objectAtIndex:0] intValue];
            }
        }
        
        //전면 광고순서
        if(isShowInterstitial){
            arrInterstitialOrder = [[NSMutableArray alloc] init];
            NSArray * arrList = [[dicInfo objectForKey:@"full_ad_platform_no"] componentsSeparatedByString:@","];
            for(NSString * strNo in arrList){
                [arrInterstitialOrder addObject:[NSNumber numberWithInt:[strNo intValue]]];
            }
            if(arrInterstitialOrder.count > 0){
                nWillShowAdInterstitial = [[arrInterstitialOrder objectAtIndex:0] intValue];
            }
        }
        
        //한다광고 리스트
        arrHandaAdList = [[NSMutableArray alloc] init];
        NSArray * arrayHandaAdList = [jsonData objectForKey:@"pay_banner_list"];
        for(NSDictionary * dic in arrayHandaAdList){
            ADData * data = [[ADData alloc] init];
            data.strAdNo = [dic objectForKey:@"banner_no"];
            data.strAdvertiser = [dic objectForKey:@"advertiser_no"];
            data.nBannerAdType = [[dic objectForKey:@"line_ad_type"] intValue];
            data.strBannerBgColor = [dic objectForKey:@"line_ad_color"];
            data.strBannerImage = [dic objectForKey:@"line_ad_image"];
            data.strBannerLandingUrl = [dic objectForKey:@"ios_line_landing_url"];
            data.strInterstitialImage = [dic objectForKey:@"full_end_ad_image"];
            data.strInterstitialLandingUrl = [dic objectForKey:@"ios_full_end_landing_url"];
            //광고 형태 비트연산으로 세팅
            int nType = 0;
            NSArray * array = [[dic objectForKey:@"ad_type"]  componentsSeparatedByString:@","];
            for(NSString * strType in array){
                NSLog(@"strType %@", strType);
                if([strType isEqualToString:@"1"]){
                    nType |= [HandaAdEnvironment ADTYPE_BANNER];
                }else if([strType isEqualToString:@"2"]){
                    nType |= [HandaAdEnvironment ADTYPE_INTERSTITIAL];
                }
            }
            data.nAdType = nType;
            [arrHandaAdList addObject:data];
        }
        
        //하우스광고 리스트
        arrHouseAdList = [[NSMutableArray alloc] init];
        NSArray * arrayHouseAdList = [jsonData objectForKey:@"house_banner_list"];
        for(NSDictionary * dic in arrayHouseAdList){
            ADData * data = [[ADData alloc] init];
            data.strAdNo = [dic objectForKey:@"banner_no"];
            data.strAdvertiser = [dic objectForKey:@"advertiser_no"];
            data.nBannerAdType = [[dic objectForKey:@"line_ad_type"] intValue];
            data.strBannerBgColor = [dic objectForKey:@"line_ad_color"];
            data.strBannerImage = [dic objectForKey:@"line_ad_image"];
            data.strBannerLandingUrl = [dic objectForKey:@"ios_line_landing_url"];
            data.strInterstitialImage = [dic objectForKey:@"full_end_ad_image"];
            data.strInterstitialLandingUrl = [dic objectForKey:@"ios_full_end_landing_url"];
            //광고 형태 비트연산으로 세팅
            int nType = 0;
            NSArray * array = [[dic objectForKey:@"ad_type"] componentsSeparatedByString:@","];
            for(NSString * strType in array){
                NSLog(@"strType %@", strType);
                if([strType isEqualToString:@"1"]){
                    nType |= [HandaAdEnvironment ADTYPE_BANNER];
                }else if([strType isEqualToString:@"2"]){
                    nType |= [HandaAdEnvironment ADTYPE_INTERSTITIAL];
                }
            }
            data.nAdType = nType;
            [arrHouseAdList addObject:data];
        }
       
        //추천앱 리스트
        arrRecommendAppList = [[NSMutableArray alloc] init];
        NSArray *  arrayRecommAdList = [jsonData objectForKey:@"recommend_app_list"];
        for(NSDictionary * dic in arrayRecommAdList){
            [arrRecommendAppList addObject:dic];
        }
        
        //광고 인터벌
        nShowInterval = [[dicInfo objectForKey:@"app_full_ad_interval"] intValue];
        
        NSLog(@"app_start_is_display %@", [dicInfo objectForKey:@"app_start_is_display"]);
        //전면광고 바로 노출 할지 여부
        if([[dicInfo objectForKey:@"app_start_is_display"] isEqualToString:@"Y"]){
            bShowAtFirstRun = YES;  //체크되있으면 바로 보여주고
        }
//        else{
//            [self checkTime];   // 아니면 인터벌 후 보여준다
//        }
        
        //전면광고 앱 설치 후 첫 실행 시간(분)
        nFirstActionTime = [[dicInfo objectForKey:@"app_full_ad_install"] intValue];
        NSString * str = [UserDefaults loadUserDefaults:[NSString stringWithFormat:@"%@_installed", [[NSBundle mainBundle] bundleIdentifier]]];
        if(str == nil){//첫 실행시 한번만 세팅
            [UserDefaults saveUserDefaults:@"yes" forKey:[NSString stringWithFormat:@"%@_installed", [[NSBundle mainBundle] bundleIdentifier]]];
            //설치 된 시간 세팅
            [UserDefaults saveUserDefaults:[NSNumber numberWithInt:(int)[NSDate timeIntervalSinceReferenceDate]] forKey:[NSString stringWithFormat:@"%@_installed_time", [[NSBundle mainBundle] bundleIdentifier]]];
        }
        
        return YES;
    }else{
        return NO;
    }
}

- (void)resetADOrder:(int)nType{
    if(nType == [HandaAdEnvironment ADTYPE_BANNER]){
        if(arrBannerOrder != nil && arrBannerOrder.count > 0){
            nIndexOfBannerOrder = nFailCountBanner = 0;
            nWillShowAdBanner = [[arrBannerOrder objectAtIndex:0] intValue];
        }
    }else if(nType == [HandaAdEnvironment ADTYPE_INTERSTITIAL]){
        if(arrInterstitialOrder != nil && arrInterstitialOrder.count > 0){
            nIndexOfInterstitialOrder = nFailCountInterstitial = 0;
            nWillShowAdInterstitial = [[arrInterstitialOrder objectAtIndex:0] intValue];
        }
    }
}

@end
