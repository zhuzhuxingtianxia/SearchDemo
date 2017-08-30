//
//  PopOverView.h
//  BuldingMall
//
//  Created by Jion on 2017/8/3.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BackgroundImage @"popover@2x"

@class PopOverView;
@class PopOverCollectionCell;
@protocol PopOverViewDelegate <NSObject>

-(void)popOverView:(PopOverView*)popOverView didSelectItem:(id)item;

@end

@interface PopOverView : UIView
/*
 如果数据源数组是字典或model，则必须填写key值用于获取数据
 例如：@{@“key”:@"name"}
 */
-(instancetype)initWithKey:(NSString*)key;

//持有者,popOver的主人
@property(nonatomic,weak)UIView *ownerView;
//数据源
@property(nonatomic,strong)NSArray *dataSoure;
@property(nonatomic,weak)id<PopOverViewDelegate> delegate;

@end

@interface PopOverCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *contentLabel;
@end
