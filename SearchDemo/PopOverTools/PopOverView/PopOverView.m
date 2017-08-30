//
//  PopOverView.m
//  BuldingMall
//
//  Created by Jion on 2017/8/3.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "PopOverView.h"

#define CellH 30
#define TopEdge 15

@interface PopOverView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
   __weak UIView *supViewOfPopOver;
    CGRect   initPoint;
}
@property(nonatomic,strong)UIImageView *popOverImg;
@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)UIControl   *bgControl;
//记录选中的索引
@property(nonatomic,strong)NSIndexPath  *indexPath;
@property(nonatomic,strong)NSString  *key;

@end
@implementation PopOverView
-(instancetype)initWithKey:(NSString*)key{
    self = [self init];
    if (self) {
        self.key = key;
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
       [self buildUI]; 
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.popOverImg];
    [self addSubview:self.collection];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.bounds.size.height == 0) {
            self.collection.frame = CGRectMake(5, TopEdge - 2, self.bounds.size.width, 0);
        }else{
            CGRect rect = self.frame;
            rect.size.height = CellH * _dataSoure.count + TopEdge > [[UIScreen mainScreen] bounds].size.height*0.5 ? [[UIScreen mainScreen] bounds].size.height*0.5 : CellH * _dataSoure.count + TopEdge;
            self.frame = rect;
            self.collection.frame = CGRectMake(5, TopEdge - 2, self.bounds.size.width - 10, rect.size.height - TopEdge);
        }

        self.popOverImg.frame = self.bounds;
        self.popOverImg.image = [self imageTransform:BackgroundImage];
        
    }];
    
}

-(void)setOwnerView:(UIView *)ownerView{
    _ownerView = ownerView;
    if (!supViewOfPopOver) {
        supViewOfPopOver = [self popOverSupView:_ownerView];
        [supViewOfPopOver addSubview:self.bgControl];
    }
    if (supViewOfPopOver) {
        [supViewOfPopOver addSubview:self];
    }
    
    CGPoint position;
    if ([supViewOfPopOver isKindOfClass:[UITableView class]]) {
        position = [_ownerView.superview convertPoint:_ownerView.center toView:supViewOfPopOver];
        
    }else{
        position = [_ownerView.superview convertPoint:_ownerView.center toView:[[UIApplication sharedApplication] keyWindow]];
    }
    
    if (CGRectIsNull(initPoint)) {
        initPoint = CGRectZero;
    }
    if (initPoint.size.height == 0) {
        self.frame = CGRectMake(position.x, position.y + _ownerView.bounds.size.height/2, 0, self.bounds.size.height);
        initPoint = CGRectMake(0, 0, 0, 1);
    }else{
        self.frame = CGRectMake(position.x -_ownerView.bounds.size.width/2, position.y + _ownerView.bounds.size.height/2, 0, self.bounds.size.height);
        initPoint = CGRectZero;
    }

    [UIView animateWithDuration:0.25 animations:^{
        if (self.frame.size.height == 0) {
            self.bgControl.frame = supViewOfPopOver.bounds;
            self.frame = CGRectMake(position.x - _ownerView.frame.size.width/2, position.y + _ownerView.frame.size.height/2, _ownerView.frame.size.width, 1);
        }else{
           self.bgControl.frame = CGRectZero;
            self.frame = CGRectMake(position.x, position.y + _ownerView.frame.size.height/2, 0, 0);
        }
        
    }];

}

-(void)recoverNormalGesture:(UITapGestureRecognizer*)sender{
    if ([self.delegate respondsToSelector:@selector(popOverView:didSelectItem:)]) {
        [self.delegate popOverView:self didSelectItem:nil];
    }
}

-(UIView*)popOverSupView:(UIView*)ownerView{
    UIView *view = ownerView.superview;
    if (!view) {
        NSLog(@"找不到父视图了，看看是怎么回事吧");
        return nil;
    }
    if (view.bounds.size.height > [UIScreen mainScreen].bounds.size.height/2) {
        
        return view;
    }else{
        return [self popOverSupView:view];
    }
}

#pragma mark --UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PopOverCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"popoverCell" forIndexPath:indexPath];
    id item = self.dataSoure[indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        cell.contentLabel.text = item;
    }else{
        cell.contentLabel.text = [item valueForKey:self.key];
    }
    
    if (indexPath == _indexPath) {
        cell.contentLabel.textColor = [UIColor redColor];
    }else{
       cell.contentLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(popOverView:didSelectItem:)]) {
        _indexPath = indexPath;
        [self.delegate popOverView:self didSelectItem:self.dataSoure[indexPath.row]];
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, CellH);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(80, 5);
}

#pragma mark -- ImageTransform
-(UIImage*)imageTransform:(NSString*)normalIamge{
    UIImage *image = [UIImage imageNamed:normalIamge];
    // 设置端盖的值
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    return newImage;
}

#pragma mark -- getter
-(UIImageView*)popOverImg{
    if (!_popOverImg) {
        _popOverImg = [[UIImageView alloc] init];
        _popOverImg.image = [UIImage imageNamed:BackgroundImage];
    }
    return _popOverImg;
}

-(UIControl*)bgControl{
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverNormalGesture:)];
        [_bgControl addGestureRecognizer:tap];
    }
    return _bgControl;
}

-(UICollectionView*)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor clearColor];
        [_collection registerClass:[PopOverCollectionCell class] forCellWithReuseIdentifier:@"popoverCell"];
    }
    return _collection;
}

@end


@interface PopOverCollectionCell ()

@end

@implementation PopOverCollectionCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.frame = self.bounds;
}

-(UILabel*)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

@end
