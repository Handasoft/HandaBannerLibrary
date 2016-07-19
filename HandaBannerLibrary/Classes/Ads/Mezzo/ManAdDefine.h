//
//  ManAdDefine.h
//  ManAdDefine
//
//  Created by MezzoMedia on 13. 2. 1..
//  Copyright (c) 2013년 MezzoMedia. All rights reserved.
//

#ifndef ManAdDefine_h
#define ManAdDefine_h

#define MAN_BANNER_AD_HEIGHT    50.0f

/* 광고 수신 에러
 */
typedef enum {
    
    ManAdSuccess            = 0,           // 성공
    ManAdNetworkError       = -100,        // 네트워크 에러
    ManAdServerError        = -200,        // 광고 서버 에러
    ManAdApiTypeError       = -300,        // API Type 에러
    ManAdAppIDError         = -400,        // App ID값 에러
    ManAdWindowIDError      = -500,        // Window ID값 에러
    ManAdNotNormalIDError   = -600,        // 해당 ID값이 정상적이지 않음
    ManAdNotExistAd         = -700         // 해당 ID의 광고가 존재하지 않음
    
} ManAdErrorType;

/* 동영상 광고 모드
 */
typedef enum {
    
    MODE_NORMAL,
    MODE_WIDE,
    MODE_STRETCH,
    MODE_ORIGNAL
    
} MOVIE_SCREEN_MODE;

#endif
