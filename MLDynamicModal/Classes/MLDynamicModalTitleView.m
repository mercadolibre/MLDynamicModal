//
//  MLDynamicModalTitleView.m
//  Pods
//
//  Created by Jonatan Urquiza on 8/19/17.
//
//

#import "MLDynamicModalTitleView.h"
#import <PureLayout/PureLayout.h>

@implementation MLDynamicModalTitleView

- (instancetype)initWithTitle:(NSAttributedString *)title
{
    self = [super init];
    if (self) {
        [self setupWithTitle:title];
    }
    return self;
}

- (void)setupWithTitle:(NSAttributedString *)title
{
    self.title = [[UILabel alloc] initForAutoLayout];
    self.title.attributedText = title;
    [self addSubview:self.title];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16.0f];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16.0f];
    [self.title autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.title autoSetDimension:ALDimensionHeight toSize:50.0f];
}

@end
