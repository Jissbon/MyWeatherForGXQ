//
//  RFMainViewController.m
//  MyWeatherApp
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RFMainViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "RFHeaderView.h"
#import "RFDataManager.h"
#import "RFCityTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "TSMessage.h"
#import "TSMessageView.h"
#import "AFWeather.h"
#import "UIImageView+WebCache.h"


@interface RFMainViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RFHeaderView *headerView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *userLocation;
@property (nonatomic,strong) NSArray *hourlyArray;//用于持有解析后的小时天气数据
@property (nonatomic,strong) NSArray *dailyArray;//用于持有解析后的每天的天气数据
@property (nonatomic,strong) CLGeocoder *geo;
@property (nonatomic,strong) NSString *selectedCityName;
@property (nonatomic,strong) NSString *selectedCityNameCN;
@property (nonatomic,assign) CLLocationCoordinate2D coordate2d;
@end

@implementation RFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableViewBackground];
    [self setupHeaderView];
    [self getuserLocation];
}



-(void)setupHeaderView
{
    CGRect frame = [[UIScreen mainScreen]bounds];
    self.headerView = [[RFHeaderView alloc]initWithFrame:frame];
    self.tableView.tableHeaderView = self.headerView;
    //头部视图的按钮点击事件
    [self.headerView.selectedCityButton addTarget:self action:@selector(changCity) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 切换城市的方法
-(void)changCity
{
    RFCityTableViewController *rv =[RFCityTableViewController new];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:rv];
    
    rv.ChangeCityblock = ^(NSString *cityname)
    {
        
        @synchronized(self)
        {
            self.headerView.cityLabel.text = cityname;
            self.selectedCityName = [self transformToPinYin:cityname];
            [self.geo geocodeAddressString:cityname completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *place = placemarks.lastObject;
                self.coordate2d = place.location.coordinate;
                 [self sendSelectedCityRrquestToServer];
            }];
        }
    };
    [self presentViewController:nv animated:YES completion:nil];
    
}

#pragma mark 汉字转拼音
-(NSString *)transformToPinYin:(NSString *)wordStr
{
    NSMutableString *mutableString = [NSMutableString stringWithString:wordStr];
    //带声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    //不带声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    NSString *str = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
    
}


#pragma 创建背景 与 tableView
-(void)setUpTableViewBackground
{
    CGRect bounds = [[UIScreen mainScreen]bounds];
    //背景
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    backgroundView.frame = bounds;
    [self.view addSubview:backgroundView];
    //模糊层
    UIImageView *blurredView = [[UIImageView alloc]initWithFrame:bounds];
    [blurredView setImageToBlur:[UIImage imageNamed:@"bg.png"] blurRadius:10 completionBlock:nil];
    blurredView.alpha = 0.5;
    [self.view addSubview:blurredView];
    //tableView
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pagingEnabled  = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:2 alpha:0];//可隐藏cell的分界线
    [self.view addSubview:self.tableView];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//可隐藏cell的分界线
}

//状态栏字体
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma 和定位相关的方
-(void)getuserLocation
{
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
}
//监听授权情况
 - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
            self.userLocation = nil;
            NSLog(@"不允许定位");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationManager.distanceFilter = 100;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}
//监听定位情况
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    self.userLocation = locations.lastObject;
    NSLog(@"locatons=%ld",locations.count);
    NSLog(@"%f,%f",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude);
    [self.geo reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error==nil) {
            CLPlacemark *place = placemarks.lastObject;
            self.headerView.cityLabel.text = place.addressDictionary[@"City"];
            self.selectedCityNameCN = place.addressDictionary[@"City"];
        }
    }];
    self.locationManager = nil;
    [self.locationManager stopUpdatingLocation];
    [self sendRrquestToServer];
}

#pragma 向服务器请求天气数据
-(void)sendRrquestToServer{
    //提示框设置弹出的所在视图
    [TSMessage setDefaultViewController:self];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr=[NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=3&key=92d43a25e06d5d255823bb3f02302",self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude];
    NSLog(@"%@",urlStr);
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        [TSMessage showNotificationWithTitle:@"请求天气数据成功" subtitle:@"正在为您返回天气数据" type:TSMessageNotificationTypeSuccess];
        //解析返回的数据
        self.hourlyArray=[RFDataManager weatherFromJSON:responseObject isHourly:YES];
        self.dailyArray=[RFDataManager weatherFromJSON:responseObject isHourly:NO];
        [self.tableView reloadData];
        [self updateHeaderVeiwWithData:responseObject];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //TSMessage显示消息给用户(用户不需要交互)
        [TSMessage showNotificationWithTitle:@"请求天气数据失败" subtitle:@"请查看网络是否正常连接" type:TSMessageNotificationTypeWarning];
    }];
}
-(void)sendSelectedCityRrquestToServer{
    //提示框设置弹出的所在视图
    [TSMessage setDefaultViewController:self];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr=[NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=3&key=92d43a25e06d5d255823bb3f02302",self.coordate2d.latitude, self.coordate2d.longitude];
    
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         [TSMessage showNotificationWithTitle:@"请求天气数据成功" subtitle:@"正在为您返回天气数据" type:TSMessageNotificationTypeSuccess];
         //解析返回的数据
         self.hourlyArray=[RFDataManager weatherFromJSON:responseObject isHourly:YES];
         self.dailyArray=[RFDataManager weatherFromJSON:responseObject isHourly:NO];
         [self.tableView reloadData];
         [self updateHeaderVeiwWithData:responseObject];
     } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         //TSMessage显示消息给用户(用户不需要交互)
         [TSMessage showNotificationWithTitle:@"请求天气数据失败" subtitle:@"请查看网络是否正常连接" type:TSMessageNotificationTypeWarning];
     }];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.hourlyArray.count+1;
    }else{
        return self.dailyArray.count+1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"每小时天气情况";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
        }else{
            AFWeather *Hourlyweather = self.hourlyArray[indexPath.row-1];
            [self configCell:cell withWeather:Hourlyweather isHourly:YES];
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"每天天气情况";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
        }else{
            AFWeather *dailyweather = self.dailyArray[indexPath.row-1];
            [self configCell:cell withWeather:dailyweather isHourly:NO];
        }
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return  [UIScreen mainScreen].bounds.size.height/rowCount;
    
}
#pragma mark - cell的设置
-(void)configCell:(UITableViewCell *)cell withWeather:(AFWeather *)weather isHourly:(BOOL)isHourly
{
    cell.textLabel.text = isHourly? weather.time : weather.date;
    NSString *str = [NSString stringWithFormat:@"%@℃/%@℃",weather.maxtempC,weather.mintempC];
    cell.detailTextLabel.text = isHourly? weather.tempC : str;
    [cell.imageView sd_setImageWithURL:[NSURL  URLWithString:weather.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

-(void)updateHeaderVeiwWithData:(id)reponseObj{
    AFWeather *weather = [AFWeather weatherFromHeaderDic:reponseObj];
//    self.headerView.cityLabel.text = weather.cityName;
    [self.headerView.iconView sd_setImageWithURL:[NSURL URLWithString:weather.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.headerView.conditionLabel.text = weather.weatherDesc;
    self.headerView.temperatureLabel.text = weather.tempC;
    self.headerView.hiloLabel.text = [NSString stringWithFormat:@"%@℃/%@℃", weather.mintempC, weather.maxtempC];
}

- (CLGeocoder *)geo {
	if(_geo == nil) {
		_geo = [[CLGeocoder alloc] init];
	}
	return _geo;
}

@end
