//
// MLDynamicModalViewController.m
//
// Created by Vanesa Stricker on 9/11/15.
// Modified by Julian Bruno on 9/7/16
// Copyright (c) 2015 Mercado Libre. All rights reserved.
//

#import "MLDynamicModalViewController.h"
#import "MLDynamicModalTitleView.h"
#import "MLDynamicModalTransitionAnimator.h"
#import "PureLayout.h"
#import "FXBlurView.h"
#import <MLUI/UIFont+MLFonts.h>

static const int kBottomSpaceContent = 32;
static const int kTopSpaceContent = 4;
static const int kHorizontalMargin = 32;

@interface MLDynamicModalViewController () <MLDynamicModalTransitionProtocol>
@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *insideViewToSet;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSAttributedString *modalTitle;
@property (strong, nonatomic) NSLayoutConstraint *topSpaceContentConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomSpaceContentConstraint;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *closeButtonColor;
@property (strong, nonatomic) UIColor *headerBackgroundColor;
@property (nonatomic, assign) CGFloat viewOffsetY;
@property (nonatomic, assign) CGFloat hortizontalMargin;
@property (strong, nonatomic) MLDynamicModalTransitionAnimator *transitionAnimator;
@property (nonatomic) BOOL showCloseButton;
@property (nonatomic) BOOL shouldDismissOnTap;
@property (nonatomic) BOOL shouldSwipeToDismiss;
@property (nonatomic) BOOL showVerticalIndicator;
@property (nonatomic) BOOL showCancelButton;
@property (nullable, strong, nonatomic) NSString *cancelButtonTitle;
@property (nullable, nonatomic, copy) void (^closeCallback)(MLDynamicModalViewController *);

@end

@implementation MLDynamicModalViewController



- (instancetype)initWithView:(UIView *)view headerView:(UIView *)headerView
{
    return [self initWithView:view attributedTitle:nil headerView:headerView];
}

- (instancetype)initWithView:(UIView *)view title:(NSString *)title
{
    return [self initWithView:view attributedTitle:[[NSAttributedString alloc] initWithString:title] headerView:nil];
}

- (instancetype)initWithView:(UIView *)view attributedTitle:(NSAttributedString *)attributedTitle
{
    return [self initWithView:view attributedTitle:attributedTitle headerView:nil];
}

- (instancetype)initWithView:(UIView *)view
{
    return [self initWithView:view attributedTitle:nil headerView:nil];
}

