//
//  HomeDataSource.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "HomeDataSource.h"
#import "DemoSectionController.h"
#import "DemoSectionController1.h"
#import "DemoItem.h"
#import "DemoItem1.h"

@interface HomeDataSource () <IGListAdapterDataSource>

@property (nonatomic, strong) IGListCollectionView *listView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSArray *items;

@end


@implementation HomeDataSource

- (void)updateDataSource:(NSArray *)items {
    _items = items;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.items;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    if ([object isKindOfClass:[DemoItem class]]) {
        return [[DemoSectionController alloc] init];
        
    } else if ([object isKindOfClass:[DemoItem1 class]]) {
        return [DemoSectionController1 new];
    } else {
        [DemoSectionController new];
    }
    
    return nil;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
