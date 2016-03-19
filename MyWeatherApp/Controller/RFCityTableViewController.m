//
//  RFCityTableViewController.m
//  MyWeatherApp
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RFCityTableViewController.h"
#import "RFDataManager.h"
#import "RFCityGroup.h"

@interface RFCityTableViewController ()

@property (nonatomic,strong) NSArray *cityGroups;//所有城市分组的数组;

@end

@implementation RFCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"城市列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(selfdismiss)];
    
}
-(void)selfdismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray *)cityGroups{
    if (_cityGroups == nil) {
        _cityGroups = [RFDataManager getCityGroups];
    }
    return _cityGroups;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RFCityGroup *cg = self.cityGroups[section];
    return cg.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    RFCityGroup *cg = self.cityGroups[indexPath.section];
    cell.textLabel.text =cg.cities[indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    RFCityGroup *cg = self.cityGroups[section];
    return cg.title;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFCityGroup *cg = self.cityGroups[indexPath.section];
    NSString *cityname = cg.cities[indexPath.row];
    self.ChangeCityblock(cityname);
    [self selfdismiss];
}

@end
