//
//  WeiboCell.m
//  LiRickMicroBlog
//
//  Created by Rick on 6/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//


#import "WeiboCell.h"
#import "UIImageView+WebCache.h"


#import "Define.h"

@interface WeiboCell()


@property(nonatomic,strong) WeiboModel *weibo;
@property(nonatomic,assign)CGFloat height;
//------------------------------------------------------------------------
@property (nonatomic, strong) UIImageView *iconView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *timeLabel;//时间
//------------------------------------------------------------------------
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UILabel *repostContent;
@property (nonatomic, strong) UIImageView *pictureView;
//------------------------------------------------------------------------
@property(nonatomic,strong)UIButton *comment;
@property(nonatomic,strong)UIImageView *speace1;
@property(nonatomic,strong)UIButton *like;
@property(nonatomic,strong)UIImageView *speace2;
@property(nonatomic,strong)UIButton *repost;

@property(nonatomic,strong)UIImage *repostButtonImage;
@property(nonatomic,strong)UIImage *commentButtonImage;
@property(nonatomic,strong)UIImage *likeButtonImage;

@property(nonatomic,strong)UIImageView *repostButtonImageView;
@property(nonatomic,strong)UIImageView *commentButtonImageView;
@property(nonatomic,strong)UIImageView *likeButtonImageView;

@property(nonatomic,strong)UILabel *repostLabel;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UILabel *likeLabel;

//------------------------------------------------------------------------


@end

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {

        //------------------------------------------------------------------------
        self.iconView = [[UIImageView alloc] init];
        self.iconView.layer.masksToBounds =YES;
        self.iconView.layer.cornerRadius =25;
        [self addSubview:self.iconView];
        
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:self.timeLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15]; //加粗方法
        self.nameLabel.layer.cornerRadius =10.0;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.nameLabel];
        //------------------------------------------------------------------------
        
        self.content = [[UILabel alloc] init];
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        self.content.numberOfLines = 0;
        [self addSubview:self.content];
        
        self.pictureView = [[UIImageView alloc] init];
        [self addSubview:self.pictureView];
        
        self.repostContent = [[UILabel alloc] init];
        self.repostContent.lineBreakMode = NSLineBreakByWordWrapping;
        self.repostContent.numberOfLines = 0;
        self.repostContent.backgroundColor = [UIColor cyanColor];
        [self.repostContent.layer setCornerRadius:10];
        [self addSubview:self.repostContent];
            //------------------------------------------------------------------------
        self.comment = [[UIButton alloc] init];
        self.comment.backgroundColor = [UIColor cyanColor];
        [self.comment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.comment.layer.cornerRadius =10.0;
        self.comment.layer.borderWidth = 1.f;//边框宽度
        self.comment.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色
        [self addSubview:self.comment];

        
        self.like = [[UIButton alloc] init];
        self.like.backgroundColor = [UIColor cyanColor];
        [self.like setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.like addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.like.layer.cornerRadius =10.0;
        self.like.layer.borderWidth = 1.f;//边框宽度
        self.like.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色
        [self addSubview:self.like];
            

        
        self.repost = [[UIButton alloc] init];
        self.repost.backgroundColor = [UIColor cyanColor];
        [self.repost setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.repost.layer.cornerRadius =10.0;
        self.repost.layer.borderWidth = 1.f;//边框宽度
        self.repost.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色
        [self addSubview:self.repost];
        
        
        self.speace1 = [[UIImageView alloc] init];
        self.speace1.image = [UIImage imageNamed:@"space.png"];
        
        self.speace2 = [[UIImageView alloc] init];
        self.speace2.image = [UIImage imageNamed:@"space.png"];

        self.repostButtonImage = [[UIImage alloc] init];
        self.repostLabel = [[UILabel alloc] init];
        self.repostButtonImageView = [[UIImageView alloc] init];
        
        self.commentButtonImage = [[UIImage alloc] init];
        self.commentLabel = [[UILabel alloc] init];
        self.commentButtonImageView = [[UIImageView alloc] init];
        
        self.likeButtonImage = [[UIImage alloc] init];
        self.likeLabel = [[UILabel alloc] init];
        self.likeButtonImageView = [[UIImageView alloc] init];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    //------------------------------------------------------------------------
    self.iconView.frame = CGRectMake(GAP, GAP, 50, 50);
    if(self.weibo != nil)
    {
        CGFloat aboveHeight = GAP + 50 +GAP;

        
        NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
        
        CGFloat width = [self.weibo.name boundingRectWithSize:CGSizeMake(295, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size.width;
        
        self.nameLabel.frame = CGRectMake(GAP + 50 + GAP, GAP, (width + 10), 20);
    
        self.timeLabel.frame = CGRectMake(70, 40, 170, 20);
    //------------------------------------------------------------------------
        CGFloat contentHeight = [self.class calculateTextHeight:self.weibo.text];
        

        self.content.frame = CGRectMake(70, aboveHeight, ([[UIScreen mainScreen] bounds].size.width - 80), contentHeight);
        aboveHeight = contentHeight + aboveHeight + GAP;
        if(self.weibo.hasPicture)
        {
            self.pictureView.hidden = NO;
            self.pictureView.frame = CGRectMake(70, aboveHeight, 150, 150);
            aboveHeight =aboveHeight + 150 +GAP;
        }
        if(self.weibo.hasRepost)
        {
            self.repostContent.hidden = NO;
            CGFloat repostHeight =  [self.class calculateTextHeight:self.weibo.repostWeiboText];
            self.repostContent.frame = CGRectMake(70, aboveHeight, ([[UIScreen mainScreen] bounds].size.width - 80), repostHeight);
            aboveHeight = aboveHeight + repostHeight + GAP;
        }
    //------------------------------------------------------------------------
        self.comment.frame = CGRectMake(0, aboveHeight, ([[UIScreen mainScreen] bounds].size.width / 3) - 2, 20);

        self.like.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 3), aboveHeight, ([[UIScreen mainScreen] bounds].size.width / 3)-2, 20);
        self.repost.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 3) * 2, aboveHeight, ([[UIScreen mainScreen] bounds].size.width / 3)-2, 20);
        
        self.speace1.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 3) - 2, aboveHeight, 2, 20);
        self.speace2.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 3) * 2 - 2, aboveHeight, 2, 20);
    //------------------------------------------------------------------------
    }
}

