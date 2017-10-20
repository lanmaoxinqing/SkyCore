//
//  ObjectTests.m
//  SkyCoreTests
//
//  Created by 心情 on 2017/10/20.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ObjectTests : XCTestCase

@end

@implementation ObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSArray *arr = nil;
    XCTAssertFalse([arr sc_isNotNull]);
    XCTAssertFalse([arr sc_isNotEmpty]);

    arr = [NSArray array];
    XCTAssertTrue([arr sc_isNotNull]);
    XCTAssertFalse([arr sc_isNotEmpty]);
    
    arr = @[@"111"];
    XCTAssertTrue([arr sc_isNotNull]);
    XCTAssertTrue([arr sc_isNotEmpty]);
    
    NSString *str = nil;
    XCTAssertFalse([str sc_isNotNull]);
    XCTAssertFalse([str sc_isNotEmpty]);

    str = @"";
    XCTAssertTrue([str sc_isNotNull]);
    XCTAssertFalse([str sc_isNotEmpty]);
    
    str = @"111";
    XCTAssertTrue([str sc_isNotNull]);
    XCTAssertTrue([str sc_isNotEmpty]);
    
    XCTAssertEqualObjects([UILabel sc_classOfProperty:@"text"], [NSString class]);

}

@end
