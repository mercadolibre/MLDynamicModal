//
// MLDynamicModalTransitionAnimator.m
//
// Created by Damian Trimboli on 9/24/15.
// Copyright (c) 2015 Mercado Libre. All rights reserved.
//

#import "MLDynamicModalTransitionAnimator.h"

@implementation MLDynamicModalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext
{
    return 0.25;
}

- (void)  dismissModal:(UIViewController <MLDynamicModalTransitionProtocol> *)modalViewController
    fromViewController:(UIViewController *)fromViewController
            andContext:(id <UIViewControllerContextTransitioning> )context
{
    fromViewController.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:[self transitionDuration:context]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations: ^{
                         fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                         
                         [modalViewController animationRatio:1];
                     } completion: ^(BOOL finished) {
                         [context completeTransition:YES];
                         fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
                     }];
}

- (void)  presentModal:(UIViewController <MLDynamicModalTransitionProtocol> *)modalViewController
    fromViewController:(UIViewController *)fromViewController
            andContext:(id <UIViewControllerContextTransitioning> )context
{
    CGRect frame = [context finalFrameForViewController:modalViewController];
    // The doc says that we might get a frame, and if we do, we have to respect it
    if (CGRectIsEmpty(frame)) {
        frame = fromViewController.view.frame;
    }
    
    self.interactable = NO;
    fromViewController.view.userInteractionEnabled = NO;
    [context.containerView addSubview:modalViewController.view];
    modalViewController.view.frame = frame;
    modalViewController.view.backgroundColor = [UIColor clearColor];
    [modalViewController offsetView:frame.size.height];
    [modalViewController prepareAnimationFadeInWithFrame:frame];
    
    [UIView animateWithDuration:[self transitionDuration:context]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                         [modalViewController animationRatio:0];
                     } completion: ^(BOOL finished) {
                         [context completeTransition:YES];
                     }];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )context
{
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (toViewController.isBeingPresented) {
        [self presentModal:(UIViewController < MLDynamicModalTransitionProtocol > *) toViewController
        fromViewController:fromViewController
                andContext:context];
    } else {
        [self dismissModal:(UIViewController < MLDynamicModalTransitionProtocol > *) fromViewController
        fromViewController:toViewController
                andContext:context];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning> )interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning> )animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning> )interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning> )animator
{
    if (self.interactable) {
        return self;
    }
    return nil;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning> )transitionContext
{
    self.transitionContext = transitionContext;
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    UIViewController <MLDynamicModalTransitionProtocol> *fromViewController = (UIViewController <MLDynamicModalTransitionProtocol> *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [fromViewController animationRatio:percentComplete];
}

- (void)cancelInteractiveTransitionWithRatio:(CGFloat)ratio
{
    self.interactable = NO;
    
    UIViewController <MLDynamicModalTransitionProtocol> *fromViewController = (UIViewController <MLDynamicModalTransitionProtocol> *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:(1 - fabs(ratio)) *[self transitionDuration:self.transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [fromViewController animationRatio:0];
                     } completion: ^(BOOL finished) {
                         [self.transitionContext cancelInteractiveTransition];
                         [self.transitionContext completeTransition:NO];
                         self.transitionContext = nil;
                     }];
    
    [self cancelInteractiveTransition];
}

- (void)finishInteractiveTransitionWithRatio:(CGFloat)ratio
{
    self.interactable = NO;
    
    UIViewController *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <MLDynamicModalTransitionProtocol> *fromViewController = (UIViewController <MLDynamicModalTransitionProtocol> *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    toViewController.view.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         [fromViewController animationRatio:1 * (ratio / fabs(ratio))];
                     } completion: ^(BOOL finished) {
                         [fromViewController.view removeFromSuperview];
                         [self.transitionContext completeTransition:YES];
                         self.transitionContext = nil;
                     }];
    
    [self finishInteractiveTransition];
}

@end
