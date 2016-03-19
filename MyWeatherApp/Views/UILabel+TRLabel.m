//
//  UILabel+TRLabel.m
//  Demo3-TRWeatherForecast
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UILabel+TRLabel.h"

@implementation UILabel (TRLabel)

+(UILabel *)labelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:20];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    return label;
}
@end
