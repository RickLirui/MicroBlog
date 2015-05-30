//
//  UserModel.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (id) initUserWithData:(NSDictionary *) data
{
    
    if(self = [super init])
    {
        
        NSString *flag = data[@"screen_name"];
        self.nickName = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];
        
        flag = data[@"description"];
        self.descript = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];
    
        flag = data[@"idstr"];
        self.idStr = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];

        self.profileImageUrl =[NSURL URLWithString:(data[@"avatar_large"])];
        self.fansCount = data[@"followers_count"];
        self.followCount = data[@"friends_count"];
        self.weiboCount = data[@"statuses_count"];
    }
    return self;
}



@end
