//
//  HandaAdEnvironment.m
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaAdEnvironment.h"

@implementation HandaAdEnvironment

+(int)TOTAL_AD_COUNT{
    return 10;
}
+(int)MEMTYPE_NONE{
    return 1;
}
+(int)MEMTYPE_ASS_MALE{
    return 2;
}
+(int)MEMTYPE_REGULAR_MALE{
    return 4;
}
+(int)MEMTYPE_ASS_FEMALE{
    return 8;
}
+(int)MEMTYPE_REGULAR_FEMALE{
    return 16;
}

+(int)ADTYPE_BANNER{
    return 1;
}
+(int)ADTYPE_INTERSTITIAL{
    return 2;
}

+(NSString*)AD_API_DOMAIN{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"handa"] objectForKey:@"domain"];
}
+(NSString*)AD_ID_CAULY{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"cauly"] objectForKey:@"id"];
}
+(NSString*)AD_ID_SYRUP_BANNER{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"tad"] objectForKey:@"banner"];
}
+(NSString*)AD_ID_SYRUP_INTERSTITIAL{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"tad"] objectForKey:@"interstitial"];
}
+(NSString*)AD_ID_MEZZO{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"mezzo"] objectForKey:@"id"];
}
+(NSString*)AD_ID_ADAM_BANNER{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"adam"] objectForKey:@"banner"];
}
+(NSString*)AD_ID_ADAM_INTERSTITIAL{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"adam"] objectForKey:@"interstitial"];
}
+(NSString*)ACCOUNT_ID_INMOBI{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[dic objectForKey:@"inmobi"] objectForKey:@"account"];
}
+(long long)AD_ID_INMOBI_INTERSTITIAL{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[[dic objectForKey:@"inmobi"] objectForKey:@"interstitial"] longLongValue];
}
+(long long)AD_ID_INMOBI_BANNER{
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HandaAdProperty" ofType:@"plist"]];
    return [[[dic objectForKey:@"inmobi"] objectForKey:@"banner"] longLongValue];
}
@end
