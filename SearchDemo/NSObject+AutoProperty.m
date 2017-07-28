//
//  NSObject+AutoProperty.m
//  DictWithModel
//
//  Created by 贾翊玮 on 17/1/21.
//  Copyright © 2017年 贾翊玮. All rights reserved.
//

#import "NSObject+AutoProperty.h"
#import <objc/message.h>

@implementation NSObject (AutoProperty)

/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict{
    NSMutableString *proprety = [[NSMutableString alloc] init];
     NSMutableString *propretyFuzi = [[NSMutableString alloc] init];
    //遍历数组 生成声明属性的代码，例如 @property (nonatomic, copy) NSString str
    //打印出来后 command+c command+v
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str;
        NSString *str2;
        

        str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        str2 = [NSString stringWithFormat:@"model.%@ = [NSString stringWithFormat:@\"%%@\",[dic objectForKey:@\"%@\"]];",key,key];
        [proprety appendFormat:@"\n%@\n",str];
        
        [propretyFuzi appendFormat:@"\n%@\n",str2];
        
    }];
    NSLog(@"%@\n%@",proprety,propretyFuzi);
    
}

/**
 *  自动给属性赋值
 *
 *  @param dict JSON字典/模型字典
 */
+ (instancetype)setPropertyValuesWithDict:(NSDictionary *)dict
{
    //原理：利用runtime获取model的属性列表，然后从字典里面取出value给属性赋值
    
    // 创建实例对象
    id obj = [[self alloc] init];
    
    // 获取属性列表
    /**
     * class_copyIvarList(Class cls, unsigned int *outCount)  获取成员变量列表
     * class 获取那个类的属性
     * outCount 获取的属性总个数
     */
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    //遍历属性列表
    for (int i = 0; i < count; i ++) {
        Ivar aivar = ivarList[i];
        
        //获取属性名字（带下划线）
        NSString *_propertyName = [NSString stringWithUTF8String:ivar_getName(aivar)];
        
        //获取属性type
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(aivar)];
        
        //属性名字 不带下划线
        NSString *key = [_propertyName substringFromIndex:1];
        
        //通过属性名从字典里面取出value
        id  value = [dict objectForKey:key];
        
        /*二级model*/
        //当value时字典，并且属性是自定义的model，把字典（value）转换成model
        //当propertyType是自定义的model 那么此时 propertyType = @"@\"AddressModel\""，所以我们要截取字符串，把自定义的model名字取出来
        
        NSString *nsdictStr = @"@\"NSDictionary\"";
        if ([value isKindOfClass:[NSDictionary class] ] && ![propertyType isEqualToString:nsdictStr]) {
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            
            Class modelClass = NSClassFromString(propertyType);
            
            if (modelClass) {
                NSLog(@"propertyType == %@",propertyType);
                value = [modelClass setPropertyValuesWithDict:value];
            }
            
        }
        
        if (value) {
            [obj setValue:value forKey:key];
        }
        
        
    }
    
    return obj;
}
@end
