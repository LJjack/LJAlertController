//
//  BJAlertAnimation.m
//  BJBasi
//
//  Created by 刘俊杰 on 2017/7/6.
//  Copyright © 2017年 巴斯. All rights reserved.
//

#import "BJAlertAnimation.h"

@implementation BJAlertAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!toVC || !fromVC) { return; }
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if(toVC.isBeingPresented){
        toVC.view.alpha = 0.0f;
        self.contentView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        [containerView addSubview:toVC.view];
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            toVC.view.alpha = 1.0f;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    } else if (fromVC.isBeingDismissed) {
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            fromVC.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    }
}

@end
