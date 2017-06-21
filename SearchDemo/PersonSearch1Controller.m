//
//  PersonSearch1Controller.m
//  SearchDemo
//
//  Created by Jion on 2017/6/20.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "PersonSearch1Controller.h"
#import "UITextField+PopOver.h"
#import "Person.h"

@interface PersonSearch1Controller ()
@property (nonatomic, strong)NSArray *dataSources;

@end

@implementation PersonSearch1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 40, 30)];
    field.placeholder = @"请输入要搜索的人的名称";
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field popOverSource:self.dataSources withKey:@"name" index:^(NSInteger index) {
        NSLog(@"dataSources index == %ld",index);
        
    }];
    
    [self.view addSubview:field];
    
}

-(NSArray*)dataSources{
    if (!_dataSources) {
        Person *p1 = [[Person alloc] init];
        p1.name = @"王二小";
        p1.address = @"上海海滩";
        
        Person *p2 = [[Person alloc] init];
        p2.name = @"王老师";
        p2.address = @"浦东新区";
        
        Person *p3 = [[Person alloc] init];
        p3.name = @"罗老师";
        p3.address = @"上海松江";
        
        Person *p4 = [[Person alloc] init];
        p4.name = @"李先生";
        p4.address = @"上海普陀区";
        
        Person *p5 = [[Person alloc] init];
        p5.name = @"李小姐";
        p5.address = @"上海宝山区";
        
        Person *p6 = [[Person alloc] init];
        p6.name = @"李三娃";
        p6.address = @"上海徐汇区";
        
        Person *p7 = [[Person alloc] init];
        p7.name = @"王无力";
        p7.address = @"上海闵行区";
        
        Person *p8 = [[Person alloc] init];
        p8.name = @"李若涵";
        p8.address = @"上海黄浦区";
        
        Person *p9 = [[Person alloc] init];
        p9.name = @"刘若英";
        p9.address = @"上海黄浦区";
        
        Person *p10 = [[Person alloc] init];
        p10.name = @"李若彤";
        p10.address = @"上海嘉定区";
        
        _dataSources = @[p1,p2,p3,p4,p5,p6,p7,p8,p9,p10];
    }
    return _dataSources;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
