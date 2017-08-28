//
//  MLDMCustomHeaderView.m
//  MLDynamicModal
//
//  Created by Jonatan Urquiza on 8/25/17.
//  Copyright © 2017 Jonatan Urquiza. All rights reserved.
//

#import "MLDMCustomHeaderView.h"
#import <PureLayout/PureLayout.h>

@interface MLDMCustomHeaderView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *anotherLabel;

@end

@implementation MLDMCustomHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self setupSubviews];
        
    }
    return self;
}


- (void)setupSubviews
{
    self.title = [[UILabel alloc] initForAutoLayout];
    self.title.text = @"Custom";
    [self addSubview:self.title];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16.0f];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16.0f];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f];
    
    self.anotherLabel = [[UILabel alloc] initForAutoLayout];
    self.anotherLabel.text = @"title";
    [self addSubview:self.anotherLabel];
    [self.anotherLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16.0f];
    [self.anotherLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16.0f];
    [self.anotherLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.title withOffset:20.0f];
    
}



@end
