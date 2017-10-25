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
    NSLog(@"%@",SCApplication.bundleIdentifier);
    XCTAssertNotNil(SCApplication.infoDictionary);
    NSLog(@"%@", SCApplication.infoDictionary);
    
    XCTAssertNotNil(SCApplication.CTCarrier);
    XCTAssertNotNil(SCApplication.networkType);
    
    XCTAssertNotNil(SCApplication.bundleIdentifier);
    XCTAssertNotNil(SCApplication.version);
    XCTAssertNotNil(SCApplication.buildNumber);
    XCTAssertNotNil(SCApplication.displayName);
}

@end
