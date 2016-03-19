//
//  RFDataManager.m
//  MyWeatherApp
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RFDataManager.h"
#import "RFCityGroup.h"
#import "AFWeather.h"

@implementation RFDataManager

static NSArray *cityGroups = nil;

+(NSArray *)getCityGroups
{
   
    if (cityGroups == nil) {
        cityGroups = [[self alloc] parseAndGetCityGroups];
    }
    return cityGroups;
}

-(NSArray *)parseAndGetCityGroups
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups" ofType:@"plist"];
    NSArray *arrary = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *array2 = [NSMutableArray array];
    for (NSDictionary *dic in arrary) {
        RFCityGroup *cities = [RFCityGroup new];
        [cities setValuesForKeysWithDictionary:dic];
        [array2 addObject:cities];
    }
    NSArray *ary = [array2 copy];
    return ary;
}

+ (NSArray *)weatherFromJSON:(id)responseObj isHourly:(BOOL)isHourly
{
    NSArray *dailyArray=responseObj[@"data"][@"weather"];
    NSArray *hourlyArray=dailyArray[0][@"hourly"];
    
    NSMutableArray *hourlyMutableArray = [NSMutableArray array];
    NSMutableArray *dailyMutableArray = [NSMutableArray array];

    if (isHourly) {
        //返回每小时的数据(数组)
        for (NSDictionary *hourlyDic in hourlyArray) {
            //hourlyDic -> TRWeather(解析)
            AFWeather *hourly = [AFWeather weatherFromHourlyDic:hourlyDic];
            [hourlyMutableArray addObject:hourly];
        }
        
    } else {
        //返回每天的数据(数组)
        for (NSDictionary *dailyDic in dailyArray) {
            AFWeather *daily = [AFWeather weatherFromDailyDic:dailyDic];
            [dailyMutableArray addObject:daily];
        }
    }
    return isHourly ? [hourlyMutableArray copy] : [dailyMutableArray copy];
}


@end
