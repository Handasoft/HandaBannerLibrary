//
//  HandaAppRecommendViewController.h
//  HandaAd
//
//  Created by 개발1팀_김덕기 on 2016. 1. 22..
//  Copyright © 2016년 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandaAppRecommendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UILabel *tvTitle;
    UILabel *tvDesc;
    UITableView *tableList;
    NSMutableArray * arrayData;
}
@property (strong, nonatomic) NSArray * arrData;
@end
