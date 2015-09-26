//
//  LocationService.m
//  hztour-iphone
//
//  Created by liu ding on 12-1-4.
//  Copyright 2012年 teemax. All rights reserved.
//

#import "SCLocationService.h"
#import "JSONKit.h"
#import "SCSysconfig.h"
#import "SCAppCache.h"

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

@implementation SCLocationService

+(void)requestLocationByAddress:(NSString *)address complete:(void (^)(CLLocation *))completeHandle{
    SCBaseService *base=[[SCBaseService alloc] init];
    base.urlStr=@"http://api.map.baidu.com/geocoder/v2/?";
    [base addParamByKey:@"address" value:address];
    [base addParamByKey:@"output" value:@"json"];
    [base addParamByKey:@"ak" value:[SCSysconfig baiduAppKey]];
    [base request:^(NSString *response, NSString *error) {
        if([response isNotEmpty]){
            NSDictionary *responseDic=[response objectFromJSONString];
            NSDictionary *resultDic=[responseDic objectForKey:@"result"];
            NSDictionary *locationDic=[resultDic objectForKey:@"location"];
            if([locationDic isNotEmpty]){
                double lat=[[locationDic objectForKey:@"lat"] doubleValue];
                double lon=[[locationDic objectForKey:@"lng"] doubleValue];
                CLLocationCoordinate2D bd=CLLocationCoordinate2DMake(lat, lon);
                CLLocationCoordinate2D gcj=[self GCJFromBD:bd];
                CLLocation *location=[[CLLocation alloc] initWithLatitude:gcj.latitude longitude:gcj.longitude];
                if(completeHandle){
                    completeHandle(location);
                    return ;
                }
            }
        }
        if(completeHandle){
            completeHandle(nil);
        }
    }];
}

+(void)requestAddressByLocation:(CLLocation *)location complete:(void (^)(NSString *))completeHandle{
    SCBaseService *base=[[SCBaseService alloc] init];
    base.urlStr=@"http://api.map.baidu.com/geocoder/v2/?";
    NSString *locationStr=[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    [base addParamByKey:@"ak" value:[SCSysconfig baiduAppKey]];
    [base addParamByKey:@"location" value:locationStr];
    [base addParamByKey:@"output" value:@"json"];
    [base addParamByKey:@"coordtype" value:@"gcj02ll"];
    [base request:^(NSString *response, NSString *error) {
        if([response isNotEmpty]){
            NSDictionary *responseDic=[response objectFromJSONString];
            NSDictionary *resultDic=[responseDic objectForKey:@"result"];
            NSString *address=[resultDic objectForKey:@"formatted_address"];
            if([address isNotEmpty] && completeHandle){
                completeHandle(address);
                return ;
            }
        }
        if(completeHandle){
            completeHandle(nil);
        }
    }];
}

+(CLLocationCoordinate2D)GCJFromBD:(CLLocationCoordinate2D)coordinate{
    double bdLat=coordinate.latitude;
    double bdLon=coordinate.longitude;
    
    double x=bdLon-0.0065,y=bdLat-0.006;
    double z=sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);

    double lon=z*cos(theta);
    double lat=z*sin(theta);
    return CLLocationCoordinate2DMake(lat, lon);
}

+(CLLocationCoordinate2D)BDFromGCJ:(CLLocationCoordinate2D)coordinate{
    double ggLat=coordinate.latitude;
    double ggLon=coordinate.longitude;
    
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double lon = z * cos(theta) + 0.0065;
    double lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(lat, lon);
}

+(CLLocationCoordinate2D)GCJFromWGS:(CLLocationCoordinate2D)wgsLoc{
    CLLocationCoordinate2D adjustLoc;
    double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    double radLat = wgsLoc.latitude / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    adjustLoc.latitude = wgsLoc.latitude + adjustLat;
    adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    return adjustLoc;

}

+(double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+(double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

@end
