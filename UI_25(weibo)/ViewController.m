//
//  ViewController.m
//  UI_25(weibo)
//
//  Created by Ibokan on 16/7/4.
//  Copyright © 2016年 tanzhongyi. All rights reserved.
//

#import "ViewController.h"
#import "WeiboModel.h"
#import "WeiboTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
     NSMutableArray *dataShource;
     UITableView *youTableView;
     UIActivityIndicatorView *act;
     NSURLSession *downsession;
    }
@end

@implementation ViewController
-(void)createActivityIndicatorView{
     act =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     act.center=self.view.center;
     act.hidesWhenStopped=YES;
     youTableView.hidden=YES;
     [self.view addSubview:act];
     [act startAnimating];
}
- (void)viewDidLoad {
     [super viewDidLoad];
     youTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
     youTableView.delegate=self;
     youTableView.dataSource=self;
     youTableView.rowHeight=100;
     [self.view addSubview:youTableView];
     
     [youTableView registerNib:[UINib nibWithNibName:@"WeiboTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([WeiboTableViewCell class])];
     // Do any additional setup after loading the view, typically from a nib.
     
     //菊花器
     [self createActivityIndicatorView];
     //下拉刷新
     UIRefreshControl *freshc=[UIRefreshControl new];
     [freshc addTarget:self action:@selector(freshcACtion:) forControlEvents:UIControlEventValueChanged];
     freshc.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中...." attributes:nil];
     freshc.tintColor=[UIColor redColor];
     [youTableView addSubview:freshc];
     
     //初始化数据
     [self initData];
    //第三方类库下拉刷新
    youTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(freshcACtion:)];
    //第三方类库上啦加载
    youTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    
}
-(void)moreData{
    NSString *urlSting=@"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00PGtNSCI_wxYC1b8f6ca1fc0obeAQ";
    NSURLRequest *re = [NSURLRequest requestWithURL: [NSURL URLWithString:urlSting]];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLSessionDataTask *task1 = [session1 dataTaskWithRequest:re completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *statuses=dic[@"statuses"];
        for (NSDictionary *weiboDIc in statuses) {
            BOOL hasMore = NO;
            for (WeiboModel *m in dataShource) {
                if ((m.weiboID = [weiboDIc[@"id"]integerValue]) ) {
                    hasMore = YES ;
                    break;
                }
            }
            if (hasMore) {
                continue;
            }
            WeiboModel *weibom=[WeiboModel new];
            weibom.headImagepath=weiboDIc[@"user"][@"profile_image_url"];
            weibom.name=weiboDIc[@"user"][@"name"];
            if ([(NSString *)weiboDIc[@"created_at"]length ]!=0) {
                weibom.time=[weiboDIc[@"created_at"]substringWithRange:NSMakeRange(4, 6)];
            }else{
                weibom.time=@"";
            }
            if ([(NSString *)weiboDIc[@"source"]length]!=0) {
                NSRange range=[weiboDIc[@"source"]rangeOfString:@">"];
                NSString *string=[weiboDIc[@"source"]substringFromIndex:range.location+range.length ];
                range=[string rangeOfString:@"<"];
                string=[string substringToIndex:range.location];
                weibom.from=string;
            }else{
                weibom.from=@"";
            }
            
            weibom.text=weiboDIc[@"text"];
            [dataShource addObject:weibom];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [youTableView.mj_footer endRefreshing];
            [youTableView reloadData];
        });

    }];
    [task1 resume];
}



