//
//  HeaderView.h
//  SearchDemo
//
//  Created by Jion on 2017/8/4.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView;
@protocol HeaderViewDelegate <NSObject>

-(void)headerView:(HeaderView*)headerView doSomething:(id)item;

@end

@interface HeaderView : UIView
@property(nonatomic,weak)id<HeaderViewDelegate> delegate;

@end
