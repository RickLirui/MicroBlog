//
//  CommentViewController.h
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface CommentViewController : UIViewController

- (id)initWithWeiboCell:(WeiboModel *) weibo;

@end
