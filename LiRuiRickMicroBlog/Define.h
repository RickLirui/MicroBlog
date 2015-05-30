//
//  Static.h
//  LiRickMicroBlog
//
//  Created by Rick on 12/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#ifndef LiRickMicroBlog_Static_h
#define LiRickMicroBlog_Static_h

#define KAppKey @"3346377428"
#define KRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define KAppSecre @"5ca0c24af918bf52ec0840c8e2eea44c"

#define KGetUserURL @"https://api.weibo.com/2/users/show.json"
#define KGetWeiboURL @"https://api.weibo.com/2/statuses/home_timeline.json"
#define KSendWeiboTextURL @"https://api.weibo.com/2/statuses/update.json"
#define KSendWeiboPicURL @"https://upload.api.weibo.com/2/statuses/upload.json"
#define KSendRepostWeiboURL @"https://api.weibo.com/2/statuses/repost.json"
#define KSendWeiboCommentURL @"https://api.weibo.com/2/comments/create.json"
#define KGetUserWeiboURL @"https://api.weibo.com/2/statuses/user_timeline.json"
#define KGetWeiboCommentURL @"https://api.weibo.com/2/comments/show.json"

#define KNameFont [UIFont systemFontOfSize:15]
#define KTextFont [UIFont systemFontOfSize:16]

//#define KNaviColor [UIColor colorWithRed:((float)((30 & 0xFF0000) >> 16))/255.0 green:((float)((144  & 0xFF00) >> 8))/255.0 blue:((float)(255 & 0xFF))/255.0 alpha:1.0]//dodger blue
//#define KNaviColor [UIColor colorWithRed:((float)((51 & 0xFF0000) >> 16))/255.0 green:((float)((161  & 0xFF00) >> 8))/255.0 blue:((float)(201 & 0xFF))/255.0 alpha:1.0]//孔雀蓝
//#define KNaviColor [UIColor colorWithRed:((float)((0 & 0xFF0000) >> 16))/255.0 green:((float)((0  & 0xFF00) >> 8))/255.0 blue:((float)(0 & 0xFF))/255.0 alpha:1.0]
//#define KTextBackgroundColor [UIColor colorWithRed:((float)((0 & 0xFF0000) >> 16))/255.0 green:((float)((225  & 0xFF00) >> 8))/255.0 blue:((float)(225 & 0xFF))/255.0 alpha:1.0]


#define KNaviColor [UIColor colorWithRed:135/255.0 green:106/255.0 blue:235/255.0 alpha:1.0]

#define GAP 10

#endif
