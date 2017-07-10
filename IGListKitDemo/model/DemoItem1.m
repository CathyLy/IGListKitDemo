//
//  DemoItem1.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "DemoItem1.h"

@implementation DemoItem1
+ (DemoItem1 *)initWithTitle:(NSString *)title itemId:(NSString *)itemId {
    DemoItem1 *item = [[DemoItem1 alloc] init];
    item.title = title;
    item.itemId = itemId;
    return item;
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object ? true : false;
}

@end
