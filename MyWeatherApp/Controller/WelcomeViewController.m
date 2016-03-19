//
//  WelcomeViewController.m
//  MyWeatherApp
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RFMainViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>
//创建小圆点控件
@property (nonatomic,strong)UIPageControl *pc;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     UIScrollView *sv = [UIScrollView new];
     sv.delegate = self;//滑动视图设置代理
     sv.bounces = NO;
     sv.showsHorizontalScrollIndicator = NO;
     sv.showsHorizontalScrollIndicator = NO;
     sv.pagingEnabled = YES;
     sv.frame = self.view.bounds;
     sv.contentSize = CGSizeMake(sv.bounds.size.width*4, sv.bounds.size.height);
    for(NSInteger i=0;i<4;i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(sv.bounds.size.width*i, 0, sv.bounds.size.width, sv.bounds.size.height);
        NSString *imagename=[NSString stringWithFormat:@"%ld",i+1];
        imageView.image = [UIImage imageNamed:imagename];
        //如果是最后一个imageView,则添加一个按钮
        if (i==3)
        {
            [self setupEnterButton:imageView];
        }
        [sv addSubview:imageView];
    }
    [self.view addSubview:sv];
    [self setuppagecontrol];
}

//在最后一页配置点击进入程序的按钮
-(void)setupEnterButton:(UIImageView *)iv
{
    //打开iv的用户交互功能
    iv.userInteractionEnabled = YES;
    //创建按钮
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake((iv.bounds.size.width-100)/2, (iv.bounds.size.height*0.6), 100, 40);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"进入" forState:UIControlStateNormal];
    //配置按钮的边缘
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.cornerRadius = 10;
    
    //给按钮添加点击时间
    [button addTarget:self action:@selector(clickEnterAppButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [iv addSubview:button];
}

-(void)clickEnterAppButton:(UIButton *)btn
{
    RFMainViewController *mainvc = [[RFMainViewController alloc]init];
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    window.rootViewController = mainvc;//更换根视图
}

//定制屏幕下方的圆点
-(void)setuppagecontrol
{
    //创建pagecontroller
    UIPageControl *pagecontrol = [[UIPageControl alloc]init];
    self.pc = pagecontrol;
    //设置frame
    pagecontrol.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 30);
    //设置点的个数
    pagecontrol.numberOfPages = 4;
    //设置颜色
    pagecontrol.pageIndicatorTintColor = [UIColor blackColor];
    //设置选中的那个圆点的颜色
    pagecontrol.currentPageIndicatorTintColor = [UIColor redColor];
    //设置某个圆点被选中
    //pagecontrol.currentPage =2;
    //设置圆点不能与用户交互,用户不同通过点击选中一个圆点
    pagecontrol.userInteractionEnabled = NO;
    //添加到控制器的view中
    [self.view addSubview:pagecontrol];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //让选中的小圆点的位置雨imageview里面的图片的位置一致
    CGPoint point = scrollView.contentOffset;
    self.pc.currentPage = (point.x+160)/self.view.bounds.size.width;
    self.pc.currentPage = round(point.x/self.view.bounds.size.width);
//    NSLog(@"%@",NSStringFromCGPoint(point));
}
- (UIPageControl *)pc {
	if(_pc == nil) {
		_pc = [[UIPageControl alloc] init];
	}
	return _pc;
}

@end
