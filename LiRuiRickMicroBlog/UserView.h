//
//  UserView.h
//  LiRickMicroBlog
//
//  Created by Rick on 12/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserView : UIView

- (void) bindWithUser:(UserModel *) user;
+ (CGFloat) calculateWidth:(NSString *) text;

@end
