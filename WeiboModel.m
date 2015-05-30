//
//  WeiboModel.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "WeiboModel.h"
#import <stdlib.h>

@implementation WeiboModel

- (id) initWeiboWithData:(NSDictionary *)dic
{
    if(self = [super init])
    {
        self.hasPicture = NO;
        self.hasRepost = NO;
        
        NSDictionary *userDic = dic[@"user"];
        UserModel *user = [[UserModel alloc] initUserWithData:userDic];
        
        NSString *flag = dic[@"text"];
        self.text = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];
        
        flag = userDic[@"name"];
        self.name = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];

        NSDictionary *repostDic = dic[@"retweeted_status"];
        if(repostDic)
        {
            NSDictionary *repostUser = repostDic[@"user"];
            NSString *name = repostUser[@"screen_name"];
            NSString *subStrContact = [name stringByAppendingString:@":"];
            self.repostWeiboText = repostDic[@"text"];
            NSString *contect = [subStrContact stringByAppendingString:self.repostWeiboText];
            self.repostWeiboText = contect;
            self.hasRepost = YES;

        }
        
        if(dic[@"original_pic"])
        {
            self.picUrl =[NSURL URLWithString:(dic[@"original_pic"])];
            self.hasPicture = YES;
        }
        
        self.profileImageUrl = user.profileImageUrl;
        
        NSNumber *num = [[NSNumber alloc] init];
        num = dic[@"reposts_count"];
        self.repostsCount =[num intValue];
        
        num = dic[@"comments_count"];
        self.commentsCount = [num intValue];
        
        num = dic[@"attitudes_count"];
        self.likesCount = [num intValue];
        
        self.creatDate = dic[@"created_at"];
        
        flag = dic[@"id"];
        self.weiboID = [flag longLongValue];        
    }
    return self;
}



@end
