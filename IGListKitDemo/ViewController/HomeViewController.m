//
//  HomeViewController.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/7.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "HomeViewController.h"
#import "NVMPopupUtil.h"
#import <IGListKit.h>
#import "DemoItem.h"
#import "DemoItem1.h"
#import "DemoSectionController.h"
#import "HomeDataSource.h"

@interface HomeViewController ()

@property (nonatomic, strong) IGListCollectionView *listView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) HomeDataSource *dataSource;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDataSource];
    [self layoutUI];
}

- (void)loadDataSource {
    self.dataSource = [HomeDataSource new];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        if (i == 0) {
            DemoItem *item = [DemoItem initWithTitle:@"item" itemId:[NSString stringWithFormat:@"%d",i + 10]];
            item.content = @"DemoItem";
            [tempArray addObject:item];
            
        } else {
            DemoItem1 *item = [DemoItem1 initWithTitle:@"item1" itemId:[NSString stringWithFormat:@"%d",i + 10]];
            item.content = @"DemoItem1";
            [tempArray addObject:item];
        }
    }
    _items = [NSArray arrayWithArray:tempArray];
    
    [self.dataSource updateDataSource:_items];
    
}

- (void)layoutUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.listView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.listView.frame = self.view.bounds;
    [self.view addSubview:self.listView];
    
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    IGListAdapter *adapter = [[IGListAdapter alloc] initWithUpdater:updater viewController:self workingRangeSize:0];
    adapter.collectionView = self.listView;
    adapter.dataSource = self.dataSource;
    //adapter.delegate = self;
    
    self.adapter = adapter;
}

@end
