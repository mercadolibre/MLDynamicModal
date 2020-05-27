//
//  MLDMViewController.m
//  MLDynamicModal
//
//  Created by Jonatan Urquiza on 08/08/2017.
//  Copyright (c) 2017 Jonatan Urquiza. All rights reserved.
//

#import "MLDMViewController.h"
#import "MLDynamicModalViewController.h"
#import "MLDMLargeInsideView.h"
#import "MLDMInsideView.h"
#import "MLDMCustomHeaderView.h"
#import <PureLayout/PureLayout.h>

@implementation MLDMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureButtons];
}

- (void)configureButtons
{
    UIStackView *buttons = [[UIStackView alloc] initForAutoLayout];
    buttons.axis = UILayoutConstraintAxisVertical;
    buttons.distribution = UIStackViewDistributionEqualSpacing;
    buttons.alignment = UIStackViewAlignmentCenter;
    buttons.spacing = 0;
    
    [self.view addSubview:buttons];
    
    UIButton *showPlainModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showPlainModal setTitle:@"Show Plain Modal" forState:UIControlStateNormal];
    [showPlainModal addTarget:self action:@selector(showPlainModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showPlainModal];
    
    UIButton *showLargePlainModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showLargePlainModal setTitle:@"Show Large Plain Modal" forState:UIControlStateNormal];
    [showLargePlainModal addTarget:self action:@selector(showLargePlainModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showLargePlainModal];
    
    UIButton *showTitleModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showTitleModal setTitle:@"Show Title Modal" forState:UIControlStateNormal];
    [showTitleModal addTarget:self action:@selector(showTitleModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showTitleModal];
    
    UIButton *showLargeTitleModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showLargeTitleModal setTitle:@"Show Large Title Modal" forState:UIControlStateNormal];
    [showLargeTitleModal addTarget:self action:@selector(showLargeTitleModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showLargeTitleModal];
    
    UIButton *showCustomModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showCustomModal setTitle:@"Show Custom Modal" forState:UIControlStateNormal];
    [showCustomModal addTarget:self action:@selector(showCustomModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showCustomModal];
    
    UIButton *showCustomHeaderModal = [UIButton buttonWithType:UIButtonTypeSystem];
    [showCustomHeaderModal setTitle:@"Show Custom Header Modal" forState:UIControlStateNormal];
    [showCustomHeaderModal addTarget:self action:@selector(showCustomHeaderModalAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addArrangedSubview:showCustomHeaderModal];
    
    [buttons autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [buttons autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [buttons autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)showPlainModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMInsideView alloc] init]];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    [modal setCloseBtnAccessibility:@"Close"];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)showLargePlainModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMLargeInsideView alloc] init]];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)showTitleModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMInsideView alloc] init] title:@"modal"];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    [modal setCloseBtnAccessibility:@"Close"];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)showLargeTitleModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMLargeInsideView alloc] init] title:@"modal"];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    [modal setShowVerticalIndicator:NO];
    [modal setCloseBtnAccessibility:@"Close"];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)showCustomModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMLargeInsideView alloc] init] attributedTitle:[[NSAttributedString alloc] initWithString:@"Modal"
                                attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:50]}]];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    [modal setCloseBtnAccessibility:@"Close"];
    [modal setModalBackgroundColor:[UIColor yellowColor]];
    [modal setModalCloseButtonColor:[UIColor redColor]];
    [modal setModalHeaderBackgroundColor:[UIColor redColor]];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

- (void)showCustomHeaderModalAction:(id)sender
{
    MLDynamicModalViewController *modal = [[MLDynamicModalViewController alloc] initWithView:[[MLDMLargeInsideView alloc] init] headerView:[[MLDMCustomHeaderView alloc] init]];
    [modal setShouldDismissOnTap:YES];
    [modal setShouldSwipeToDismiss:YES];
    [modal setShowCloseButton:YES];
    [modal setCloseBtnAccessibility:@"Close"];
    [modal setHorizontalMargin:16.0f];
    modal.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

@end
