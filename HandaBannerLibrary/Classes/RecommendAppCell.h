//
//  RecommendAppCell.h
//  fortune_couple
//
//  Created by Kim Dukki on 12/30/13.
//  Copyright (c) 2013 Kim Dukki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendAppCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivIcon;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;

@end
