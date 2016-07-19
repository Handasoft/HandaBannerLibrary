//
//  HandaBannerView.m
//  divination
//
//  Created by Kim Dukki on 1/26/15.
//  Copyright (c) 2015 Kim Dukki. All rights reserved.
//

#import "HandaBannerView.h"
#import "HandaAdEnvironment.h"
#import "HandaAdController.h"
#import "Global.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation HandaBannerView
@synthesize delegate = _delegate;

- (void)start{
    NSArray * array = [HandaAdController Access].arrHandaAdList;
    if(array != nil && array.count > 0){
        adData = [array objectAtIndex:arc4random() % array.count];
        if(adData){
            if(adData.nAdType == 1){//비율유지 + 좌우여백채우기
                self.contentMode = UIViewContentModeScaleAspectFit;
                unsigned result = 0;
                NSScanner *scanner = [NSScanner scannerWithString:adData.strBannerBgColor];
                if(scanner)
                {
                    [scanner setScanLocation:1]; // bypass '#' character
                    [scanner scanHexInt:&result];
                    self.backgroundColor = UIColorFromRGB(result);
                }

                
            }else if(adData.nAdType == 2){
                self.contentMode = UIViewContentModeScaleToFill;
            }
            
            self.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            [self addGestureRecognizer:tapRecognizer];
            
            UIActivityIndicatorView * indicator;
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicator.hidesWhenStopped = YES;
            indicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            [indicator startAnimating];
            [self addSubview:indicator];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if([adData.strBannerImage compare:@""]){
                    NSURL * url = [NSURL URLWithString:adData.strBannerImage];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        if(data != nil){
                            self.image = [[UIImage alloc] initWithData:data];
                            [self.delegate onLoadSuccess:adData.strAdNo advertiser:adData.strAdvertiser];
                        }else{
                            [self.delegate onLoadFail];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate onLoadFail];
                        [indicator stopAnimating];
                    });
                }
            });
        }else{
            [self.delegate onLoadFail];
        }
    }else{
        [self.delegate onLoadFail];
    }
}

- (void)stop{
    
}

#pragma mark - selector

- (void)imageTapped:(UIImageView*)image{
    if(adData){
        [self.delegate onClickAD:adData.strAdNo advertiser:adData.strAdvertiser];

        NSURL* redirectToURL = [NSURL URLWithString:adData.strBannerLandingUrl];
        [[UIApplication sharedApplication] openURL:redirectToURL];
    }
}
@end
