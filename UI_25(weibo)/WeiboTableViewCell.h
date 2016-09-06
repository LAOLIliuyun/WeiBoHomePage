//
//  WeiboTableViewCell.h
//  UI_25(weibo)
//
//  Created by Ibokan on 16/7/4.
//  Copyright © 2016年 tanzhongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *zhenwenlabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *tiemLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end
