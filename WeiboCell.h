//
//  WeiboCell.h
//  LiRuiRickMicroBlog
//
//  Created by Rick on 6/5/15.
//  Copyright (c) 2015年 LiRuiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "UserModel.h"



@protocol WeiboCellDelegate <NSObject>

@required

- (void) commentPressed:(WeiboModel *) weibo;
- (void) likePressed:(WeiboModel *) weibo;
- (void) repostPressed:(WeiboModel *) weibo;

@end
@interface WeiboCell : UITableViewCell

@property (nonatomic, weak) id<WeiboCellDelegate>delegate;

@property (nonatomic, assign) BOOL isInDetail;

- (void) bindWithWeibo:(WeiboModel *)weibo withDelegate: (id<WeiboCellDelegate>)delegate;
+ (CGFloat) calculateWeiboCellheight:(WeiboModel *) weibo;

+ (CGFloat) calculateTextHeight:(NSString *) text;

@end