- (instancetype)initWithView:(UIView *)view attributedTitle:(NSAttributedString *)attributedTitle headerView:(UIView *)headerView
{
    self = [super init];
    if (self) {
        self.transitionAnimator = [[MLDynamicModalTransitionAnimator alloc] init];
        self.transitioningDelegate = self.transitionAnimator;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.insideViewToSet = view;
        self.modalTitle = attributedTitle;
        self.headerView = headerView;
        self.showCloseButton = NO;
        self.shouldDismissOnTap = NO;
        self.shouldSwipeToDismiss = NO;
        self.showVerticalIndicator = YES;
        self.hortizontalMargin = kHorizontalMargin;
        self.backgroundColor = [UIColor colorWithRed:35/255 green:35/255 blue:35/255 alpha:0.5];
        self.closeButtonColor = [UIColor whiteColor];
        self.headerBackgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
    
    if (self.insideViewToSet) {
        [self configInsideViewToSet];
    }
    if (self.showCloseButton) {
        [self configureCloseButtonWithColor:self.closeButtonColor];
    }
    [self addViewGestureRecognizers];
}


- (void)setupSubviews
{
    //BackgroundView
    self.backgroundView = [[UIView alloc] initForAutoLayout];
    [self.backgroundView setBackgroundColor:self.backgroundColor];
    [self.view addSubview:self.backgroundView];
    
    //ContainerView
    self.containerView = [[UIView alloc] initForAutoLayout];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.cornerRadius = 3;
    self.containerView.layer.masksToBounds = YES;
    [self.view addSubview:self.containerView];
    
    //ScrollView
    self.scrollView = [[UIScrollView alloc] initForAutoLayout];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = self.showVerticalIndicator;
    [self.containerView addSubview:self.scrollView];
    
    //HeaderView
    if (!self.headerView && self.modalTitle) {
        self.headerView = [[MLDynamicModalTitleView alloc] initWithTitle:self.modalTitle];
        [self.headerView setBackgroundColor:self.headerBackgroundColor];
        [self.headerView configureForAutoLayout];
    }
    [self.containerView addSubview:self.headerView];
    
    //NavigationBar
    self.navBar = [[UINavigationBar alloc] initForAutoLayout];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navBar.shadowImage = [UIImage new];
    [self.view addSubview:self.navBar];
    
    //SetupConstraints
    [self setupConstraints];
}

- (void)setupConstraints
{
    //BackgroundView
    [self.backgroundView autoPinEdgesToSuperviewEdges];
    
    //ContainerView
    [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.hortizontalMargin relation:NSLayoutRelationGreaterThanOrEqual];
    [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.hortizontalMargin relation:NSLayoutRelationGreaterThanOrEqual];
    
    
    [self.containerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.topSpaceContentConstraint = [self.containerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:kTopSpaceContent relation:NSLayoutRelationGreaterThanOrEqual];
    self.bottomSpaceContentConstraint = [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSpaceContent relation:NSLayoutRelationGreaterThanOrEqual];
    [self.topSpaceContentConstraint autoInstall];
    [self.bottomSpaceContentConstraint autoInstall];
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
        [self.containerView autoSetDimension:ALDimensionWidth toSize:400.0];
        [self.containerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }];
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
        [self.containerView autoSetDimension:ALDimensionHeight toSize:700.0];
    }];
    
    //HeaderView
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.headerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
    //ScrollView
    if (self.headerView) {
        [self.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerView];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    } else {
        [self.scrollView autoPinEdgesToSuperviewEdges];
    }
    
    //NavigationBar
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [self.navBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.navBar autoSetDimension:ALDimensionWidth toSize:self.view.frame.size.width];
    [self.navBar autoSetDimension:ALDimensionHeight toSize:44.0f];
}


- (void)addViewGestureRecognizers
{
    if (self.shouldDismissOnTap) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithTapGesture:)];
        [self.backgroundView addGestureRecognizer:tapGesture];
    }
    
    if (self.shouldSwipeToDismiss) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)dismissWithTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    CGRect viewFrame = [self.view convertRect:self.insideViewToSet.frame fromView:self.insideViewToSet.superview];
    if ((!CGRectContainsPoint(viewFrame, location))) {
        [self dismissView];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat d = translation.y / CGRectGetHeight(recognizer.view.bounds);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.transitionAnimator.interactable = YES;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.transitionAnimator updateInteractiveTransition:d];
    } else if (recognizer.state >= UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        if ((fabs(velocity.y) > 400 || fabs(d) > 0.1) && velocity.y * d > 0) {
            self.view.userInteractionEnabled = NO;
            [self.viewControllerDelegate itemViewDismissed];
            if (self.closeCallback) {
                self.closeCallback(self);
            }
            [self.transitionAnimator finishInteractiveTransitionWithRatio:d];
        } else {
            [self.transitionAnimator cancelInteractiveTransitionWithRatio:d];
        }
    }
}

- (void)configureCloseButtonWithColor:(UIColor *)color
{
    UIImage *closeImg = [UIImage imageNamed:@"mld_cruz"
                                   inBundle:[NSBundle bundleForClass:NSClassFromString(@"MLDynamicModalViewController")]
              compatibleWithTraitCollection:nil];
    
    closeImg = [closeImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithImage:closeImg
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(closeButtonPressed)];
    closeBtn.tintColor = color;
    self.navItem = [[UINavigationItem alloc] init];
    [self.navItem setLeftBarButtonItem:closeBtn];
    [self.navBar setItems:@[self.navItem]];
}

- (void)closeButtonPressed
{
    [self dismissView];
}

- (void)dismissView
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self.viewControllerDelegate itemViewDismissed];
        if (self.closeCallback) {
            self.closeCallback(self);
        }
    }];
}

