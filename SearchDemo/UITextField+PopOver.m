//
//  UITextField+PopOver.m
//  本地搜索Demo
//
//  Created by Jion on 2017/6/16.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "UITextField+PopOver.h"
#import <objc/runtime.h>

#define CellH  44
#define NavH   64

static void * ZJScrollViewOffsetContext = &ZJScrollViewOffsetContext;

@interface UITextField (_PopOver)
@property(nonatomic,readwrite,strong)UITableView  *popList;

@property(nonatomic,readwrite,strong)UIImageView  *bgView;

@property(nonatomic,readwrite,strong)NSArray  *dataArray;

@property(nonatomic,readwrite,strong)NSArray  *changeArray;

@property(nonatomic,readwrite,strong)void (^oldIndex)(NSInteger index);

@property(nonatomic,readwrite,assign)CGRect  rectXY;

@property(nonatomic,readwrite,strong)NSString  *keyString;

@end

@implementation UITextField (_PopOver)

-(void)setPopList:(UITableView *)popList{
    
    objc_setAssociatedObject(self, @selector(popList), popList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITableView*)popList{
    return objc_getAssociatedObject(self, @selector(popList));
}

-(void)setBgView:(UIImageView *)bgView{
    objc_setAssociatedObject(self, @selector(bgView), bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView*)bgView{
    return objc_getAssociatedObject(self, @selector(bgView));
}

-(void)setDataArray:(NSArray *)dataArray{
    objc_setAssociatedObject(self, @selector(dataArray), dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSArray*)dataArray{
    
    return objc_getAssociatedObject(self, @selector(dataArray));
}

-(void)setChangeArray:(NSArray *)changeArray{
    objc_setAssociatedObject(self, @selector(changeArray), changeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray*)changeArray{
    return objc_getAssociatedObject(self, @selector(changeArray));
}

-(void)setOldIndex:(void (^)(NSInteger))oldIndex{
    objc_setAssociatedObject(self, @selector(oldIndex), oldIndex, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(NSInteger index))oldIndex{
    
    return objc_getAssociatedObject(self, @selector(oldIndex));
}

-(void)setRectXY:(CGRect)rectXY{
    
    objc_setAssociatedObject(self, @selector(rectXY), NSStringFromCGRect(rectXY), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(CGRect)rectXY{
    
    return CGRectFromString(objc_getAssociatedObject(self, @selector(rectXY)));
}

-(void)setKeyString:(NSString *)keyString{
    objc_setAssociatedObject(self, @selector(keyString), keyString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)keyString{
    
    return objc_getAssociatedObject(self, @selector(keyString));
}

@end


@implementation UITextField (PopOver)

-(void)setPositionType:(ZJPositionType)positionType{
    
    objc_setAssociatedObject(self, @selector(positionType), [NSNumber numberWithInteger:positionType], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ZJPositionType)positionType{
    return [objc_getAssociatedObject(self, @selector(positionType)) integerValue];
}

-(void)setScrollView:(UIScrollView *)scrollView{
    NSArray *gesArray = scrollView.gestureRecognizers;
    if (gesArray.count>2) {
        NSAssert(NO, @"警告：scrollView add other gestureRecognizer is no event of the popover's table cell");
    }
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:ZJScrollViewOffsetContext];
    
    objc_setAssociatedObject(self, @selector(scrollView), scrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIScrollView*)scrollView{
    
    return objc_getAssociatedObject(self, @selector(scrollView));
}

#pragma mark - NSKeyValueObserving
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == ZJScrollViewOffsetContext) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            
            @try {
                //滑动隐藏键盘
                [self endEditing:YES];
                if (self.popList.frame.size.height>0) {
                    
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    
                    CGRect rect = [self.superview convertRect:self.frame toView:window];
                    self.rectXY = rect;
                    
                    self.bgView.frame = CGRectMake(self.rectXY.origin.x, self.rectXY.origin.y, CGRectGetWidth(self.frame), 0);
                    self.popList.frame = self.bgView.frame;
                    [self.popList reloadData];
                    
                }
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
}


#pragma MARK --- setting source
-(void)popOverSource:(NSArray*)dataArray index:(void (^)(NSInteger index))index{
    
    self.dataArray = [dataArray copy];
    self.oldIndex = index;
    [self buildPopList];
    
    //添加输入改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputChange:) name:UITextFieldTextDidChangeNotification object:self];
    
}

-(void)popOverSource:(NSArray *)dataArray withKey:(NSString *)key index:(void (^)(NSInteger))index{
    if ((!key) ||key.length==0) {
        
        return;
    }
    
    self.dataArray = [dataArray copy];
    self.keyString = [key copy];
    self.oldIndex = index;
    [self buildPopList];
    
    //添加输入改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputObjcChange:) name:UITextFieldTextDidChangeNotification object:self];
}


-(void)buildPopList{
    if (!self.bgView) {
        self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0)];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bgView.userInteractionEnabled = YES;
        self.bgView.clipsToBounds = NO;
        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.bgView.layer.shadowOpacity = 0.8f;
        self.bgView.layer.shadowRadius = 4.f;
        self.bgView.layer.shadowOffset = CGSizeMake(0,3);
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    if (!self.popList) {
        self.popList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.popList.dataSource = self;
        self.popList.delegate = self;
        self.popList.translatesAutoresizingMaskIntoConstraints = NO;
        self.popList.backgroundColor = [UIColor whiteColor];
        self.popList.rowHeight = CellH;
    }
    
    [self.bgView addSubview:self.popList];
    
}

-(void)inputChange:(NSNotification*)notification{
    if (notification.name == UITextFieldTextDidChangeNotification && notification.object == self) {

        if (self.text.length ==0) {
            self.bgView.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0);
            self.popList.frame = self.bgView.bounds;
            [self.popList reloadData];
            
            return;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF LIKE '*%@*'",[self replacingCharacter:self.text]]];
        NSArray *array = [self.dataArray filteredArrayUsingPredicate:predicate];
        
       array = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
           NSComparisonResult result = NSOrderedSame;
           
           NSRange range1 = [obj1 rangeOfString:self.text];
           NSRange range2 = [obj2 rangeOfString:self.text];
           if (range1.location < range2.location) {
               result = NSOrderedAscending;
           }else if(range1.location > range2.location){
               result = NSOrderedDescending;
           }
           
           return result;
        }];
        
        if (array) {
            //调整视图位置
            [self changeInputSource:array];
        }
        
    }
    
}

-(void)inputObjcChange:(NSNotification*)notification{
    if (notification.name == UITextFieldTextDidChangeNotification) {
        
        if (self.text.length ==0) {
            self.bgView.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0);
            self.popList.frame = self.bgView.bounds;
            [self.popList reloadData];
            
            return;
        }
        NSString *preString = [NSString stringWithFormat:@"%@ CONTAINS '%@'", self.keyString,[self replacingCharacter:self.text]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:preString];
        NSArray *array = [self.dataArray filteredArrayUsingPredicate:predicate];
        
        if (array) {
            //调整视图位置
            [self changeInputSource:array];
        }
        
    }
}

-(void)changeInputSource:(NSArray*)changeArray{
    
    if (self.scrollView) {
        [self.scrollView addSubview:self.bgView];
        
    }else{
        [self.superview addSubview:self.bgView];
        
    }
    
    if (CGRectIsEmpty(self.rectXY)) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGRect rect = [self.superview convertRect:self.frame toView:window];
        
        self.rectXY = rect;
        
    }
    
    switch (self.positionType) {
        case ZJPositionAuto:
        {
            if (self.rectXY.origin.y > [UIScreen mainScreen].bounds.size.height/2 - NavH/2) {
                
                
                CGFloat heigt = CellH*changeArray.count>self.rectXY.origin.y-NavH ?self.rectXY.origin.y-NavH:CellH*changeArray.count;
                CGFloat listY = 0;
                if (self.scrollView) {
                    listY = self.rectXY.origin.y - heigt-NavH;
                }else{
                    listY = self.rectXY.origin.y - heigt;
                }
                
                
                if (CellH*changeArray.count > heigt) {
                    self.popList.scrollEnabled = YES;
                }else{
                    self.popList.scrollEnabled = NO;
                }
                
                self.bgView.frame = CGRectMake(self.rectXY.origin.x,listY, CGRectGetWidth(self.frame), heigt);
                self.bgView.layer.shadowOffset = CGSizeMake(0,-3);
                if (self.keyString) {
                    //按照key进行排序
                    NSSortDescriptor *keyName = [NSSortDescriptor sortDescriptorWithKey:self.keyString ascending:NO];
                    changeArray = [changeArray sortedArrayUsingDescriptors:@[keyName]];
                }else{
                    NSEnumerator *enumer = [changeArray reverseObjectEnumerator];
                    changeArray = [enumer allObjects];
                    
                }
                
                
            }else{
                if (self.keyString) {
                    //按照key进行排序
                    NSSortDescriptor *keyName = [NSSortDescriptor sortDescriptorWithKey:self.keyString ascending:YES];
                    changeArray = [changeArray sortedArrayUsingDescriptors:@[keyName]];
                }
                
                CGFloat listY = 0;
                if (self.scrollView) {
                    listY = self.rectXY.origin.y + CGRectGetHeight(self.frame)-NavH;
                }else{
                    listY = self.rectXY.origin.y + CGRectGetHeight(self.frame);
                }
                
                CGFloat heigt = 0;
                if (self.isEditing) {
                    heigt =  [UIScreen mainScreen].bounds.size.height - listY - 280;
                }else{
                    heigt =  [UIScreen mainScreen].bounds.size.height - listY;
                }
                if (self.scrollView){
                    heigt = CellH*changeArray.count > heigt - NavH? heigt - NavH:CellH*changeArray.count;
                }else{
                    heigt = CellH*changeArray.count > heigt? heigt:CellH*changeArray.count;
                }
                
                
                if (CellH*changeArray.count > heigt) {
                    self.popList.scrollEnabled = YES;
                }else{
                    self.popList.scrollEnabled = NO;
                }
                
                self.bgView.frame = CGRectMake(self.rectXY.origin.x,listY, CGRectGetWidth(self.frame), heigt);
            }
            
            self.changeArray = changeArray;
            [self.popList reloadData];
            
            if (self.changeArray.count>=1 && self.rectXY.origin.y > [UIScreen mainScreen].bounds.size.height/2 - NavH/2) {
                //滑动到底部
                [self.popList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.changeArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            self.popList.frame = self.bgView.bounds;
 
        }
            break;
        case ZJPositionTop:
        {
            CGFloat heigt = CellH*changeArray.count>self.rectXY.origin.y-NavH ?self.rectXY.origin.y-NavH:CellH*changeArray.count;
            CGFloat listY = 0;
            if (self.scrollView) {
                listY = self.rectXY.origin.y - heigt-NavH;
            }else{
                listY = self.rectXY.origin.y - heigt;
            }
            
            
            if (CellH*changeArray.count > heigt) {
                self.popList.scrollEnabled = YES;
            }else{
                self.popList.scrollEnabled = NO;
            }
            
            self.bgView.frame = CGRectMake(self.rectXY.origin.x,listY, CGRectGetWidth(self.frame), heigt);
            self.bgView.layer.shadowOffset = CGSizeMake(0,-3);
            if (self.keyString) {
                //按照key进行排序
                NSSortDescriptor *keyName = [NSSortDescriptor sortDescriptorWithKey:self.keyString ascending:NO];
                changeArray = [changeArray sortedArrayUsingDescriptors:@[keyName]];
            }else{
                NSEnumerator *enumer = [changeArray reverseObjectEnumerator];
                changeArray = [enumer allObjects];
                
            }
            
            self.changeArray = changeArray;
            [self.popList reloadData];
            if (self.changeArray.count>=1) {
                //滑动到底部
                [self.popList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.changeArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            self.popList.frame = self.bgView.bounds;

        }
            break;
        case ZJPositionBottom:
        {
            if (self.keyString) {
                //按照key进行排序
                NSSortDescriptor *keyName = [NSSortDescriptor sortDescriptorWithKey:self.keyString ascending:YES];
                changeArray = [changeArray sortedArrayUsingDescriptors:@[keyName]];
            }
            
            CGFloat listY = 0;
            if (self.scrollView) {
                listY = self.rectXY.origin.y + CGRectGetHeight(self.frame)-NavH;
            }else{
                listY = self.rectXY.origin.y + CGRectGetHeight(self.frame);
            }
            
            CGFloat heigt = 0;
            if (self.isEditing) {
                heigt =  [UIScreen mainScreen].bounds.size.height - listY - 280;
            }else{
                heigt =  [UIScreen mainScreen].bounds.size.height - listY;
            }
            if (self.scrollView){
                heigt = CellH*changeArray.count > heigt - NavH? heigt - NavH:CellH*changeArray.count;
            }else{
                heigt = CellH*changeArray.count > heigt? heigt:CellH*changeArray.count;
            }
            
            
            if (CellH*changeArray.count > heigt) {
                self.popList.scrollEnabled = YES;
            }else{
                self.popList.scrollEnabled = NO;
            }
            
            self.bgView.frame = CGRectMake(self.rectXY.origin.x,listY, CGRectGetWidth(self.frame), heigt);
            self.changeArray = changeArray;
            [self.popList reloadData];
            self.popList.frame = self.bgView.bounds;
            
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:ZJScrollViewOffsetContext];
}


#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.changeArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popOverCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popOverCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    id obj = self.changeArray[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.attributedText = [self attributedWithString:obj];
    }else{
       NSString *string = [(NSObject*)obj valueForKey:self.keyString];
        
        cell.textLabel.attributedText = [self attributedWithString:string];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id onj  = self.changeArray[indexPath.row];
    if ([onj isKindOfClass:[NSString class]]) {
        self.text = onj;
    }else{
        NSString *string = [(NSObject*)onj valueForKey:self.keyString];
        self.text = string;
    }
    
    [self endEditing:YES];
    if (self.oldIndex) {
        NSInteger oldIndex = [self.dataArray indexOfObject:onj];
        self.oldIndex(oldIndex);
        
        [self hidePopOver];
    }
    
}

-(void)hidePopOver{
    switch (self.positionType) {
        case ZJPositionAuto:
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (self.rectXY.origin.y > [UIScreen mainScreen].bounds.size.height/2 - NavH/2){
                    CGFloat listY = 0;
                    if (self.scrollView){
                        listY = self.rectXY.origin.y - NavH;
                    }else{
                        listY = self.rectXY.origin.y;
                    }
                    
                    self.bgView.frame = CGRectMake(self.rectXY.origin.x, listY, CGRectGetWidth(self.frame), 0);
                    
                }else{
                    CGFloat listY = 0;
                    if (self.scrollView) {
                        listY = self.rectXY.origin.y + CGRectGetHeight(self.frame)-NavH;
                    }else{
                        listY = self.rectXY.origin.y + CGRectGetHeight(self.frame);
                    }
                    self.bgView.frame = CGRectMake(self.rectXY.origin.x, listY, CGRectGetWidth(self.frame), 0);
                }
                self.popList.frame = self.bgView.bounds;
                [self.popList reloadData];
            }];
 
        }
            break;
        case ZJPositionTop:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat listY = 0;
                if (self.scrollView){
                    listY = self.rectXY.origin.y - NavH;
                }else{
                    listY = self.rectXY.origin.y;
                }
                
                self.bgView.frame = CGRectMake(self.rectXY.origin.x, listY, CGRectGetWidth(self.frame), 0);
                self.popList.frame = self.bgView.bounds;
                [self.popList reloadData];
            }];
 
        }
            break;
        case ZJPositionBottom:
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat listY = 0;
                if (self.scrollView) {
                    listY = self.rectXY.origin.y + CGRectGetHeight(self.frame)-NavH;
                }else{
                    listY = self.rectXY.origin.y + CGRectGetHeight(self.frame);
                }
                self.bgView.frame = CGRectMake(self.rectXY.origin.x, listY, CGRectGetWidth(self.frame), 0);
                self.popList.frame = self.bgView.bounds;
                [self.popList reloadData];
            }];
 
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -- 
-(NSMutableAttributedString*)attributedWithString:(NSString*)string {
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:self.text];
    
    if (range.location != NSNotFound) {
        [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    }
    
    return attributed;
    
}

-(NSString*)replacingCharacter:(NSString*)string{
    //去除特殊字符串，这里只去除了括号
    /*
     NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
     NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
     */
    string = [string stringByReplacingOccurrencesOfString:@"（" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"）" withString:@""];
    return string;
}

@end
