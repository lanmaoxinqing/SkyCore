//
//  StringTests.m
//  SkyCoreTests
//
//  Created by 心情 on 2017/10/18.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SkyCore/SkyCore.h>

@interface StringTests : XCTestCase

@end

@implementation StringTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCover {
    NSString *str = @"01234567890123456789";
    NSString *cover = @"*";
    NSRange range = NSMakeRange(0, 1);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"*1234567890123456789");
    
    cover = @"?*";
    range = NSMakeRange(0, 1);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"?1234567890123456789");

    cover = @"?*";
    range = NSMakeRange(0, 2);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"?*234567890123456789");

    cover = @"?*";
    range = NSMakeRange(0, 3);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"?*?34567890123456789");
    
    cover = @"??????????";
    range = NSMakeRange(19, 4);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"0123456789012345678?");
    
    cover = @"??????????";
    range = NSMakeRange(30, 4);
    XCTAssertEqualObjects([str stringByCoverString:cover inRange:range], @"01234567890123456789");

}

@end
