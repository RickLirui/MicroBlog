//
//  NetworkManager.h
//  LiRickMicroBlog
//
//  Created by Rick on 13/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UserModel.h"
#import "WeiboModel.h"


typedef NS_ENUM(NSInteger, SendRequestType)
{
    ESendRequestTypeSendPic,
    ESendRequestTypeSendText,
    ESendRequestTypeRepost,
    ESendRequestTypeComment,
    EReceiveHomeWeibo,
    EReceiveHomeWeiboRefresh,
    EReceiveUserInfo,
    EReceiveUserWeibo,
    EReceiveHomeWeiboComment,
    EReceiveHomeWeiboCommentRefresh,
};

@protocol NetWorkManagerDelegate <NSObject>

@required

- (void)receivedResponseSuccess:(NSMutableDictionary *) reDic type:(SendRequestType) type;

- (void)receivedResponseFailed:(NSError *)error;

@end

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedManager;

@property (nonatomic, weak)id<NetWorkManagerDelegate>delegate;

- (void)postWeiboText:(NSString *)text delegate:(id<NetWorkManagerDelegate>)delegate;

- (void)postWeiboPic:(NSString *)text image:(UIImage *)image delegate: (id<NetWorkManagerDelegate>)delegate;

- (void)postRepostWeibo:(NSDictionary *) dic delegate:(id<NetWorkManagerDelegate>)delegate;

- (void)postWeiboComment:(NSDictionary *)dic delegate:(id<NetWorkManagerDelegate>)delegate;

- (void)getWeibo:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate;

- (void)getUserWeibo:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate;

- (void)getUserDelegate: (id<NetWorkManagerDelegate>)delegate;

- (void)getWeiboComment:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate;


@end