- (void) bindWithWeibo:(WeiboModel *)weibo withDelegate: (id<WeiboCellDelegate>) controllerDelegate
{
    self.delegate = controllerDelegate;
    [self.iconView sd_setImageWithURL:weibo.profileImageUrl];

    self.weibo = weibo;
    self.nameLabel.text = self.weibo.name;
    
    
    [self setTime:(NSString *)self.weibo.creatDate];
    //------------------------------------------------------------------------
    self.content.text = self.weibo.text;
    
    if(self.weibo.hasPicture)
    {
        [self.pictureView sd_setImageWithURL:self.weibo.picUrl];
    }
    if(self.weibo.hasRepost)
    {
        
        self.repostContent.text = self.weibo.repostWeiboText;
    }
    //------------------------------------------------------------------------
    self.repostButtonImage = [UIImage imageNamed:@"repost.png"];
    self.repostButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2) / 2 - 25,0,20,20)];
    [self.repostButtonImageView setImage:self.repostButtonImage];
    self.repostLabel = [[UILabel alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2)/2, 0, 30, 20)];
    NSString *stringInt = [NSString stringWithFormat:@"%d",weibo.repostsCount];
    NSString *newString = [NSString stringWithFormat:@"%@",stringInt];
    [self.repostLabel setText:newString];
    [self.repost addSubview:self.repostButtonImageView];
    [self.repost addSubview:self.repostLabel];
    [self.repost addTarget:self action:@selector(repostPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentButtonImage = [UIImage imageNamed:@"comment.png"];
    self.commentButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2) / 2 - 25,0,20,20)];
    [self.commentButtonImageView setImage:self.commentButtonImage];
    self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2)/2, 0, 30, 20)];
    stringInt = [NSString stringWithFormat:@"%d",weibo.commentsCount];
    newString = [NSString stringWithFormat:@"%@",stringInt];
    [self.commentLabel setText:newString];
    [self.comment addSubview:self.commentButtonImageView];
    [self.comment addSubview:self.commentLabel];
    [self.comment addTarget:self action:@selector(commentPressed) forControlEvents:UIControlEventTouchUpInside];

    
    self.likeButtonImage = [UIImage imageNamed:@"like.png"];
    self.likeButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2) / 2 - 25,0,20,20)];
    [self.likeButtonImageView setImage:self.likeButtonImage];
    self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake((([[UIScreen mainScreen] bounds].size.width / 3) - 2)/2, 0, 30, 20)];
    stringInt = [NSString stringWithFormat:@"%d",weibo.likesCount];
    newString = [NSString stringWithFormat:@"%@",stringInt];
    [self.likeLabel setText:newString];
    [self.like addSubview:self.likeButtonImageView];
    [self.like addSubview:self.likeLabel];
    [self.like addTarget:self action:@selector(likePressed) forControlEvents:UIControlEventTouchUpInside];
    //------------------------------------------------------------------------


    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//
