//
//  HomeDataSource.h
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListKit.h>

@interface HomeDataSource : NSObject<IGListAdapterDataSource>

- (void)updateDataSource:(NSArray *)items;

@end
