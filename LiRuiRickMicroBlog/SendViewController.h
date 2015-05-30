//
//  SendViewController.h
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBHttpRequest.h"

@interface SendViewController : UIViewController<WBHttpRequestDelegate>

- (void) creatNavi;

@end
