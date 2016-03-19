//
//  RFHeaderView.m
//  MyWeatherApp
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RFHeaderView.h"
#import "Masonry.h"
#import "UILabel+TRLabel.h"

static CGFloat statusBarheight = 20;
static CGFloat labelHeight = 40;
static CGFloat tempHeight = 110;
static CGFloat margin = 20;


@implementation RFHeaderView

-(id)initWithFrame:(CGRect)frame
{
    
    //@property (nonatomic,strong) UIButton *selectedCityButton;
    //@property (nonatomic,strong) UILabel *cityLabel;
    //@property (nonatomic,strong) UIImageView *iconView;
    //@property (nonatomic,strong) UILabel *conditionLabel;
    //@property (nonatomic,strong) UILabel *temperatureLabel;
    //@property (nonatomic,strong) UILabel *hiloLabel;
    //字体版本:www.iosfonts.com
    
    if (self = [super initWithFrame:frame])
    {
//        //按钮
//        CGRect cityButtonFrame = CGRectMake(0, statusBarheight, 2*labelHeight, labelHeight);
//        self.selectedCityButton = [[UIButton alloc]initWithFrame:cityButtonFrame];
//        [self.selectedCityButton setTitle:@"City" forState:UIControlStateNormal];
//        self.selectedCityButton.titleLabel.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:20];
//        [self addSubview:self.selectedCityButton];
//        
//        //请求的城市
//        CGRect cityLabelFrame = CGRectMake(self.selectedCityButton.bounds.size.width,statusBarheight, frame.size.width - 3*labelHeight, labelHeight);
//        self.cityLabel = [UILabel labelWithFrame:cityLabelFrame];
//        self.cityLabel.text = @"loading...";
//        self.cityLabel.textAlignment = NSTextAlignmentLeft;//文字居左
//        self.cityLabel.backgroundColor = [UIColor colorWithWhite:2 alpha:0.5];
//        [self addSubview:self.cityLabel];
//        
//        //最高温最低温
//        CGRect hiloLabelFrame = CGRectMake(margin, frame.size.height-2*labelHeight,frame.size.width-2*margin, labelHeight);
//        self.hiloLabel = [UILabel labelWithFrame:hiloLabelFrame];
//        self.hiloLabel.text =@"0°C/0°C";
//        [self addSubview:self.hiloLabel];
//        
//        //当前温度
//        CGRect temperatureLabelFrame = CGRectMake(margin,frame.size.height-2*labelHeight-tempHeight,frame.size.width-margin,tempHeight);
//        self.temperatureLabel = [UILabel labelWithFrame:temperatureLabelFrame];
//        self.temperatureLabel.text = @"0°C";
//        self.temperatureLabel.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:60];
//        [self addSubview:self.temperatureLabel];
//        
//        //当天天气图标
//        CGRect iconViewFrame = CGRectMake(margin,frame.size.height-3*labelHeight-tempHeight, labelHeight, labelHeight);
//        UIImageView *iconView = [[UIImageView alloc]initWithFrame:iconViewFrame];
//        iconView.image = [UIImage imageNamed:@"placeholder.png"];
//        [self addSubview:iconView];
//        
//        //当天天气描述
//        CGRect conditionsLabelFrame = CGRectMake(2*margin+labelHeight,frame.size.height-3*labelHeight-tempHeight,frame.size.width-margin-labelHeight,labelHeight);
//        self.conditionLabel = [UILabel labelWithFrame:conditionsLabelFrame];
//        self.conditionLabel.text = @"天气描述";
//        [self addSubview:self.conditionLabel];
        
        //提示:传进来的frame是整个屏幕的frame
        CGRect cityButtonFrame = CGRectMake(0, statusBarheight, 2*labelHeight, labelHeight);
        self.selectedCityButton = [[UIButton alloc] initWithFrame:cityButtonFrame];
        [self.selectedCityButton setTitle:@"City" forState:UIControlStateNormal];
        self.selectedCityButton.titleLabel.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:20];
        [self addSubview:self.selectedCityButton];
        
        
        CGRect cityLabelFrame = CGRectMake(self.selectedCityButton.bounds.size.width, statusBarheight, frame.size.width-3*labelHeight, labelHeight);
        self.cityLabel = [UILabel labelWithFrame:cityLabelFrame];
        self.cityLabel.textAlignment =  NSTextAlignmentCenter;
        self.cityLabel.text = @"Loading...";
        [self addSubview:self.cityLabel];
        self.cityLabel.backgroundColor = [UIColor colorWithWhite:2 alpha:0.5];
        
        //最低最高Label
        CGRect hiloLabelRect = CGRectMake(margin, frame.size.height-2*labelHeight, frame.size.width-2*margin, labelHeight);
        self.hiloLabel = [UILabel labelWithFrame:hiloLabelRect];
        self.hiloLabel.text =@"0°C/0°C";
        [self addSubview:self.hiloLabel];
        
        //当前温度
         CGRect temperatureLabelFrame = CGRectMake(margin,frame.size.height-2*labelHeight-tempHeight,frame.size.width-margin,tempHeight);
        self.temperatureLabel = [UILabel labelWithFrame:temperatureLabelFrame];
        self.temperatureLabel.text = @"0℃";
        self.temperatureLabel.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:60];
        [self addSubview:self.temperatureLabel];
        
        //天气iconView
        CGRect iconViewRect = CGRectMake(margin, temperatureLabelFrame.origin.y-labelHeight, labelHeight, labelHeight);
        self.iconView = [[UIImageView alloc] initWithFrame:iconViewRect];
        self.iconView.image = [UIImage imageNamed:@"placeholder.png"];
        [self addSubview:self.iconView];
        
        //天气描述
        CGRect conditionRect = CGRectMake(margin+labelHeight, iconViewRect.origin.y, frame.size.width-2*margin-labelHeight, labelHeight);
        self.conditionLabel = [UILabel labelWithFrame:conditionRect];
        self.conditionLabel.text = @"Sunny";
        [self addSubview:self.conditionLabel];
    }
    return self;
}

@end
