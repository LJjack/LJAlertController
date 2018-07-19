//
//  LJAlertController.h
//  SKAlertController
//
//  Created by 刘俊杰 on 2018/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(void (^ __nullable)(LJAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface LJAlertController : UIViewController

@property (nonatomic, readonly, copy) NSArray<LJAlertAction *> *actions;

+(instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(LJAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
