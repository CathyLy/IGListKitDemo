//
//  DemoSectionController.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "DemoSectionController.h"
#import "DemoCell.h"
#import "DemoItem.h"
#import "ListViewController.h"

@interface DemoSectionController ()

@property (nonatomic, strong) NSObject *item;

@end

@implementation DemoSectionController
- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 80);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DemoCell *cell = [self.collectionContext dequeueReusableCellOfClass:[DemoCell class]
                                                   forSectionController:self
                                                                atIndex:index];
    
    [cell updateWithObject:self.item];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.item = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    DemoItem *item = (DemoItem *)self.item;
    ListViewController *listViewController = [[ListViewController alloc] init];
    [self.viewController.navigationController pushViewController:listViewController animated:YES];
    
}

@end
