//
//  HeaderView.m
//  SearchDemo
//
//  Created by Jion on 2017/8/4.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "HeaderView.h"
#import "ZJMyButton.h"

@interface HeaderView ()<PopOverViewDelegate>
{
    ZJMyButton  *_selectBtn;
}
@property(nonatomic,strong)NSMutableArray *popOverArray;
@end
@implementation HeaderView

-(instancetype)init{
    self = [super init];
    if (self) {
        NSAssert(NO, @"禁止使用");
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
        [self createButtons];
    }
    return self;
}
#pragma mark -- Action
-(void)selectTypeAction:(ZJMyButton*)sender{
    [UIView animateWithDuration:0.25 animations:^{
        if (CGAffineTransformIsIdentity(sender.imageView.transform)) {
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            sender.imageView.transform = CGAffineTransformIdentity;
            
        }
        
    }];
    PopOverView *popOver = self.popOverArray[sender.tag];
    popOver.ownerView = sender;
    switch (sender.tag) {
        case 0:
        {
            popOver.dataSoure = @[@"小户型",@"一室户",@"二室户",@"三室户",@"四室户",@"别墅",@"其他"];
        }
            break;
        case 1:
        {
            popOver.dataSoure = @[@"现代简约",@"欧美风格",@"大众风格",@"地中海风情",@"古典美",@"日式",@"田园风情",@"其他",];
        }
            break;
        case 2:
        {
            popOver.dataSoure = @[@"2-5万",@"5-10万",@"10-20万",@"二十万以上"];
        }
            break;
            
        default:
            break;
    }
    
    _selectBtn = sender;
    
}

#pragma mark -- PopOverViewDelegate
-(void)popOverView:(PopOverView*)popOverView didSelectItem:(id)item{
    NSLog(@"点击 %@",item);
    if (item) {
        [(ZJMyButton*)popOverView.ownerView setTitle:[NSString stringWithFormat:@"%@  ",item] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(headerViewWithPopOverView:doSomething:)]) {
            [self.delegate headerViewWithPopOverView:popOverView doSomething:item];
        }
    }
    
    [self selectTypeAction:_selectBtn];
}

#pragma mark -- getter
-(void)createButtons{
    NSArray *titleArray = @[@"小户型  ",@"现代简约  ",@"2-5万  "];
    CGFloat widh = (self.frame.size.width - 12*2 - 2*10)/3;
    for (NSInteger j = 0; j < titleArray.count; j++) {
        ZJMyButton *sender = [ZJMyButton buttonWithType:UIButtonTypeSystem];
        sender.tag = j;
        sender.frame = CGRectMake(12 + j*(widh+10), 10, widh, 40);
        [sender setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [sender setTitle:titleArray[j] forState:UIControlStateNormal];
        [sender setImage:[[UIImage imageNamed:@"btn-_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:14];
        sender.layer.borderWidth = 1.0;
        sender.layer.borderColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0].CGColor;
        
        [sender addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sender];
        //设置popOver
        PopOverView *popOverView = [[PopOverView alloc] init];
        popOverView.tag = j;
        popOverView.delegate = self;
        if (!self.popOverArray) {
            self.popOverArray = [NSMutableArray arrayWithCapacity:3];
        }
        [self.popOverArray addObject:popOverView];
    }
}

@end


