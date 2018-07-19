//
//  ViewController.m
//  LJAlertController
//
//  Created by 刘俊杰 on 2018/7/19.
//  Copyright © 2018年 LJ. All rights reserved.
//

#import "ViewController.h"
#import "LJAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertButton setTitle:@"弹出" forState:UIControlStateNormal];
    alertButton.frame = CGRectMake(100, 100, 200, 50);
    alertButton.layer.cornerRadius = 10;
    alertButton.backgroundColor = [UIColor greenColor];
    [alertButton addTarget:self action:@selector(alertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertButton];
    
    //
    
    UIButton *ysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ysBtn setTitle:@"原生弹出" forState:UIControlStateNormal];
    ysBtn.frame = CGRectMake(100, 200, 200, 50);
    ysBtn.layer.cornerRadius = 10;
    ysBtn.backgroundColor = [UIColor redColor];
    [ysBtn addTarget:self action:@selector(ysButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ysBtn];
    
}

-(void)alertButtonAction:(UIButton *)sender{
    LJAlertController *controller = [LJAlertController alertControllerWithTitle:@"标题标题标题标题标题标题标题标题标题" message:@"这里是消息这里是消息这里是消息这里是消息这里是消息息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息"];
    LJAlertAction *action1 = [LJAlertAction actionWithTitle:@"取消" handler:^(LJAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    LJAlertAction *action2 = [LJAlertAction actionWithTitle:@"确定" handler:^(LJAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    [controller addAction:action1];
    [controller addAction:action2];
    
    [self presentViewController:controller animated:YES completion:^{
    }];
    
}

-(void)ysButtonAction:(UIButton *)sender{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"标题标题标题标题标题标题标题标题标题" message:@"这里是消息这里是消息这里是消息这里是消息这里是消息这息这里是消息这里是消息这里是消息这里是消息这里是消息这里是消息消息这里是消息这里是消息" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:^{
    }];
    
    
}

@end
