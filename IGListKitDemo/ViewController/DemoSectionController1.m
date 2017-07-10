//
//  DemoSectionController1.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "DemoSectionController1.h"
#import "DemoCell1.h"
#import "DemoItem1.h"
#import "ListViewController.h"

@interface DemoSectionController1 ()

@property (nonatomic, strong) NSObject *item;

@end


@implementation DemoSectionController1
- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 80);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    DemoCell1 *cell = [self.collectionContext dequeueReusableCellOfClass:[DemoCell1 class]
                                                   forSectionController:self
                                                                atIndex:index];
    
    [cell updateWithObject:self.item];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.item = object;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    //DemoItem *item = (DemoItem *)self.item;
    ListViewController *listViewController = [[ListViewController alloc] init];
    [self.viewController.navigationController pushViewController:listViewController animated:YES];
    
}
@end
