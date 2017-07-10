//
//  DemoCell.m
//  ScrollViewDemo
//
//  Created by 刘婷 on 2017/7/10.
//  Copyright © 2017年 刘婷. All rights reserved.
//

#import "DemoCell.h"
#import "DemoItem.h"
#import "UIView+Extension.h"

@interface DemoCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) DemoItem *item;

@end


@implementation DemoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _contentLabel = [UILabel new];
    _contentLabel.frame = CGRectMake(10, 10, self.width - 20, 30);
    _contentLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.contentLabel];
    
    _textLabel = [UILabel new];
    _textLabel.frame = CGRectMake(10, _contentLabel.bottom, self.width - 20, 30);
    _textLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.textLabel];
    
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor orangeColor];
    separator.frame = CGRectMake(0, self.height - 2, self.width, 2);
    [self.contentView addSubview:separator];
}


- (void)updateWithObject:(NSObject *)object {
    if (self.item != object) {
        if ([object isKindOfClass:[DemoItem class]]) {
            self.item = (DemoItem *)object;
            self.textLabel.text = [NSString stringWithFormat:@"IGListKitDemoForObjectC %@", self.item.title];
            self.contentLabel.text = self.item.content;
        }
    }
}
@end
