//
//  RFCityTableViewController.h
//  MyWeatherApp
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFCityTableViewController : UITableViewController

@property (nonatomic,copy) void (^ChangeCityblock)(NSString *cityname);

@end
