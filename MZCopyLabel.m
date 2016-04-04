//
//  MZCopyLabel.m
//  LongPressLabel
//
//  Created by MarkZhao on 16/4/4.
//  Copyright © 2016年 markzhao. All rights reserved.
//

#import "MZCopyLabel.h"

@implementation MZCopyLabel{
    UIColor *_bckColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addPressGesture];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self addPressGesture];
}

//覆盖方法，能接收事件
- (BOOL)canBecomeFirstResponder{
    
    return YES;
}

//添加长按事件
- (void)addPressGesture{
    
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    pressGesture.minimumPressDuration = 1.0;
    [self addGestureRecognizer:pressGesture];
}

//长按
- (void)longPress:(UIGestureRecognizer *)gesture{
    
    //判断手势状态,在手势开始的时候记录当前背景颜色，待还原
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _bckColor = self.backgroundColor;
    }
        [self becomeFirstResponder];
        self.backgroundColor = [UIColor lightGrayColor];
        //添加复制、粘贴到menuController
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText)];
        UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(pasteText)];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, pasteItem, nil]];

}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    return ((action == @selector(copyText)) || (action == @selector(pasteText)));
}

- (void)copyText{
    
    self.backgroundColor = _bckColor;
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = self.text;

    [self resignFirstResponder];
    NSLog(@"已复制");
    
}

- (void)pasteText{
    
    NSLog(@"粘贴");
    self.backgroundColor = _bckColor;
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    self.text = pastBoard.string;
    [self resignFirstResponder];
    
}

- (BOOL)resignFirstResponder{
    
    return YES;
}

@end
