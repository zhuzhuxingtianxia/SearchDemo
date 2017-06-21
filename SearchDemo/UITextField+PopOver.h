//
//  UITextField+PopOver.h
//  本地搜索Demo
//
//  Created by Jion on 2017/6/16.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ZJPositionType) {
    ZJPositionAuto,
    ZJPositionTop,
    ZJPositionBottom,
};
@interface UITextField (PopOver)<UITableViewDelegate,UITableViewDataSource>
/*
 给scrollView赋值，
 添加在scrollView上时，滑动则把视图隐藏
 */
@property(nonatomic,weak)UIScrollView  *scrollView;
/*
 显示类型，下拉框位置
 默认自动显示，以中间位置为分界点
 */
@property(nonatomic,assign)ZJPositionType  positionType;

/*
 参数：
 字符串数据源
 block返回选中的对象在数据源中的索引值
 */
-(void)popOverSource:(NSArray<NSString *>*)dataArray index:(void (^)(NSInteger index))index;

/*
 参数：
 字符串数据源，
 key按照对象某个属性值搜索，
 block返回选中的对象在数据源中的索引值
 */

-(void)popOverSource:(NSArray*)dataArray withKey:(NSString*)key index:(void (^)(NSInteger index))index;



@end
