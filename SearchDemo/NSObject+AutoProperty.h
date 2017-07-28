//
//  NSObject+AutoProperty.h
//  DictWithModel
//
//  Created by 贾翊玮 on 17/1/21.
//  Copyright © 2017年 贾翊玮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoProperty)
/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+ (void)printPropertyWithDict:(NSDictionary *)dict;

/**
 *  自动给属性赋值
 *
 *  @param dict JSON字典/模型字典
 */
+ (instancetype)setPropertyValuesWithDict:(NSDictionary *)dict;
@end
