//
//  ApplicationTests.m
//  SkyCoreTests
//
//  Created by sky on 2017/10/13.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SkyCore/SkyCore.h>

@interface ApplicationTests : XCTestCase

@end

@implementation ApplicationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testApplication {
    
    XCTAssertNotNil(SCApplication.infoDictionary);
    NSLog(@"%@", SCApplication.infoDictionary);
    
    XCTAssertNotNil(SCApplication.CTCarrier);
    XCTAssertNotNil(SCApplication.networkType);
    
    XCTAssertNotNil(SCApplication.bundleIdentifier);
    XCTAssertNotNil(SCApplication.version);
    XCTAssertNotNil(SCApplication.buildNumber);
    XCTAssertNotNil(SCApplication.displayName);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