-(void)freshcACtion:(UIRefreshControl *)sender{
     NSLog(@"我在加载数据");
     
     NSString *urlSting=@"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00PGtNSCI_wxYC1b8f6ca1fc0obeAQ";
     NSURLRequest *requst=[NSURLRequest requestWithURL:[NSURL URLWithString:urlSting]];
     downsession=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
     NSURLSessionDataTask *dataTask=[downsession dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          dataShource =[NSMutableArray array];
          NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
          NSArray *statuses=dic[@"statuses"];
          for (NSDictionary *weiboDIc in statuses) {
               WeiboModel *weibom=[WeiboModel new];
              weibom.weiboID = [weiboDIc[@"id"]integerValue];
               weibom.headImagepath=weiboDIc[@"user"][@"profile_image_url"];
               weibom.name=weiboDIc[@"user"][@"name"];
               if ([(NSString *)weiboDIc[@"created_at"]length ]!=0) {
                    weibom.time=[weiboDIc[@"created_at"]substringWithRange:NSMakeRange(4, 6)];
               }else{
                    weibom.time=@"";
               }
               if ([(NSString *)weiboDIc[@"source"]length]!=0) {
                    NSRange range=[weiboDIc[@"source"]rangeOfString:@">"];
                    NSString *string=[weiboDIc[@"source"]substringFromIndex:range.location+range.length ];
                    range=[string rangeOfString:@"<"];
                    string=[string substringToIndex:range.location];
                    weibom.from=string;
               }else{
                    weibom.from=@"";
               }
              
               weibom.text=weiboDIc[@"text"];
               [dataShource addObject:weibom];
               
          }
          dispatch_async(dispatch_get_main_queue(), ^{
               [sender endRefreshing];
               [youTableView reloadData];
          });
     }];
     [dataTask resume];
     
     
     
    
}
-(void)initData{
     dataShource =[NSMutableArray array];
     NSString *urlSting=@"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00PGtNSCI_wxYC1b8f6ca1fc0obeAQ";
     NSURLRequest *requst=[NSURLRequest requestWithURL:[NSURL URLWithString:urlSting]];
     NSURLSession *session=[NSURLSession sharedSession];
     NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

          NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
          NSLog(@"%@",dic);
          NSLog(@"%@",response);
          NSArray *statuses=dic[@"statuses"];
          for (NSDictionary *weiboDIc in statuses) {
               WeiboModel *weibom=[WeiboModel new];
              weibom.weiboID = [weiboDIc[@"id"]integerValue];
              
               weibom.headImagepath=weiboDIc[@"user"][@"profile_image_url"];
               weibom.name=weiboDIc[@"user"][@"name"];
               if ([(NSString *)weiboDIc[@"created_at"]length]!=0) {
                    weibom.time=[weiboDIc[@"created_at"]substringWithRange:NSMakeRange(4, 6)];
               }else{
                    weibom.time=@"";
               }
               if ([(NSString *)weiboDIc[@"source"]length]!=0) {
                    NSRange range=[weiboDIc[@"source"]rangeOfString:@">"];
                    NSString *string=[weiboDIc[@"source"]substringFromIndex:range.location+range.length ];
                    range=[string rangeOfString:@"<"];
                    string=[string substringToIndex:range.location];
                    weibom.from=string;
               }else{
                    weibom.from=@"";
               }
               weibom.text=weiboDIc[@"text"];
               [dataShource addObject:weibom];
               
          
               
          
          }
          dispatch_async(dispatch_get_main_queue(), ^{
               youTableView.hidden=NO;
               [act stopAnimating];
               [youTableView reloadData];
          });
          
//          NSLog(@"%@",dataShource);
     }];
     [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return dataShource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     WeiboTableViewCell *cell=(WeiboTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WeiboTableViewCell class])];
     WeiboModel *m=dataShource[indexPath.row];
//     cell.headImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:m.headImagepath]]];
     [cell.headImage sd_setImageWithURL:[NSURL URLWithString:m.headImagepath]];
     cell.nameLable.text=m.name;
     cell.fromLabel.text=m.from;
     cell.zhenwenlabel.text=m.text;
     cell.tiemLabel.text=m.time;
     float cellHeight=[m.text boundingRectWithSize:CGSizeMake(cell.contentView.frame.size.width,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.zhenwenlabel.font} context:nil].size.height;
     cell.zhenwenlabel.backgroundColor=[UIColor cyanColor];
     m.cellHeight=cellHeight+80;
     
     return cell;
     
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     float height=[(WeiboModel *)dataShource[indexPath.row]cellHeight];
     return height;
}
- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

@end
