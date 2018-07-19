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
@property (nonatomic) UIAlertControllerStyle preferredStyle;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LJAlertController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    LJAlertController *alert = [[LJAlertController alloc]init];
    alert.headline = title;
    alert.message = message;
    alert.preferredStyle = preferredStyle;
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
    if (listCount > 2) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        for (NSInteger idx = 0; idx < listCount; idx ++) {
            LJAlertAction *action = _actionList[idx];
            UIButton *btn = [self createBtn:action.title tag:idx];
            action.btnView = btn;
            [self.stackView addArrangedSubview:btn];
            if (idx > 0) {
                [btn.heightAnchor constraintEqualToConstant:44.0].active = YES;
            }
            if (idx <= listCount - 1) {
                UIView *separatorView = [self createSeparatorView];
                [self.stackView addArrangedSubview:separatorView];
                [separatorView.heightAnchor constraintEqualToConstant:0.5].active = YES;
            }
        }
    } else {
        for (NSInteger idx = 0; idx < listCount; idx ++) {
            LJAlertAction *action = _actionList[idx];
            UIButton *btn = [self createBtn:action.title tag:idx];
            action.btnView = btn;
            [self.stackView addArrangedSubview:btn];
            if (idx > 0) {
                [btn.widthAnchor constraintEqualToAnchor:_actionList[idx - 1].btnView.widthAnchor].active = YES;
            }
            if (idx <= listCount - 1) {
                UIView *separatorView = [self createSeparatorView];
                [self.stackView addArrangedSubview:separatorView];
                [separatorView.widthAnchor constraintEqualToConstant:0.5].active = YES;
            }
        }
    }
    [self addConstraints];
}

- (void)addConstraints {
    //contentView
    [self.contentView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:20.0].active = YES;// >=top
    if (self.preferredStyle == UIAlertControllerStyleAlert) {
        [self.contentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;//centerX
        [self.contentView.widthAnchor constraintEqualToConstant:270].active = YES;//width
        [self.contentView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:-20.0].active = YES;// <=bottom
        [self.contentView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;//centerY
    } else {
        [self.contentView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
        [self.contentView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10].active = YES;
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10].active = YES;//bottom
    }
    
    //scrollView
    [self.scrollView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;//top
    [self.scrollView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:20].active = YES;//left
    [self.scrollView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-20].active = YES;//right
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.stackView.topAnchor].active = YES;
    //scrollContentView
    [self.scrollContentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = YES;//top
    [self.scrollContentView.leftAnchor constraintEqualToAnchor:self.scrollView.leftAnchor].active = YES;//left
    [self.scrollContentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;//bottom
    [self.scrollContentView.rightAnchor constraintEqualToAnchor:self.scrollView.rightAnchor].active = YES;//right
    [self.scrollContentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor].active = YES;//width
    NSLayoutConstraint *contentViewHeight = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollContentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(_actionList.count > 2?_actionList.count:1)*44.5];
    contentViewHeight.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:contentViewHeight];
    //titleLabel
    [self.titleLabel.leftAnchor constraintEqualToAnchor:self.scrollContentView.leftAnchor].active = YES;//left
    [self.titleLabel.rightAnchor constraintEqualToAnchor:self.scrollContentView.rightAnchor].active = YES;//right
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.scrollContentView.topAnchor constant:20.0].active = YES;//top
    //messageLabel
    [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5].active = YES;
    [self.messageLabel.leftAnchor constraintEqualToAnchor:self.scrollContentView.leftAnchor].active = YES;
    [self.messageLabel.rightAnchor constraintEqualToAnchor:self.scrollContentView.rightAnchor].active = YES;
    [self.messageLabel.bottomAnchor constraintEqualToAnchor:self.scrollContentView.bottomAnchor constant:-20].active = YES;
    //stackView
    [self.stackView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;//left
    [self.stackView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;//right
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;//bottom
    if (_actionList.count <= 2) {
        [self.stackView.heightAnchor constraintEqualToConstant:44.0].active = YES;//height
    }
    //lineView
    [self.lineView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;//left
    [self.lineView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;//right
    [self.lineView.bottomAnchor constraintEqualToAnchor:self.stackView.topAnchor].active = YES;//bottom
    [self.lineView.heightAnchor constraintEqualToConstant:0.5].active = YES;//height
    
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

- (UIView *)createSeparatorView {
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor colorWithWhite:229.00/255.00 alpha:1.0];
    separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    return separatorView;
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
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.layer.cornerRadius = 10;
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
        _lineView = [self createSeparatorView];
    }
    return _lineView;
}

@end
