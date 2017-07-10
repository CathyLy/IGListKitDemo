//
//  DemoItem1.h
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface DemoItem1 : NSObject<IGListDiffable>

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

+ (DemoItem1 *)initWithTitle:(NSString *)title itemId:(NSString *)itemId;

@end
