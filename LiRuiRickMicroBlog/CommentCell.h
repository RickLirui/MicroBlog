//
//  CommentCell.h
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

- (void) bindWithComment:(NSDictionary *) dic;

@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *detail;
@property (nonatomic,strong)NSDictionary *dic;

@end
