//
//  CommentCell.m
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "Define.h"
#import "WeiboCell.h"

@interface CommentCell ()



@end

@implementation CommentCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.image = [[UIImageView alloc] init];
        self.image.layer.masksToBounds =YES;
        self.image.layer.cornerRadius =15;
        [self addSubview:self.image];
        
        self.name = [[UILabel alloc] init];
        [self addSubview:self.name];
        
        self.detail = [[UILabel alloc] init];
        self.detail.font = [UIFont fontWithName:@"Helvetica" size:11];

        [self addSubview:self.detail];
    }
    return self;
}

- (void) bindWithComment:(NSDictionary *) dic
{
    self.dic = dic;
    NSDictionary *commentUser = dic[@"user"];
    
    NSString *flag = dic[@"text"];
    self.detail.text = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];
    
    flag = commentUser[@"screen_name"];
    self.name.text = [NSString stringWithCString:[flag UTF8String] encoding:NSUTF8StringEncoding];
    
    NSURL *profileImageUrl =[NSURL URLWithString:(commentUser[@"avatar_large"])];
    [self.image sd_setImageWithURL:profileImageUrl];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.image.frame = CGRectMake(GAP/2, GAP/2, 30, 30);
    NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
    
    CGFloat width = [self.name.text boundingRectWithSize:CGSizeMake(325, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil].size.width;
    self.name.frame = CGRectMake(45, GAP/2, width + 10, 15);
    
    width = [self.detail.text boundingRectWithSize:CGSizeMake(325, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil].size.width;
    self.detail.frame = CGRectMake(45, 25, width, 10);
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.image.image = nil;
    self.name.text = nil;
    self.detail.text = nil;
}


@end
