//
//  DKAppEnvironment.h
//  SajuWithSNSpage
//
//  Created by dicadong on 11. 12. 15..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULTDOMAIN @"www.handaunse.co.kr"
//#define DEFAULTDOMAIN @"dev.clubtime.co.kr"
#define DEFAULTDOMAIN2 @"bta2.clubtime.co.kr"
#define APPIDX 6 //무료=6 유료=7

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7 ? YES : NO)
#define IS_IOS6 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 6 ? YES : NO)
#define IS_480_SCREEN ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)

@interface Global : NSObject{
    
}

+ (Global *)Access;
+ (void)logout;
- (NSString*) SendPost:(NSString*)url withParam:(NSString*)parameter;
- (NSDictionary*) SendPostReceiveJson:(NSString *)url withParam:(NSString *)parameter;

@end
//에러코드
//001 : 로그인 할 때 회원번호가 없음