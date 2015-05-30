//
//  UserView.m
//  LiRickMicroBlog
//
//  Created by Rick on 12/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#import "Define.h"


@interface UserView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *weiboCount;
@property (nonatomic, strong) UILabel *followCount;
@property (nonatomic, strong) UILabel *fansCount;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *userDescription;
@property (nonatomic, strong) UserModel *user;



@end


@implementation UserView

- (id) init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor cyanColor];
        
        self.iconView = [[UIImageView alloc] init];
        self.iconView.backgroundColor = [UIColor cyanColor];
        self.iconView.layer.masksToBounds =YES;
        
        self.iconView.layer.cornerRadius =25;
        [self addSubview:self.iconView];
        
        self.weiboCount = [[UILabel alloc] init];
        self.weiboCount.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.weiboCount];
        
        self.followCount = [[UILabel alloc] init];
        self.followCount.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.followCount];
        
        self.fansCount = [[UILabel alloc] init];
        self.fansCount.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.fansCount];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.nameLabel];
        
        self.userDescription = [[UILabel alloc] init];
        self.userDescription.backgroundColor = [UIColor clearColor];
        [self addSubview:self.userDescription];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat width;
    width = [self.class calculateWidth:self.user.nickName];
    
    self.nameLabel.frame = CGRectMake( ([[UIScreen mainScreen] bounds].size.width - width)/2, 10, (width + 10), 20);

    self.iconView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 50)/2, 40, 50, 50);
    
    width = [self.class calculateWidth:self.user.descript];

    self.userDescription.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - width)/2, 100,(width + 20),20 );

    self.nameLabel.layer.cornerRadius =10.0;
    
    self.followCount.frame = CGRectMake(0, 130, ([[UIScreen mainScreen] bounds].size.width / 3), 30);
    self.fansCount.frame = CGRectMake( ([[UIScreen mainScreen] bounds].size.width / 3),130, ([[UIScreen mainScreen] bounds].size.width / 3), 30);
    self.weiboCount.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 3) * 2, 130, ([[UIScreen mainScreen] bounds].size.width / 3), 30);
    
    
}

- (void) bindWithUser:(UserModel *) user
{
    self.user = user;
    
    self.nameLabel.text = user.nickName;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.iconView sd_setImageWithURL:user.profileImageUrl];
    
    
    self.userDescription.text = user.descript;
    self.userDescription.textAlignment = NSTextAlignmentCenter;

    
    NSString *followString = @"Follow:";
    followString = [followString stringByAppendingString:[NSString stringWithFormat:@"%@",user.followCount]];
    self.followCount.text = followString;
    self.followCount.textAlignment = NSTextAlignmentCenter;

    NSString *fansString = @"Fans:";
    fansString = [fansString stringByAppendingString:[NSString stringWithFormat:@"%@",user.fansCount]];
    self.fansCount.text = fansString;
    self.fansCount.textAlignment = NSTextAlignmentCenter;

    
    NSString *weiboString = @"Weibo:";
    weiboString = [weiboString stringByAppendingString:[NSString stringWithFormat:@"%@",user.weiboCount]];
    self.weiboCount.text = weiboString;
    self.weiboCount.textAlignment = NSTextAlignmentCenter;

    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark 计算label高度
+ (CGFloat) calculateWidth:(NSString *) text
{
    CGFloat height;

    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
    
    height = [text boundingRectWithSize:CGSizeMake(([[UIScreen mainScreen] bounds].size.width), 20)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil].size.width;
    
    return height;
    
}

@end
