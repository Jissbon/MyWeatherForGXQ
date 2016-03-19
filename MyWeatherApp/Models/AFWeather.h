//
//  AFWeather.h
//  MyWeatherApp
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFWeather : NSObject

@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *iconUrl;
@property (nonatomic,strong) NSString *weatherDesc;
@property (nonatomic,strong) NSString *tempC;
@property (nonatomic,strong) NSString *maxtempC;
@property (nonatomic,strong) NSString *mintempC;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *date;

+(id)weatherFromHourlyDic:(NSDictionary *)hourlyDic;
+(id)weatherFromDailyDic:(NSDictionary *)DailyDic;
+(id)weatherFromHeaderDic:(id)responseObj;
@end
