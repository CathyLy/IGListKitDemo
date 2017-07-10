//
//  NVMPopupUtil.h
//  NVMUIKit
//
//  Created by 顾超 on May/16/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

@import UIKit;
//#import "NVMUIKit.h"
//#import "NVMUIKit.h"

/**
 *  暂时用于管理:闪屏广告，天降红包，poplayer营销活动，新用户优惠活动
 */

typedef void (^NVMPopUpTaskUIBlock)(UIViewController *_Nonnull contentViewController);
typedef void (^NVMPopUpTaskUIUpateBlock)(NSTimeInterval time);
typedef void (^NVMPopUpTaskBlock)(void);
typedef void (^NVMPopUpQueueFinishBlock)(void);

NS_EXTENSION_UNAVAILABLE_IOS("")
@interface NVMPopUpTask : NSObject

@property (nonatomic, strong, nonnull) UIViewController *contentViewController;

///默认值0 表示一直展示，设置0<x<=10s 则展示x秒后自动消失
@property (nonatomic, assign) CGFloat displayTime;

///配置显示动画 默认为alpha值变化
@property (nonatomic, copy, nullable) NVMPopUpTaskUIBlock showAnimationBlock;

///配置消失动画
@property (nonatomic, copy, nullable) NVMPopUpTaskUIBlock hideAnimationBlock;

///每秒更新一次 仅针对自动消失的task
@property (nonatomic, copy, nullable) NVMPopUpTaskUIUpateBlock taskUpdateBlock;

/**
 *  消失动画完成后执行,只用于displayTime>0自动消失，手动结束任务请使用
 *  @code
 - (void)taskOver:(nonnull NVMPopUpTask *)task completionHandler:(nullable NVMPopUpTaskBlock)completionHandler;
 *  @end code
 */
@property (nonatomic, copy, nullable) NVMPopUpTaskBlock taskOverBlock;

///用于展示队列排序，后加入的高优先级任务会插入到低优先级任务前面，但如果该低优先级任务已经在展示状态，则不会插入
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, assign) BOOL isDisplaying;

///用于处理与其它window同时展示时的层级顺序
@property (nonatomic, assign) UIWindowLevel taskWindowLevel;

///禁用显示动画
@property (nonatomic, assign) BOOL disableShowAnimation;
///禁用消失动画
@property (nonatomic, assign) BOOL disableHideAnimation;

- (void)startTimer;
- (void)endTimer;

/**
 *  弹窗优先级统一管理
 */
+ (NSUInteger)newUserPromotionPriority;
+ (NSUInteger)splashPriority;
+ (NSUInteger)redEnvelopePriority;
+ (NSUInteger)marketPopPriority;

@end

NS_EXTENSION_UNAVAILABLE_IOS("")
@interface NVMPopUpWindow : UIWindow

@property (nonatomic, strong, nonnull) NSMutableArray<NVMPopUpTask *> *popUpTasks;

@end

NS_EXTENSION_UNAVAILABLE_IOS("")
@interface NVMPopupUtil: NSObject

@property (nonatomic, strong, readonly, nonnull) NVMPopUpWindow *popUpWindow;

+ (void)popUpTask:(nonnull NVMPopUpTask *)task;

///队列全部正常展示完毕的回调，不含进后台取消的情况
+ (void)setQueueFinishHandler:(nullable NVMPopUpQueueFinishBlock)completionHandler;

/**
 *  手动终止显示时调用
 */
+ (void)finishTaskWithCompletionHandler:(nullable NVMPopUpTaskBlock)completionHandler;

+ (void)clearAllPopUpTask;

+ (NSUInteger)currentQueueLength;

@end
