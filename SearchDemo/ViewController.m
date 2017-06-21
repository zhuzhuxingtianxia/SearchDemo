//
//  ViewController.m
//  SearchDemo
//
//  Created by Jion on 2017/6/20.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"搜索控件";
}

- (IBAction)logisticsSearch1:(id)sender {
    id vc1 = [[NSClassFromString(@"Search1Controller") alloc] init];
    
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (IBAction)logisticsSearch2:(id)sender {
    
    id vc2 = [[NSClassFromString(@"Search2Controller") alloc] init];
    
    [self.navigationController pushViewController:vc2 animated:YES];

}
- (IBAction)personSearch1:(id)sender {
    id vc3 = [[NSClassFromString(@"PersonSearch1Controller") alloc] init];
    
    [self.navigationController pushViewController:vc3 animated:YES];
    
}
- (IBAction)hidePopView:(id)sender {
    
    id vc4 = [[NSClassFromString(@"InputController") alloc] init];
    
    [self.navigationController pushViewController:vc4 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
