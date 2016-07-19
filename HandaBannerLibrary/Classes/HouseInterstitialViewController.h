//
//  HouseInterstitialViewController.h
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADData.h"

@class HouseInterstitialViewController;
@protocol HouseInterstitialViewControllerDelegate <NSObject>
- (void) onClose;
- (void) onClickAD:(NSString *)strAppNo advertiser:(NSString*)strAdvertiserNo;
@end

@interface HouseInterstitialViewController : UIViewController{
    UIImageView *ivInterstitial;
    UIButton * closeBtn;
}
@property (strong, nonatomic)ADData * adData;
@property (weak, nonatomic) id<HouseInterstitialViewControllerDelegate> delegate;
@end
