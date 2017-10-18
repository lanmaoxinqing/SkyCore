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
    NSString *str = @"123456789123456789";
    NSString *cover = @"*";
    NSRange range = NSMakeRange(0, 1);
    XCTAssertEqualObjects([str stringByCoverLetter], <#expression2, ...#>)
}

@end
