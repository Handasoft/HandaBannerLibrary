//
//  HandaBannerView.h
//  divination
//
//  Created by Kim Dukki on 1/26/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADData.h"

@class HandaBannerView;
@protocol HandaBannerViewDelegate <NSObject>
- (void) onLoadSuccess:(NSString *)strBannerNo advertiser:(NSString *)strAdvertiserNo;
- (void) onLoadFail;
- (void) onClickAD:(NSString *)strAppNo advertiser:(NSString*)strAdvertiserNo;
@end

@interface HandaBannerView : UIImageView{
    ADData * adData;
}
@property (weak, nonatomic) id<HandaBannerViewDelegate> delegate;

- (void)start;
- (void)stop;
@end