- (void)offsetView:(CGFloat)y
{
    self.viewOffsetY = y;
    [self.topSpaceContentConstraint autoRemove];
    [self.bottomSpaceContentConstraint autoRemove];
    
    self.topSpaceContentConstraint = [self.containerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navBar withOffset:kTopSpaceContent + self.viewOffsetY relation:NSLayoutRelationGreaterThanOrEqual];
    
    self.bottomSpaceContentConstraint = [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSpaceContent-self.viewOffsetY relation:NSLayoutRelationGreaterThanOrEqual];
    
    
    [self.topSpaceContentConstraint autoInstall];
    [self.bottomSpaceContentConstraint autoInstall];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)prepareAnimationFadeInWithFrame:(CGRect)frame
{
    self.backgroundView.alpha = 0;
    self.navBar.alpha = 0;
    
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:frame];
    blurView.dynamic = NO;
    blurView.updateInterval = 0;
    blurView.underlyingView = self.presentingViewController.view;
    blurView.blurRadius = 20;
    blurView.alpha = 0;
    [self.view insertSubview:blurView atIndex:0];
    
    [blurView setNeedsDisplay];
}

- (void)animationFadeInWithFrame:(CGRect)frame
{
    self.backgroundView.alpha = 1;
    self.navBar.alpha = 1;
    
    FXBlurView *blurView = self.view.subviews.firstObject;
    blurView.alpha = 1;
    
    [blurView setNeedsDisplay];
}

- (void)animationFadeOut
{
    self.backgroundView.alpha = 0;
    self.navBar.alpha = 0;
    
    FXBlurView *blurView = self.view.subviews.firstObject;
    blurView.alpha = 0;
    
    [blurView setNeedsDisplay];
}

- (void)animationRatio:(CGFloat)percent
{
    self.backgroundView.alpha = 1 - fabs(percent);
    self.navBar.alpha = 1 - fabs(percent);
    
    FXBlurView *blurView = self.view.subviews.firstObject;
    blurView.alpha = 1 - fabs(percent);
    
    [self offsetView:self.view.bounds.size.height * percent];
    
    [blurView setNeedsDisplay];
}

- (void)configInsideViewToSet
{
    [self.insideViewToSet configureForAutoLayout];
    
    if (self.showCancelButton) {
        self.cancelButton = [[UIButton alloc] initForAutoLayout];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        [self.cancelButton setTitle:self.cancelButtonTitle forState: UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont ml_lightSystemFontOfSize:20.0f];
        [self.cancelButton addTarget:self action:@selector(didSelectCancelButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *innerView = [[UIView alloc] initForAutoLayout];
        [innerView setBackgroundColor:[UIColor clearColor]];
        [innerView addSubview:self.insideViewToSet];
        [innerView addSubview:self.cancelButton];
        [self.scrollView addSubview:innerView];
        
        [innerView autoPinEdgesToSuperviewEdges];
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [innerView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
        }];
        [innerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];

        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
        [self.cancelButton autoSetDimension:ALDimensionHeight toSize:20.0f];
        [self.cancelButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.insideViewToSet autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.insideViewToSet autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.insideViewToSet autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.insideViewToSet autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.cancelButton withOffset:-24.0f];
        
    }else{
        [self.scrollView addSubview:self.insideViewToSet];
        [self.insideViewToSet autoPinEdgesToSuperviewEdges];
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.insideViewToSet autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
        }];
        [self.insideViewToSet autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
    }
    
}

- (void)setModalBackgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
    [self.backgroundView setBackgroundColor:self.backgroundColor];
}

- (void)setModalCloseButtonColor:(UIColor *)color
{
    self.closeButtonColor = color;
    self.showCloseButton = YES;
}

- (void)setModalHeaderBackgroundColor:(UIColor *)color
{
    self.headerBackgroundColor = color;
}

- (void)setHorizontalMargin:(CGFloat)horizontalMargin
{
    self.hortizontalMargin = horizontalMargin;
}

- (void)setShowCancelButton:(BOOL)show title:(NSString *)title
{
    self.showCancelButton = show;
    self.cancelButtonTitle = title;
}

- (void)setCloseCallback:(nullable void (^)(MLDynamicModalViewController *))callback{
    _closeCallback = callback;
}

- (void)didSelectCancelButton
{
    [self dismissView];
}

@end
