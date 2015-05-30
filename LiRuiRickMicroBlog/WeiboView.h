//
//  WeiboView.h
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface WeiboView : UIView
@property(nonatomic,assign) CGFloat height;


- (id)initWithWeibo:(WeiboModel *) weibo;

@end
