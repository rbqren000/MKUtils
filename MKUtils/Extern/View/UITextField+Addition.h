//
//  UITextField+Addition.h
//  Basic
//
//  Created by zhengmiaokai on 2017/5/23.
//  Copyright © 2017年 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextChangedBlock)(NSString *text);

@interface UITextField (Addition)

/// 文本变化的回调
@property (nonatomic, copy) TextChangedBlock textChangedBlock;

/// 限制文本长度
@property (nonatomic, assign) NSInteger maxLength;

/// 过滤指定字符
@property (nonatomic, copy) NSString* regularPattern;

- (void)removeEditObserver;

- (void)showInputAccessoryView;

@end
