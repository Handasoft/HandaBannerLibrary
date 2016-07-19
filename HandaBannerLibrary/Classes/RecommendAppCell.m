//
//  RecommendAppCell.m
//  fortune_couple
//
//  Created by Kim Dukki on 12/30/13.
//  Copyright (c) 2013 Kim Dukki. All rights reserved.
//

#import "RecommendAppCell.h"

@implementation RecommendAppCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(11, 6, 48, 48)];
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(67, 2, 179, 21)];
        self.labelTitle.font = [UIFont systemFontOfSize:15];
        self.labelTitle.textColor = [UIColor blackColor];
        
        self.tvDesc = [[UITextView alloc] initWithFrame:CGRectMake(62, 19, 196, 35)];
        self.tvDesc.font = [UIFont systemFontOfSize:9];
        self.tvDesc.textColor = [UIColor grayColor];
        
        self.btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnAction.frame = CGRectMake(263, 11, 46, 37);
        
        [self addSubview:self.ivIcon];
        [self addSubview:self.labelTitle];
        [self addSubview:self.tvDesc];
        [self addSubview:self.btnAction];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
