//
//  WeiboModel.h
//  UI_25(weibo)
//
//  Created by Ibokan on 16/7/4.
//  Copyright © 2016年 tanzhongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboModel : NSObject
@property(nonatomic,strong)NSString *headImagepath;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *from;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,assign)float cellHeight;
@property (nonatomic,assign)int64_t weiboID;

@end
