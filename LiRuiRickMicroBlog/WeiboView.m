//
//  WeiboView.m
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "WeiboCell.h"

#import "Define.h"

@interface WeiboView()

@property(nonatomic,strong) WeiboModel *weibo;
//------------------------------------------------------------------------
@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *timeLabel;//时间
//------------------------------------------------------------------------
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UILabel *repostContent;
@property (nonatomic, strong) UIImageView *pictureView;
//------------------------------------------------------------------------

@end

@implementation WeiboView

- (id)initWithWeibo:(WeiboModel *) weibo
{
    if(self = [super init])
    {
        self.weibo = weibo;
        //------------------------------------------------------------------------
        self.iconView = [[UIImageView alloc] init];
        self.iconView.frame = CGRectMake(10, 10, 50, 50);
        self.iconView.layer.masksToBounds =YES;
        self.iconView.layer.cornerRadius =25;
        [self.iconView sd_setImageWithURL:self.weibo.profileImageUrl];
        [self addSubview:self.iconView];
        //------------------------------------------------------------------------
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.frame = CGRectMake(70, 40, 170, 20);
        NSMutableAttributedString *str =  [[NSMutableAttributedString alloc] initWithString: [self getTimeString:self.weibo.creatDate]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0,8)];
        self.timeLabel.attributedText = str;
        [self addSubview:self.timeLabel];
        //------------------------------------------------------------------------
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15]; //加粗方法
        self.nameLabel.layer.cornerRadius =10.0;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
        CGFloat width = [self.weibo.name boundingRectWithSize:CGSizeMake(295, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil].size.width;
        self.nameLabel.frame = CGRectMake(70, 10, (width + 10), 20);
        self.nameLabel.text = self.weibo.name;
        [self addSubview:self.nameLabel];
        //------------------------------------------------------------------------
        self.content = [[UILabel alloc] init];
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        self.content.numberOfLines = 0;
        CGFloat contentHeight = [WeiboCell calculateTextHeight:self.weibo.text];
        CGFloat aboveHeight = 70;
        self.content.frame = CGRectMake(70, aboveHeight, 295, contentHeight);
        self.content.text = weibo.text;
        [self addSubview:self.content];
        int flag = 0;
        //------------------------------------------------------------------------
        if(self.weibo.hasPicture)
        {
            self.pictureView = [[UIImageView alloc] init];
            self.pictureView.frame = CGRectMake(70, (aboveHeight + GAP + contentHeight), 150, 150);
            aboveHeight = aboveHeight + GAP + contentHeight;
            [self.pictureView sd_setImageWithURL:self.weibo.picUrl];
            [self addSubview:self.pictureView];
            flag = 1;
        }
        //------------------------------------------------------------------------
        if(self.weibo.hasRepost)
        {
            self.repostContent = [[UILabel alloc] init];
            self.repostContent.lineBreakMode = NSLineBreakByWordWrapping;
            self.repostContent.numberOfLines = 0;
            self.repostContent.backgroundColor = [UIColor cyanColor];
            [self.repostContent.layer setCornerRadius:10];
            CGFloat repostHeight =  [WeiboCell calculateTextHeight:self.weibo.repostWeiboText];
            self.repostContent.frame = CGRectMake(70, (aboveHeight + GAP + contentHeight), ([[UIScreen mainScreen] bounds].size.width - 80), repostHeight);
            self.repostContent.text = weibo.repostWeiboText;
            [self addSubview:self.repostContent];
        }
        self.height = [WeiboCell calculateWeiboCellheight:weibo] - 20;
    }
    return self;
}
#pragma mark 转换时间格式
- (NSString *) getTimeString : (NSString *) string
{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
}

@end
