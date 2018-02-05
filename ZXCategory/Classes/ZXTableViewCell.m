//
//  ZXTableViewCell.m
//  AIDesign
//
//  Created by xinying on 2018/1/24.
//  Copyright © 2018年 habav. All rights reserved.
//

#import "ZXTableViewCell.h"

@implementation ZXTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _title =[[UILabel alloc] init];
        _title.font =[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_title];
        _title.translatesAutoresizingMaskIntoConstraints =NO;
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f] ,[NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
