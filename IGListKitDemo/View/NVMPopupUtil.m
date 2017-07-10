//
//  NVMPopupUtil.m
//  NVMUIKit
//
//  Created by 顾超 on May/16/16.
//  Copyright © 2016 Rajax Network Technology Co., Ltd. All rights reserved.
//

#import "NVMPopupUtil.h"
//#import "NVMUIKit.h"
//#import "NVMUIKit.h"
#import <objc/runtime.h>

#define SystemVersion [UIDevice currentDevice].systemVersion.floatValue
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

UIWindowLevel NVMWindowLevelStatusBar() { return UIWindowLevelStatusBar; }

@implementation NVMPopUpTask {
  NSTimer *_taskTimer;
  NSTimeInterval _timerCountDown;
}

- (NVMPopUpTaskUIBlock)showAnimationBlock {
  if (!_showAnimationBlock) {
    _showAnimationBlock = ^(UIViewController *_Nonnull contentViewController) {
      contentViewController.view.alpha = 1.f;
    };
  }
  return _showAnimationBlock;
}

- (NVMPopUpTaskUIBlock)hideAnimationBlock {
  if (!_hideAnimationBlock) {
    _hideAnimationBlock = ^(UIViewController *_Nonnull contentViewController) {
      contentViewController.view.alpha = 0.f;
    };
  }
  return _hideAnimationBlock;
}

- (void)startTimer {
  if (_taskTimer) {
    return;
  }
  _timerCountDown = self.displayTime;
  _taskTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(taskUpdate) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:_taskTimer forMode:NSRunLoopCommonModes];
}

- (void)taskUpdate {
  _timerCountDown--;
  if (_timerCountDown <= 0) {
    [self endTimer];
    [NVMPopupUtil finishTaskWithCompletionHandler:self.taskOverBlock];
  } else {
    if (self.taskUpdateBlock) {
      self.taskUpdateBlock(_timerCountDown);
    }
  }
}

- (void)endTimer {
  if (_taskTimer) {
    [_taskTimer invalidate];
    _taskTimer = nil;
  }
}

- (UIWindowLevel)taskWindowLevel {
  if (_taskWindowLevel <= 0) {
    _taskWindowLevel = NVMWindowLevelStatusBar();
  }
  return _taskWindowLevel;
}

#pragma mark - Pop up priority

+ (NSUInteger)newUserPromotionPriority {
  return 900;
}

+ (NSUInteger)splashPriority {
  return 800;
}

+ (NSUInteger)redEnvelopePriority {
  return 700;
}

+ (NSUInteger)marketPopPriority {
  return 600;
}

@end

@implementation NVMPopUpWindow {
  __weak UIView *_editingStuff; // should be a textField or textView
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _popUpTasks = [NSMutableArray array];
    _editingStuff = nil;
  }
  return self;
}

- (void)becomeKeyWindow {
  if (SystemVersion >= 9.f && SystemVersion < 10.f && [self isThereSomethingEditing]) {
    if ([_editingStuff respondsToSelector:@selector(endEditing:)]) {
      [_editingStuff endEditing:YES];
    }
  }
}

- (void)resignKeyWindow {
  if ([_editingStuff respondsToSelector:@selector(becomeFirstResponder)]) {
    [_editingStuff becomeFirstResponder];
    _editingStuff = nil;
  }
}

- (BOOL)isThereSomethingEditing {
  NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
  if (windows.lastObject == self) {
    return NO;
  }
  __block UIView *editingStuff = nil;
  [windows enumerateObjectsUsingBlock:^(__kindof UIWindow *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    editingStuff = [self editingStuffOnSuper:obj];
    if (editingStuff) {
      *stop = YES;
    }
  }];
  _editingStuff = editingStuff;
  return _editingStuff != nil;
}

- (UIView *)editingStuffOnSuper:(UIView *)superView {
  if ([superView isKindOfClass:[UITextField class]] && [(UITextField *)superView isFirstResponder]) {
    return superView;
  }
  if ([superView isKindOfClass:[UITextView class]] && [(UITextView *)superView isFirstResponder]) {
    return superView;
  }
  if (superView.subviews.count <= 0) {
    return nil;
  }
  __block UIView *editView = nil;
  [superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    editView = [self editingStuffOnSuper:obj];
    if (editView) {
      *stop = YES;
    }
  }];
  return editView;
}

@end

static NSString *const NVMPopUpWindowKey = @"NVMPopUpWindowKey";
static NSTimeInterval const NVMPopUpWindowAnimationDuration = 0.25f;
static NVMPopUpQueueFinishBlock NVMPopUpQueueFinishHandler = nil;

@implementation NVMPopupUtil

