//
//  RFDataManager.h
//  MyWeatherApp
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFDataManager : NSObject

+(NSArray *)getCityGroups;

+(NSArray *)weatherFromJSON:(id)responseObj isHourly:(BOOL)isHourly;

@end
