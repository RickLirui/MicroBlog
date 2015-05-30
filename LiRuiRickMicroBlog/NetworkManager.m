//
//  NetworkManager.m
//  LiRickMicroBlog
//
//  Created by Rick on 13/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "Define.h"

@implementation NetworkManager

+ (NetworkManager *)sharedManager
{
    static dispatch_once_t pred;
    static NetworkManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        
        sharedManager = [[NetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (void)postWeiboText:(NSString *)text  delegate:(id<NetWorkManagerDelegate>)delegate
{
    
    self.delegate = delegate;

    NSString *accesstoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];

    NSDictionary *postParams = @{@"access_token" : accesstoken,
                                 @"status" : text};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    [mgr POST:KSendWeiboTextURL parameters:postParams
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {
             NSNumber *intNum = [NSNumber numberWithInt:2];
             NSMutableDictionary *reDic = [NSMutableDictionary dictionaryWithObject:intNum forKey:@"statue"];

             [self.delegate receivedResponseSuccess:reDic type:(SendRequestType) ESendRequestTypeSendText];
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];

}

- (void)postWeiboPic:(NSString *)text image:(UIImage *)image delegate:(id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;
    
    NSString *accesstoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    
    NSDictionary *params = @{@"access_token" : accesstoken,
                             @"status" : text};
    
    NSData *imageData = UIImageJPEGRepresentation(image, .2);
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr POST:KSendWeiboPicURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
        {
            NSNumber *intNum = [NSNumber numberWithInt:1];
            NSMutableDictionary *reDic = [NSMutableDictionary dictionaryWithObject:intNum forKey:@"statue"];

            [self.delegate receivedResponseSuccess:reDic type:(SendRequestType) ESendRequestTypeSendPic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate receivedResponseFailed:error];
    }];
}


- (void)getWeibo:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:access_token forKey:@"access_token"];
    [params addEntriesFromDictionary:dic];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:KGetWeiboURL parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {
//             NSNumber *intNum = [NSNumber numberWithInt:4];
//             
//             NSMutableDictionary *reDic = [NSMutableDictionary dictionaryWithObject:intNum forKey:@"flag"];
//             [reDic addEntriesFromDictionary:responseObject];
             
             if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
             {
                 NSObject *object = [dic objectForKey:@"max_id"];
                 if (object)
                 {
                     [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) EReceiveHomeWeiboRefresh];
                 }
                 else
                     [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) EReceiveHomeWeibo];


             }
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];

}


- (void)getUserDelegate: (id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    int64_t uid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] integerValue];
    
    NSDictionary *params = @{@"access_token" : access_token,
                             @"uid" : @(uid)};
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:KGetUserURL parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UserModel *user = [[UserModel alloc] initUserWithData:responseObject];
         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {

             NSMutableDictionary *reDic = [NSMutableDictionary dictionaryWithObject:user forKey:@"user"];

             [self.delegate receivedResponseSuccess:reDic type:(SendRequestType) EReceiveUserInfo];
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];

}

- (void)getUserWeibo:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *uid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:access_token,@"access_token",uid,@"uid", nil];
    [params addEntriesFromDictionary:dic];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:KGetUserWeiboURL parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
            [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) EReceiveUserWeibo];
             

     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];
}

- (void)postRepostWeibo:(NSDictionary *) dic delegate:(id<NetWorkManagerDelegate>)delegate
{
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    [mgr POST:KRepostWeiboURI parameters:dic
//     success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         
//         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
//         {
//             
//             [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) ESendRequestTypeRepost];
//         }
//     }
//     failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [self.delegate receivedResponseFailed:error];
//     }];
    self.delegate = delegate;
    

    

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    [mgr POST:KSendRepostWeiboURL parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {

             
              [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) ESendRequestTypeRepost];
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];

}


- (void)getWeiboComment:(NSDictionary *)dic delegate: (id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;

    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:access_token forKey:@"access_token"];
    [params addEntriesFromDictionary:dic];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:KGetWeiboCommentURL parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {
             
             [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) EReceiveHomeWeiboComment];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];
    
}

- (void)postWeiboComment:(NSDictionary *)dic delegate:(id<NetWorkManagerDelegate>)delegate
{
    self.delegate = delegate;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    [mgr POST:KSendWeiboCommentURL parameters:dic
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(receivedResponseSuccess:type:)])
         {
             NSObject *object = [dic objectForKey:@"max_id"];
             if (object)
             {
                 [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) EReceiveHomeWeiboCommentRefresh];
             }
             else
                 [self.delegate receivedResponseSuccess:responseObject type:(SendRequestType) ESendRequestTypeComment];
        }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.delegate receivedResponseFailed:error];
     }];
}

@end
