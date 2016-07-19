//
//  HandaAppRecommendViewController.m
//  HandaAd
//
//  Created by 개발1팀_김덕기 on 2016. 1. 22..
//  Copyright © 2016년 Kim Dukki. All rights reserved.
//

#import "HandaAppRecommendViewController.h"
#import "RecommendAppCell.h"
#import "HandaAdEnvironment.h"
#import "HandaAdController.h"
#import "Global.h"

@interface HandaAppRecommendViewController ()

@end

@implementation HandaAppRecommendViewController
@synthesize arrData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void) loadView{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvTitle = [[UILabel alloc] initWithFrame:CGRectMake(17, 18, 286, 21)];
    tvTitle.textAlignment = NSTextAlignmentCenter;
    tvTitle.font = [UIFont systemFontOfSize:14];
    tvTitle.textColor = RGB(0, 174, 205);
    [self.view addSubview:tvTitle];
    
    tvDesc = [[UILabel alloc] initWithFrame:CGRectMake(36, 33, 243, 35)];
    tvDesc.textAlignment = NSTextAlignmentCenter;
    tvDesc.font = [UIFont systemFontOfSize:9];
    tvDesc.numberOfLines = 2;
    tvDesc.textColor = RGB(85, 85, 85);
    [self.view addSubview:tvDesc];
    
    tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height-70)];
    tableList.delegate = self;
    tableList.dataSource = self;
    [self.view addSubview:tableList];
    
    tvTitle.text = [NSString stringWithFormat:@"%@을(를) 후원하는 어플을 설치해주세요", @"점신"];
    tvDesc.text = [NSString stringWithFormat:@"%@을(를) 후원하는 어플을 설치해주시면\n더 많고 유용한 무료어플을 개발/서비스 하겠습니다.", @"점신"];
    
    NSMutableArray * arrInstalled = [[NSMutableArray alloc] init];
    NSMutableArray * arrNotInstalled = [[NSMutableArray alloc] init];
    for(NSDictionary * dic in arrData){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[dic objectForKey:@"schema_id"]]]){
            [arrInstalled addObject:dic];
        }else{
            [arrNotInstalled addObject:dic];
        }
    }
    arrayData = [[NSMutableArray alloc] init];
    for(NSDictionary * dic in arrNotInstalled){
        [arrayData addObject:dic];
    }
    for(NSDictionary * dic in arrInstalled){
        [arrayData addObject:dic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecommendAppCell";
    RecommendAppCell *cell = (RecommendAppCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RecommendAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * dicAD = [arrayData objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnAction.tag = indexPath.row;
    
    cell.labelTitle.text = [dicAD objectForKey:@"name"];
    cell.tvDesc.text = [dicAD objectForKey:@"comment"];
    cell.tvDesc.contentInset = UIEdgeInsetsMake(-5, 0, -5, 0);
    [cell.btnAction addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIActivityIndicatorView * indicator;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.center = CGPointMake(cell.ivIcon.frame.size.width/2, cell.ivIcon.frame.size.height/2);
    [indicator startAnimating];
    [cell.ivIcon addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:[dicAD objectForKey:@"icon"]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(data != nil){
                cell.ivIcon.image = [[UIImage alloc] initWithData:data];
            }
        });
    });
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[dicAD objectForKey:@"schema_id"]]]){
        [cell.btnAction setImage:[UIImage imageNamed:@"HandaAd.bundle/recommend_btn_action.png"] forState:UIControlStateNormal];
        [cell.btnAction setImage:[UIImage imageNamed:@"HandaAd.bundle/recommend_btn_action_on.png"] forState:UIControlStateHighlighted];
    }else{
        [cell.btnAction setImage:[UIImage imageNamed:@"HandaAd.bundle/recommend_btn_install.png"] forState:UIControlStateNormal];
        [cell.btnAction setImage:[UIImage imageNamed:@"HandaAd.bundle/recommend_btn_install_on.png"] forState:UIControlStateHighlighted];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - selector

- (void)actionButtonPressed:(UIButton*)sender
{
    NSDictionary * dicAD = [arrayData objectAtIndex:sender.tag];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *stringParam = [NSString stringWithFormat:@"method=set.recommend.app.click&partner_code=mobile_ios&app_no=%d&inflow_app_no=%@", [[HandaAdController Access] nAppNo], [dicAD objectForKey:@"app_no"]];
        NSLog(@"%@?%@", [NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]], stringParam);
        [[Global Access] SendPost:[NSString stringWithFormat:@"http://%@/office/api_v2.php", [HandaAdEnvironment AD_API_DOMAIN]] withParam:stringParam];
    });
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[dicAD objectForKey:@"schema_id"]]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dicAD objectForKey:@"schema_id"]]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@?mt=8", [dicAD objectForKey:@"package_id"]]]];
    }
}
@end
