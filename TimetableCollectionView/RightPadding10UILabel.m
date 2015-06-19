//
//  RightPadding10UILabel.m
//  TimetableCollectionView
//
//  Created by Igor Andrade on 6/18/15.
//  Copyright (c) 2015 Tokenlab. All rights reserved.
//

#import "RightPadding10UILabel.h"

@implementation RightPadding10UILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {
        0, // top
        0, // left
        0, // bottom
        10 // right
    };
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
