//
//  InputController.m
//  SearchDemo
//
//  Created by Jion on 2017/6/20.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "InputController.h"
#import "Person.h"
#import "UITextField+PopOver.h"

@interface InputController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataSources;
@property(nonatomic,strong)UITableView  *tableView;
@end

@implementation InputController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBoark)];
//    
//    [self.tableView addGestureRecognizer:tap];
    
}

-(void)closeBoark{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width - 40, 40)];
        field.placeholder = @"物流搜索";
        field.tag = 100+indexPath.row;
        field.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:field];
        
    }
    UITextField *field = [cell.contentView viewWithTag:100+indexPath.row];
    field.scrollView = self.tableView;
    field.positionType = ZJPositionTop;
    [field popOverSource:self.dataSources  index:^(NSInteger index) {
        NSLog(@"dataSources index == %ld",index);
        
    }];
    /*
    [field popOverSource:self.dataSources withKey:@"name" index:^(NSInteger index) {
        NSLog(@"dataSources index == %ld",index);
        
    }];
    */
    // Configure the cell...
    return cell;
}

-(NSArray*)dataSources{
    if (!_dataSources) {
        /*
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
        */
        _dataSources = @[@"安能物流", @"安迅物流", @"巴伦支快递", @"北青小红帽", @"百世汇通", @"百福东方物流", @"邦送物流", @"宝凯物流", @"百千诚物流", @"博源恒通",
                         @"百成大达物流", @"百世快运", @"COE（东方快递）", @"城市100", @"传喜物流", @"城际速递", @"成都立即送", @"出口易", @"晟邦物流", @"DHL快递（中国件）", @"DHL（国际件）", @"DHL（德国件）", @"德邦", @"大田物流", @"东方快递", @"递四方",
                         @"大洋物流", @"店通快递", @"德创物流", @"东红物流", @"D速物流", @"东瀚物流", @"达方物流", @"EMS快递查询", @"EMS国际快递查询", @"俄顺达", @"FedEx快递查询", @"FedEx国际件", @"FedEx（美国）", @"凡客如风达", @"飞康达物流",
                         @"飞豹快递", @"飞狐快递", @"凡宇速递", @"颿达国际", @"飞远配送", @"飞鹰物流", @"风行天下", @"GATI快递", @"国通快递", @"国际邮件查询", @"港中能达物流", @"挂号信/国内邮件", @"共速达", @"广通速递（山东）", @"广东速腾物流", @"港快速递",
                         @"高铁速递", @"冠达快递", @"华宇物流", @"恒路物流", @"好来运快递", @"华夏龙物流", @"海航天天", @"河北建华", @"海盟速递", @"华企快运", @"昊盛物流", @"户通物流", @"华航快递", @"黄马甲快递", @"合众速递（UCS）", @"韩润物流", @"皇家物流",
                         @"伙伴物流", @"红马速递", @"汇文配送", @"i-parcel", @"佳吉物流", @"佳怡物流", @"加运美快递", @"急先达物流", @"京广速递快件", @"晋越快递", @"京东快递", @"捷特快递", @"久易快递", @"快捷快递", @"康力物流", @"跨越速运", @"快优达速递",
                         @"快淘快递", @"联邦快递（国内）", @"联昊通物流", @"龙邦速递", @"乐捷递", @"立即送", @"蓝弧快递", @"乐天速递", @"民航快递", @"美国快递", @"门对门", @"明亮物流", @"民邦速递", @"闽盛快递", @"麦力快递", @"美国韵达", @"能达速递", @"偌亚奥国际",
                         @"平安达腾飞", @"陪行物流", @"全峰快递", @"全一快递", @"全日通快递", @"全晨快递", @"秦邦快运", @"如风达快递", @"日昱物流", @"瑞丰速递", @"申通快递", @"顺丰速运", @"速尔快递", @"山东海红", @"盛辉物流", @"世运快递", @"盛丰物流", @"上大物流",
                         @"三态速递", @"赛澳递", @"申通E物流", @"圣安物流", @"山西红马甲", @"穗佳物流", @"沈阳佳惠尔", @"上海林道货运", @"十方通物流", @"山东广通速递", @"TNT快递", @"天天快递", @"天地华宇", @"通和天下", @"天纵物流", @"同舟行物流", @"腾达速递",
                         @"UPS快递查询", @"UPS国际快递", @"UC优速快递", @"USPS美国邮政", @"万象物流", @"微特派", @"万家物流", @"万博快递", @"希优特快递", @"新邦物流", @"信丰物流", @"新蛋物流", @"祥龙运通物流", @"西安城联速递", @"西安喜来快递", @"鑫世锐达",
                         @"鑫通宝物流", @"圆通速递", @"韵达快运", @"运通快递",@"邮政国内", @"邮政国际", @"远成物流", @"亚风速递", @"优速快递", @"亿顺航", @"越丰物流", @"源安达快递", @"原飞航物流", @"邮政EMS速递", @"银捷速递", @"一统飞鸿", @"宇鑫物流", @"易通达",
                         @"邮必佳", @"一柒物流", @"音素快运", @"亿领速运", @"煜嘉物流", @"英脉物流", @"云豹国际货运", @"云南中诚", @"中通快递", @"宅急送", @"中铁快运", @"中铁物流",@"中邮物流", @"中国东方(COE)", @"芝麻开门", @"中国邮政快递", @"郑州建华",
                         @"中速快件", @"中天万运", @"中睿速递", @"中外运速递", @"增益速递", @"郑州速捷", @"智通物流"];
         
    }
    
    return _dataSources;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
