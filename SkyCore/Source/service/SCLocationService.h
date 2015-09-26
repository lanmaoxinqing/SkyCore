//
//  LocationService.h
//  hztour-iphone
//
//  Created by liu ding on 12-1-4.
//  Copyright 2012年 teemax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 
#import "SCBaseService.h"
#import "SCSysconfig.h"

/**
	定位服务(纠偏,定位城市名称)
	@author sky
 */
@interface SCLocationService : NSObject {
    
}

/**
    地理位置->火星经纬度(GCJ-02)
    火星经纬度适用于大部分国内地图
    可通过[BDFromGCJ:]转换为百度经纬度(DB-09)
	@param address 地理位置
 */
+(void)requestLocationByAddress:(NSString *)address complete:(void (^)(CLLocation *location))completeHandle;

/**
    火星经纬度(GCJ-02)->地理位置,注意传入的经纬度需要为火星经纬度
    百度经纬度(BD-09)可以通过[GCJFromBD:]转换为火星经纬度(GCJ-02)
    真实经纬度(WGS-84)可以通过[GCJFromWGS:]转换为火星经纬度(GCJ-02)
	@param location GPS经纬度
 */
+(void)requestAddressByLocation:(CLLocation *)location complete:(void (^)(NSString *address))completeHandle;

/**
	百度经纬度->国标经纬度(火星经纬度)
	@param coordinate 百度经纬度
	@returns 国标经纬度
 */
+(CLLocationCoordinate2D)GCJFromBD:(CLLocationCoordinate2D)coordinate;
/**
	真实经纬度->国标经纬度(火星经纬度)
	@param coordinate 真实经纬度
	@returns 国标经纬度
 */
+(CLLocationCoordinate2D)GCJFromWGS:(CLLocationCoordinate2D)coordinate;

/**
	国标经纬度(火星经纬度)->百度经纬度
	@param coordinate 国标经纬度
	@returns 百度经纬度
 */
+(CLLocationCoordinate2D)BDFromGCJ:(CLLocationCoordinate2D)coordinate;

@end
