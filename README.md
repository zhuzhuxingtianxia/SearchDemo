# SearchDemo
一个用于搜索功能的textField的分类

### 实现类似web网页的下拉框效果
![image](https://github.com/zhuzhuxingtianxia/SearchDemo/blob/master/1.png)

![image](https://github.com/zhuzhuxingtianxia/SearchDemo/blob/master/2.png)

## 使用说明
  这个搜索小功能是对textField的一个扩展，所以我们首先站到UITextField+PopOver这个扩展类，然后把它添加到工程去。
<br>
  为了不影响本类的使用，在使用到搜索功能的文件中导入<#import "UITextField+PopOver.h">,哪个textField用到这个功能则可设置定义的属性或方法！

例 1：对文本进行搜索
        //需要传入搜索文本所在的数组dataSources
###
      [field popOverSource:self.dataSources index:^(NSInteger index) {
         //index值是选中的内容在dataSources中的索引
          NSLog(@"dataSources index == %ld",index);

      }];

例 2：对model对象搜索
    <br>需要传入搜索对象所在的数组dataSources以及根据哪个属性字段进行搜索
    <br> 如：一个Person类，有name和address属性，然后我们按照名字搜索
      // dataSources为Person的数组容器，根据属性name进行搜索
###    
      [field popOverSource:self.dataSources withKey:@"name" index:^(NSInteger index) {
          //index值是选中的内容在dataSources中的索引
          NSLog(@"dataSources index == %ld",index);

      }];
     

例 3：textField添加在了scrollView及其子类的容器中的处理
    <br>如果field是添加在table的cell上，则需要设置UITextField+PopOver的scrollView属性，用于展示下拉框的位置以及滑动时取消键盘和下拉框的响应。
###
    field.scrollView = self.tableView;
    /*
      设置下拉框的位置，默认是根据中心y点做分割，大于y下拉框在field上方显示
      下于y在下方显示。
      ZJPositionTop只在上方显示
      ZJPositionBottom只在下方显示
    */
    field.positionType = ZJPositionTop;
     [field popOverSource:self.dataSources  index:^(NSInteger index) {
      NSLog(@"dataSources index == %ld",index);

    }];
    /*
      //Person对象搜索
      [field popOverSource:self.dataSources withKey:@"name" index:^(NSInteger index) {
       NSLog(@"dataSources index == %ld",index);

     }];
    */
###
## 注意：
    textField不是添加在scrollView及其子类的容器中，但是textField所在的视图层次比较多时，则搜索下拉框不显示。


###

