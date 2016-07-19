//
//  HandaAdEnvironment.h
//  divination
//
//  Created by Kim Dukki on 1/22/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandaAdEnvironment : NSObject

typedef enum{
    CAULY = 1,
    SYRUP,//2
    MEZZO,//3
    ADAM,//4
    SHALLWEAD,//5
    INMOBI,//6
    TNK,//7
    HANDASOFT=9999,
    HOUSE=10000,
}HANDA_AD_INDEX;

+(int)TOTAL_AD_COUNT;
+(int)MEMTYPE_NONE;
+(int)MEMTYPE_ASS_MALE;
+(int)MEMTYPE_REGULAR_MALE;
+(int)MEMTYPE_ASS_FEMALE;
+(int)MEMTYPE_REGULAR_FEMALE;
+(int)ADTYPE_BANNER;
+(int)ADTYPE_INTERSTITIAL;
+(NSString*)AD_API_DOMAIN;
+(NSString*)AD_ID_CAULY;
+(NSString*)AD_ID_SYRUP_BANNER;
+(NSString*)AD_ID_SYRUP_INTERSTITIAL;
+(NSString*)AD_ID_MEZZO;
+(NSString*)AD_ID_ADAM_BANNER;
+(NSString*)AD_ID_ADAM_INTERSTITIAL;
//+(NSString*)AD_ID_TNK;
+(long long)AD_ID_INMOBI_BANNER;
+(long long)AD_ID_INMOBI_INTERSTITIAL;
+(NSString*)ACCOUNT_ID_INMOBI;
@end