- (void) prepareForReuse
{

    [super prepareForReuse];
    //------------------------------------------------------------------------
    self.nameLabel.text = nil;
    self.timeLabel.text = nil;
    self.iconView.image = nil;

    //------------------------------------------------------------------------
    self.content.text = nil;
    if(self.weibo.hasPicture)
    {
        self.pictureView.hidden = YES;
        self.pictureView.frame = CGRectZero;
        self.pictureView.image = nil;
    }
    if(self.weibo.hasRepost)
    {
        self.repostContent.hidden = YES;
        self.repostContent.frame = CGRectZero;
        self.repostContent.text = nil;
    }
    //------------------------------------------------------------------------
    [self.repost setTitle:nil forState:UIControlStateNormal];
    [self.like setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
    [self.comment setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
    //------------------------------------------------------------------------
    self.repostButtonImageView.image = nil;
    self.repostButtonImage = nil;
    self.repostLabel.text = nil;
    
    self.commentButtonImageView.image = nil;
    self.commentButtonImage = nil;
    self.commentLabel.text = nil;
    
    self.likeButtonImageView.image = nil;
    self.likeButtonImage = nil;
    self.likeLabel.text = nil;
    self.iconView.image = nil;

}



- (void) setTime:(NSString *) string
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:now];
    long day = [comps day];
    long hour = [comps hour];
    long min = [comps minute];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSDateComponents *tag = [[NSDateComponents alloc] init];
    tag = [calendar components:unitFlags fromDate:inputDate];
    long dayTag = [tag day];
    long hourTag = [tag hour];
    long minTag = [tag minute];
    
    NSString *str = [[NSString alloc] init];
    if(   (min - minTag) <=2 && hour == hourTag && day == dayTag )
    {
        str = @"Just now";
        NSMutableAttributedString *strText = [[NSMutableAttributedString alloc] initWithString:str];
        [strText addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0,8)];
        self.timeLabel.attributedText = strText;
    }
    else if(day > dayTag)
    {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"MMM-dd HH:mm:ss"];
        str = [outputFormatter stringFromDate:inputDate];
        NSMutableAttributedString *strText = [[NSMutableAttributedString alloc] initWithString:str];
        [strText addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0,15)];
        self.timeLabel.attributedText = strText;
    }
    else
    {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        str = [outputFormatter stringFromDate:inputDate];
        NSMutableAttributedString *strText = [[NSMutableAttributedString alloc] initWithString:str];
        [strText addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(0,8)];
        self.timeLabel.attributedText = strText;
    }

}
+ (CGFloat) calculateTextHeight:(NSString *) text
{
    CGFloat height;


    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
    
    height = [text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 140, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil].size.height;

    return height ;
    
}

+ (CGFloat) calculateWeiboCellheight:(WeiboModel *) weibo //isDetail:(BOOL)isDetail
{
    CGFloat height = GAP + 50 + GAP;

    CGFloat contentHeight = [self.class calculateTextHeight:weibo.text];

    height = height  + contentHeight + GAP;
    if(weibo.hasPicture)
    {
        height = height + 150 + GAP;
    }
    if(weibo.hasRepost)
    {
        CGFloat repostHeight =  [self.class calculateTextHeight:weibo.repostWeiboText];
        height = height +repostHeight + GAP;
    }
    height =height + 20;
    return height + 2;
    

}


- (void)commentPressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(commentPressed:)])
    {
        [self.delegate commentPressed:self.weibo];
    }
}

- (void)likePressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(likePressed:)])
    {
        [self.delegate likePressed:self.weibo];
    }
}

- (void)repostPressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(repostPressed:)])
    {
        [self.delegate repostPressed:self.weibo];
    }
}
@end
