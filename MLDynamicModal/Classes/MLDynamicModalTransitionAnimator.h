//
// MLDynamicModalTransitionAnimator.h
//
// Created by Damian Trimboli on 9/24/15.
// Modified by Julian Bruno on 9/7/16.
// Copyright (c) 2015 Mercado Libre. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Implement this protocol in the view presented modally
 **/
@protocol MLDynamicModalTransitionProtocol <NSObject>

/**
 *  Notify the view that must set an offset to its content view
 *  @param y The offset to use.
 **/
- (void)offsetView:(CGFloat)y;

/**
 *  Notify the delegate that the animation fade in
 *  @param frame The final frame for the view controller showing the animation
 **/
- (void)animationFadeInWithFrame:(CGRect)frame;

/**
 *  Notify the delegate that the animation fade out
 **/
- (void)animationFadeOut;

/**
 *  Notify the delegate that the animation will fade in
 *  @param frame The final frame for the view controller showing the animation
 **/
- (void)prepareAnimationFadeInWithFrame:(CGRect)frame;

/**
 *  Notify the delegate that should place the animation at the given ratio
 *  @param percent animation ratio
 **/
- (void)animationRatio:(CGFloat)percent;

@end

/**
 *  This class animate the presentation of the item detail modal view
 **/
@interface MLDynamicModalTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate>

/**
 *  Current transition context
 **/
@property (nonatomic, readwrite) id <UIViewControllerContextTransitioning> transitionContext;

/**
 *  The transition is interactable
 **/
@property (assign, nonatomic) BOOL interactable;

/**
 *  Cancel the current interactive transition
 *  @param ratio animation at the cancelled time
 **/
- (void)cancelInteractiveTransitionWithRatio:(CGFloat)ratio;

/**
 *  Finish the current interactive transition succesfully
 *  @param ratio animation at the finished time
 **/
- (void)finishInteractiveTransitionWithRatio:(CGFloat)ratio;

@end
