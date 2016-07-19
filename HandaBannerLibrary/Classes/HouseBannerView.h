//
//  HandaBannerView.h
//  divination
//
//  Created by Kim Dukki on 1/26/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADData.h"

@class HouseBannerView;
@protocol HouseBannerViewDelegate <NSObject>
- (void) onLoadSuccess_House:(NSString *)strBannerNo;
- (void) onLoadFail_House;
- (void) onClickAD_House:(NSString *)strAppNo;
@end

@interface HouseBannerView : UIImageView{
    ADData * adData;
}
@property (weak, nonatomic) id<HouseBannerViewDelegate> delegate;

- (void)start;
- (void)stop;
@end
