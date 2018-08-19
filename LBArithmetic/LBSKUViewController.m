//
//  LBSKUViewController.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/19.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "LBSKUViewController.h"

@interface LBSKUViewController ()<UICollectionViewDelegateFlowLayout>
{
    NSArray *_dataSource;
}

@end

@implementation LBSKUViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SKU算法";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    _dataSource = @[@{@"颜色":@[@"红色",@"黄色",@"蓝色",@"黒色",@"绿色"]},
                    @{@"尺码":@[@"S",@"L",@"XL",@"XXL",@"XXXL"]},
                    @{@"套餐":@[@"标配",@"套餐一",@"套餐二",@"套餐三"]},
                    @{@"容量":@[@"64G",@"128G",@"256G",@"512G",@"1T"]},
                    ];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"header" withReuseIdentifier:@"a"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_dataSource[section] allValues].firstObject count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cell.contentView addSubview:btn];
    btn.frame = cell.contentView.bounds;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor colorWithRed:249 green:249 blue:249 alpha:1.0]];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [btn titleColorForState:btn.state].CGColor;
    
    NSString *str = [_dataSource[indexPath.section] allValues].firstObject[indexPath.row];
    [btn setTitle:str  forState:UIControlStateNormal];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:@"header" withReuseIdentifier:@"a" forIndexPath:indexPath];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.frame = view.bounds;
    label.font = [UIFont boldSystemFontOfSize:22];
    
    NSString *str = [_dataSource[indexPath.section] allKeys].firstObject;
    label.text = str;
    return view;
}

- (void)btnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

+ (instancetype)vc {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/8, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    LBSKUViewController *vc = [[LBSKUViewController alloc] initWithCollectionViewLayout:layout];
    return vc;
}

@end
