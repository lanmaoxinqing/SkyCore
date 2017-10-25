//
//  RequestTests.m
//  SkyCoreTests
//
//  Created by sky on 2017/10/21.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCApplication.h"

@interface RequestTests : XCTestCase

@end

@implementation RequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expect = [self expectationWithDescription:@""];
    MZBaseRequest *request = [[MZBaseRequest alloc] init];
    request.path = @"http://www.baidu.com";
    [request startWithBlock:^(__kindof MZBaseRequest *request, NSError *error) {
        if (!request.response.responseData && error) {
            XCTAssert(error.localizedDescription);
        }
        [expect fulfill];
    }];
    
    
    
    [self waitForExpectationsWithTimeout:request.timeout handler:^(NSError * _Nullable error) {
        if (error) {
            XCTAssert(error.localizedDescription);
        }
    }];

}

- (void)testBlacklist {
    
    XCTestExpectation *expect = [self expectationWithDescription:@""];

    UIViewController *vc = [UIViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self waitForExpectationsWithTimeout:15 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTAssert(error.localizedDescription);
        }
    }];

}


@end
