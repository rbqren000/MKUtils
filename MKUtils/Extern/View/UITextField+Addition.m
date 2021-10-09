//
//  UITextField+Addition.m
//  Basic
//
//  Created by zhengmiaokai on 2017/5/23.
//  Copyright © 2017年 zhengmiaokai. All rights reserved.
//

#import "UITextField+Addition.h"
#import <objc/runtime.h>

static const void *regularPatternKey = &regularPatternKey;
static const void *maxLengthKey = &maxLengthKey;
static const void *blockTextChangedKey = &blockTextChangedKey;

@implementation UITextField (Addition)

- (LCTextChangedBlock)textChangedBlock {
    LCTextChangedBlock textChangedBlock  = objc_getAssociatedObject(self, blockTextChangedKey);
    return textChangedBlock;
}

- (void)setTextChangedBlock:(LCTextChangedBlock)textChangedBlock {
    objc_setAssociatedObject(self, blockTextChangedKey, textChangedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)maxLength {
    NSNumber* number = objc_getAssociatedObject(self, maxLengthKey);
    return number.integerValue;
}

- (void)setMaxLength:(NSInteger)maxLength {
    NSNumber* number = [NSNumber numberWithInteger:maxLength];
    objc_setAssociatedObject(self, maxLengthKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (NSString *)regularPattern {
    NSString* regularPattern = objc_getAssociatedObject(self, regularPatternKey);
    return regularPattern;
}

- (void)setRegularPattern:(NSString *)regularPattern {
    objc_setAssociatedObject(self, regularPatternKey, regularPattern, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)textFiledEditChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (self == textField) {
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            //根据正则，过滤特殊字符
            if (self.regularPattern) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.regularPattern options:NSRegularExpressionCaseInsensitive error:nil];
                textField.text = [regex stringByReplacingMatchesInString:textField.text options:NSMatchingReportCompletion range:NSMakeRange(0, textField.text.length) withTemplate:@""];
            }
            
            if (toBeString.length > self.maxLength) {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
            if (self.textChangedBlock) {
                self.textChangedBlock(textField.text);
            }
        }
    }
}

- (void)removeEditObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)showInputAccessoryView {
    UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn sizeToFit];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *_toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    _toolbar.items = @[spaceItem, doneItem];
    self.inputAccessoryView = _toolbar;
}

- (void)done:(id)sender {
    [self resignFirstResponder];
}

@end
