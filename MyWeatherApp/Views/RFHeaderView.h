//
//  RFHeaderView.h
//  MyWeatherApp
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFHeaderView : UIView

@property (nonatomic,strong) UIButton *selectedCityButton;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *conditionLabel;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UILabel *hiloLabel;

@end
