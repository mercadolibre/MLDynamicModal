//
//  MLDMLargeInsideView.m
//  MLDynamicModal
//
//  Created by Jonatan Urquiza on 8/25/17.
//  Copyright © 2017 Jonatan Urquiza. All rights reserved.
//

#import "MLDMLargeInsideView.h"
#import <PureLayout/PureLayout.h>

@implementation MLDMLargeInsideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    [self configureForAutoLayout];
    UILabel *text = [[UILabel alloc] init];
    text.text = @"Test";
    text.textAlignment = NSTextAlignmentCenter;
    UILabel *text1 = [[UILabel alloc] init];
    text1.text = @"Modal";
    text1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:text];
    [self addSubview:text1];
    [text autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:350.0];
    [text autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0];
    [text autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0];
    [text1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:text withOffset:50.0];
    [text1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0];
    [text1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0];
    [text1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:350.0];
}
@end
