  //
//  UILabel+TRLabel.h
//  Demo3-TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TRLabel)

//给定一个frame,返回一个已经创建好的UILabel;
+(UILabel *)labelWithFrame:(CGRect)frame;

@end
