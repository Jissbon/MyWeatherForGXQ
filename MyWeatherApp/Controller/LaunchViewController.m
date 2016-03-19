//
//  LaunchViewController.m
//  启动页面与欢迎页面
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LaunchViewController.h"
#import "RFMainViewController.h"
@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view.frame = frame;
    UIImageView *backgroundImageView = [UIImageView new];
    backgroundImageView.frame = frame;
    backgroundImageView.image = [UIImage imageNamed:@"启动页"];
    backgroundImageView.contentMode =  UIViewContentModeScaleAspectFit;
    [self.view addSubview:backgroundImageView];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(changeView) withObject:self afterDelay:2];
}

//切换到下一个界面
- (void)changeView {
    UIWindow *window = self.view.window;
    RFMainViewController *main = [[RFMainViewController alloc] init];
    //添加一个缩放效果
    main.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.1 animations:^{
        main.view.transform = CGAffineTransformIdentity;
    }];
    
    window.rootViewController = main;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
