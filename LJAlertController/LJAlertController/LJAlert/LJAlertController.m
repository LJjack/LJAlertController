//
//  LJAlertController.m
//  SKAlertController
//
//  Created by 刘俊杰 on 2018/7/18.
//

#import "LJAlertController.h"
#import "BJAlertAnimation.h"

@interface LJAlertAction()

@property (nonatomic) NSString *title;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, copy) void (^handler)(LJAlertAction *action);

@end

@implementation LJAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(LJAlertAction * _Nonnull))handler {
    LJAlertAction *alertAction = [[LJAlertAction alloc] init];
    alertAction.title = title;
    alertAction.handler = handler;
    return alertAction;
}

@end

@interface LJAlertController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray<LJAlertAction *> *actionList;
@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LJAlertController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    LJAlertController *alert = [[LJAlertController alloc]init];
    alert.headline = title;
    alert.message = message;
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.transitioningDelegate = alert;
    alert.actionList = [NSMutableArray array];
    return alert;
}
- (void)addAction:(LJAlertAction *)action{
    [self.actionList addObject:action];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    //content
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    //title
    if (self.headline) {
        [self.scrollContentView addSubview:self.titleLabel];
        self.titleLabel.text = self.headline;
    }
    //message
    if (self.message) {
        [self.scrollContentView addSubview:self.messageLabel];
        self.messageLabel.text = self.message;
    }
    [self.contentView addSubview:self.stackView];
    [self.contentView addSubview:self.lineView];
    NSInteger listCount = _actionList.count;
    for (NSInteger idx = 0; idx < listCount; idx ++) {
        LJAlertAction *action = _actionList[idx];
        UIButton *btn = [self createBtn:action.title tag:idx];
        action.btnView = btn;
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = [UIColor colorWithWhite:229.00/255.00 alpha:1.0];
        separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.stackView addArrangedSubview:btn];
        [self.stackView addArrangedSubview:separatorView];
        if (idx > 0) {
            [self.stackView addConstraint:[NSLayoutConstraint constraintWithItem:_actionList[idx - 1].btnView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_actionList[idx].btnView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
        if (idx <= listCount - 1) {
            [self.stackView addConstraint:[NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
        }
    }
    [self addConstraints];
}

- (void)addConstraints {
    //contentView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:270]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0]];
    //scrollView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];//top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];//left
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];//right
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.stackView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    //scrollContentView
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];//top
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];//left
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];//bottom
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];//right
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];//centerX
    NSLayoutConstraint *contentViewHeight = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:44];
    contentViewHeight.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:contentViewHeight];
    //titleLabel
    [self.scrollContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];//left
    [self.scrollContentView addConstraint: [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];//right
    [self.scrollContentView addConstraint: [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];//top
    //messageLabel
    [self.scrollContentView addConstraint: [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    [self.scrollContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.scrollContentView addConstraint: [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.scrollContentView addConstraint: [NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
    //stackView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.stackView addConstraint:[NSLayoutConstraint constraintWithItem:self.stackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0]];
    
    //lineView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];//left
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];//right
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.stackView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];//top
    [self.lineView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];//height
}

- (UIButton *)createBtn:(NSString *)name tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor: [UIColor colorWithWhite:135.00/255.00 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    return btn;
}

- (void)clickBtnAction:(UIButton *)sender {
    
    LJAlertAction *action = _actionList[sender.tag];
    if (action.handler) {
        action.handler(action);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    BJAlertAnimation *animation = [[BJAlertAnimation alloc] init];
    animation.contentView = self.contentView;
    return animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    BJAlertAnimation *animation = [[BJAlertAnimation alloc] init];
    animation.contentView = self.contentView;
    return animation;
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollContentView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:36.0/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [UIColor colorWithWhite:135.00/255.00 alpha:1.0];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _messageLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:229.00/255.00 alpha:1.0];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _lineView;
}

@end
