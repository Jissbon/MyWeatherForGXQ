//
//  AFWeather.m
//  MyWeatherApp
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "AFWeather.h"


@implementation AFWeather
+(id)weatherFromHourlyDic:(NSDictionary *)hourlyDic
{
    return [[self alloc] initWithHourlyDic:hourlyDic];
}
-(id)initWithHourlyDic:(NSDictionary *)hourlyDic
{
    if (self = [super init]) {
        self.iconUrl = hourlyDic[@"weatherIconUrl"][0][@"value"];
        NSLog(@"%@",self.iconUrl);
        self.tempC =[NSString stringWithFormat:@"%@℃",hourlyDic[@"tempC"]];
        int time = [hourlyDic[@"time"] intValue]/100;
        self.time = [NSString stringWithFormat:@"%d:00", time];
    }
    return self;
}

+(id)weatherFromDailyDic:(NSDictionary *)dailyDic
{
    return [[self alloc] initWithDailyDic:dailyDic];
}

-(id)initWithDailyDic:(NSDictionary *)dailyDic
{
    if (self = [super init]) {
        self.maxtempC = [NSString stringWithFormat:@"%@℃",dailyDic[@"maxtempC"]];
        self.mintempC = [NSString stringWithFormat:@"%@℃",dailyDic[@"mintempC"]];
        self.date = dailyDic[@"date"];
        self.iconUrl = dailyDic[@"hourly"][0][@"weatherIconUrl"][0][@"value"];
    }
    return self;
}

+ (id)weatherFromHeaderDic:(id)responseObj{
    return [[self alloc]initWithHeaderDic:responseObj];
}
-(id)initWithHeaderDic:(id)responseObj{
    if (self = [super init]) {
        self.cityName = responseObj[@"data"][@"request"][0][@"query"];
        NSDictionary *currentDic = responseObj[@"data"][@"current_condition"][0];
        self.iconUrl = currentDic[@"weatherIconUrl"][0][@"value"];
        self.weatherDesc = currentDic[@"weatherDesc"][0][@"value"];
        self.tempC = [NSString stringWithFormat:@"%@˚C", currentDic[@"temp_C"]];
        self.maxtempC = [NSString stringWithFormat:@"%@˚", responseObj[@"data"][@"weather"][0][@"maxtempC"]];
        self.mintempC = [NSString stringWithFormat:@"%@˚",responseObj[@"data"][@"weather"][0][@"mintempC"]];
    }
    return self;
}







@end
