//
//  DemoItem.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "DemoItem.h"

@implementation DemoItem
+ (DemoItem *)initWithTitle:(NSString *)title itemId:(NSString *)itemId {
    DemoItem *item = [[DemoItem alloc] init];
    item.title = title;
    item.itemId = itemId;
    
    return item;
}
- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object ? true : [self isEqual:object];//YES;
}

@end