+ (instancetype)sharedInstance {
  static id instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

+ (void)setQueueFinishHandler:(nullable NVMPopUpQueueFinishBlock)completionHandler {
  NVMPopUpQueueFinishHandler = [completionHandler copy];
}

- (nonnull NVMPopUpWindow *)popUpWindow {
    //添加属性
  NVMPopUpWindow *popWindow = objc_getAssociatedObject(self, &NVMPopUpWindowKey);
  if (!popWindow) {
    popWindow = [[NVMPopUpWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    objc_setAssociatedObject(self, &NVMPopUpWindowKey, popWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return popWindow;
}

- (void)popUpTask:(nonnull NVMPopUpTask *)task NS_EXTENSION_UNAVAILABLE_IOS("") {
  NSAssert([NSThread isMainThread], @"main thread only");
  if (self.popUpWindow.popUpTasks.count <= 0) {
    [self.popUpWindow.popUpTasks addObject:task];
  } else {
    [self.popUpWindow.popUpTasks
     enumerateObjectsUsingBlock:^(NVMPopUpTask *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
       if (!obj.isDisplaying && obj.priority < task.priority) {
         *stop = YES;
         [self.popUpWindow.popUpTasks insertObject:task atIndex:idx];
       }
     }];
    if (![self.popUpWindow.popUpTasks containsObject:task]) {
      [self.popUpWindow.popUpTasks addObject:task];
    }
  }
  if (self.popUpWindow.popUpTasks.count == 1) {
    [self.popUpWindow makeKeyAndVisible];
    [self runTaskQueue];
  }
}

- (void)finishTaskWithCompletionHandler:(nullable NVMPopUpTaskBlock)completionHandler {
  NSAssert([NSThread isMainThread], @"main thread only");
  NVMPopUpTask *task = [self.popUpWindow.popUpTasks firstObject];
  if (!task.isDisplaying) {
    return;
  }
  if (task.displayTime > 0) {
    [task endTimer];
  }
  [self.popUpWindow.popUpTasks removeObject:task];
  if (task.disableHideAnimation) {
    self.popUpWindow.rootViewController = nil;
    [self taskDidComplete:completionHandler];
    return;
  }
  [UIView animateWithDuration:NVMPopUpWindowAnimationDuration
                   animations:^{
                     task.hideAnimationBlock(task.contentViewController);
                   }
                   completion:^(BOOL finished) {
                     [self taskDidComplete:completionHandler];
                   }];
}

- (void)taskDidComplete:(nullable NVMPopUpTaskBlock)completionHandler {
  if (self.popUpWindow.popUpTasks.count <= 0) {
    self.popUpWindow.hidden = YES;
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
    objc_setAssociatedObject(self, &NVMPopUpWindowKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    BLOCK_EXEC(completionHandler);
    BLOCK_EXEC(NVMPopUpQueueFinishHandler);
    NVMPopUpQueueFinishHandler = nil;
  } else {
    BLOCK_EXEC(completionHandler);
    [self runTaskQueue];
  }
}

- (void)runTaskQueue {
  NVMPopUpTask *task = [self.popUpWindow.popUpTasks firstObject];
  if (task.isDisplaying) {
    return;
  }
  task.isDisplaying = YES;
  self.popUpWindow.rootViewController = task.contentViewController;
  self.popUpWindow.hidden = NO;
  self.popUpWindow.windowLevel = task.taskWindowLevel;
  if (task.disableShowAnimation) {
    [self taskDidStart:task];
    return;
  }
  [UIView animateWithDuration:NVMPopUpWindowAnimationDuration
                   animations:^{
                     task.showAnimationBlock(task.contentViewController);
                   }
                   completion:^(BOOL finished) {
                     [self taskDidStart:task];
                   }];
}

- (void)taskDidStart:(nonnull NVMPopUpTask *)task {
  if (task.displayTime > 0) {
    [task startTimer];
  }
}

- (void)clearAllPopUpTask NS_EXTENSION_UNAVAILABLE_IOS("") {
  [self.popUpWindow.popUpTasks
   enumerateObjectsUsingBlock:^(NVMPopUpTask *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
     if (obj.displayTime > 0) {
       [obj endTimer];
     }
   }];
  [self.popUpWindow.popUpTasks removeAllObjects];
  self.popUpWindow.hidden = YES;
  self.popUpWindow.rootViewController = nil;
  NVMPopUpQueueFinishHandler = nil;
}

- (NSUInteger)currentQueueLength {
  NVMPopUpWindow *popWindow = objc_getAssociatedObject(self, &NVMPopUpWindowKey);
  if (!popWindow) {
    return 0;
  }
  return popWindow.popUpTasks.count;
}

+ (void)popUpTask:(nonnull NVMPopUpTask *)task {
  [[self sharedInstance] popUpTask:task];
}

+ (void)finishTaskWithCompletionHandler:(nullable NVMPopUpTaskBlock)completionHandler {
  [[self sharedInstance] finishTaskWithCompletionHandler:completionHandler];
}

+ (void)clearAllPopUpTask {
  [[self sharedInstance] clearAllPopUpTask];
}

+ (NSUInteger)currentQueueLength {
  return [[self sharedInstance] currentQueueLength];
}

@end
