//
//  UserModel.h
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject


@property(nonatomic,copy)NSString *idStr;                   //字符串型的用户UID
@property(nonatomic,copy)NSString *nickName;                //用户昵称
@property(nonatomic,copy)NSString *descript;                //用户个人描述
@property(nonatomic,copy)NSURL *profileImageUrl;         //用户头像地址，50×50像素
@property(nonatomic,retain)NSNumber *fansCount;        //粉丝数
@property(nonatomic,retain)NSNumber *followCount;          //关注数
@property(nonatomic,retain)NSNumber *weiboCount;         //微博数


- (id) initUserWithData:(NSDictionary *) data;
@end
