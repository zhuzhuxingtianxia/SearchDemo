//
//  ZJMyButton.m
//  ConstructionCaptain
//
//  Created by Jion on 15/11/20.
//  Copyright © 2015年 Youjuke. All rights reserved.
//

#import "ZJMyButton.h"

@implementation ZJMyButton

//重新对同时有图片和文字的button进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX = self.bounds.size.width / 2 + self.titleLabel.frame.size.width/2;
    self.imageView.frame = CGRectMake(imageX, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.bounds.size.height);
    
    CGFloat titleX = self.bounds.size.width / 2 - self.titleLabel.frame.size.width/2;
    self.titleLabel.frame = CGRectMake(titleX, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.bounds.size.height);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
