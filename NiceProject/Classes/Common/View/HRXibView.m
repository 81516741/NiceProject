//
//  HRXibView.m
//  XibView
//
//  Created by ld on 17/3/8.
//  Copyright © 2017年 ld. All rights reserved.
//

#import "HRXibView.h"

@interface HRXibView ()
@property (nonatomic,weak) UIView * hr_xibView;
@end

@implementation HRXibView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIView * xibView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
    self.hr_xibView = xibView;
    [self addSubview:xibView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.hr_xibView.frame = self.bounds;
}

@end
