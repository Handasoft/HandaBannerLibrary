//
//  HandaInterstitialViewController.h
//  divination
//
//  Created by Kim Dukki on 1/27/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADData.h"

@class HandaInterstitialViewController;
@protocol HandaInterstitialViewControllerDelegate <NSObject>
- (void) onClose;
- (void) onClickAD:(NSString *)strAppNo advertiser:(NSString*)strAdvertiserNo;
@end

@interface HandaInterstitialViewController : UIViewController{
    UIImageView *ivInterstitial;
    UIButton * closeBtn;
}
@property (strong, nonatomic)ADData * adData;
@property (weak, nonatomic) id<HandaInterstitialViewControllerDelegate> delegate;
@end
