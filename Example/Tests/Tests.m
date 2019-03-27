//
//  MLDynamicModalTests.m
//  MLDynamicModalTests
//
//  Created by Jonatan Urquiza on 08/08/2017.
//  Copyright (c) 2017 Jonatan Urquiza. All rights reserved.
//

@import XCTest;
#import <MLDynamicModal/MLDynamicModalViewController.h>
#import <MLDynamicModal/MLDynamicModalTransitionAnimator.h>
#import <MLDynamicModal/MLDynamicModalTitleView.h>
#import <OCMock/OCMock.h>

@interface Tests : XCTestCase

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) MLDynamicModalViewController *modalViewController;

@end

@interface MLDynamicModalViewController (Test)

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UIView *containerView;
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
@property (nonatomic, weak) id <MLDynamicModalViewControllerDelegate> viewControllerDelegate;
@property (strong, nonatomic) MLDynamicModalTransitionAnimator *transitionAnimator;
@property (nonatomic) BOOL showCloseButton;
@property (nonatomic) BOOL shouldDismissOnTap;
@property (nonatomic) BOOL shouldSwipeToDismiss;


- (instancetype)initWithView:(UIView *)view attributedTitle:(NSAttributedString *)attributedTitle headerView:(UIView *)headerView;
- (void)setupSubviews;
- (void)setupConstraints;
- (void)configureCloseButtonWithColor:(UIColor *)color;
- (void)closeButtonPressed;
- (void)dismissView;
- (void)configInsideViewToSet;
- (void)setModalBackgroundColor:(UIColor *)color;
- (void)setModalCloseButtonColor:(UIColor *)color;
- (void)setModalHeaderBackgroundColor:(UIColor *)color;


@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    self.viewController = [[UIViewController alloc]init];
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] init]);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilInit
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:nil headerView:nil]);
    [self.modalViewController viewDidLoad];
    OCMVerify([self.modalViewController setupSubviews]);
    OCMVerify([self.modalViewController setupConstraints]);
}

- (void)testTitleInit
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController viewDidLoad];
    OCMVerify([self.modalViewController.containerView addSubview:self.modalViewController.headerView]);
    
}

- (void)testSetupSubviews
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:nil headerView:nil]);
    [self.modalViewController viewDidLoad];
    OCMVerify([self.modalViewController.view addSubview:self.modalViewController.backgroundView]);
    OCMVerify([self.modalViewController.view addSubview:self.modalViewController.containerView]);
    OCMVerify([self.modalViewController.containerView addSubview:self.modalViewController.scrollView]);
    OCMVerify([self.modalViewController.view addSubview:self.modalViewController.navBar]);
    OCMVerify([self.modalViewController setupConstraints]);
}

- (void)testTitleView
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController viewDidLoad];
    
    XCTAssertEqualObjects(((MLDynamicModalTitleView *)self.modalViewController.headerView).title.text, @"modal");
}

- (void)testConfigureCloseButtonWithColor
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController viewDidLoad];
    [self.modalViewController configureCloseButtonWithColor:[UIColor redColor]];
    
    
    XCTAssertEqualObjects([self.modalViewController.navBar.items firstObject].leftBarButtonItem.tintColor, [UIColor redColor]);
}

- (void)testDissmiss
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController viewDidLoad];
    [self.modalViewController closeButtonPressed];
    OCMVerify([self.modalViewController dismissView]);
}

- (void)testConfigInsideViewToSet
{
    UIView *view = [[UIView alloc] init];
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:view]);
    [self.modalViewController viewDidLoad];
    
    OCMVerify([self.modalViewController.scrollView addSubview:view]);
    
}

- (void)testSetModalBackgroundColor
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController setBackgroundColor:[UIColor redColor]];
    [self.modalViewController viewDidLoad];
    
    XCTAssertEqualObjects(self.modalViewController.backgroundView.backgroundColor, [UIColor redColor]);
}


- (void)testSetModalCloseButtonColor
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController setModalCloseButtonColor:[UIColor redColor]];
    [self.modalViewController viewDidLoad];
    
    XCTAssertEqualObjects(self.modalViewController.closeButtonColor, [UIColor redColor]);
}


- (void)testSetModalHeaderBackgroundColor
{
    self.modalViewController = OCMPartialMock([[MLDynamicModalViewController alloc] initWithView:nil attributedTitle:[[NSAttributedString alloc] initWithString:@"modal"] headerView:nil]);
    [self.modalViewController setModalHeaderBackgroundColor:[UIColor redColor]];
    [self.modalViewController viewDidLoad];
    
    XCTAssertEqualObjects(self.modalViewController.headerView.backgroundColor, [UIColor redColor]);
}

@end


