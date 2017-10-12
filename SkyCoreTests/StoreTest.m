//
//  StoreTest.m
//  SkyCoreTests
//
//  Created by sky on 2017/10/12.
//  Copyright © 2017年 com.grassinfo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SkyCore/SkyCore.h>

@interface StoreTest : XCTestCase

@end

@implementation StoreTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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

- (void)testUserDefaults {
    NSString *key = @"test";
    [[SCStore defaultStore] ud_setObject:@"111" forKey:key];
    XCTAssert([[[SCStore defaultStore] ud_stringForKey:key] isEqualToString:@"111"]);
    
    [[SCStore defaultStore] ud_setObject:@100 forKey:key];
    XCTAssert([[SCStore defaultStore] ud_integerForKey:key] == 100);
    
    NSArray *arr = @[@"aaa", @"bbb"];
    [[SCStore defaultStore] ud_setObject:arr forKey:key];
    XCTAssert([[[SCStore defaultStore] ud_arrayForKey:key][0] isEqualToString:@"aaa"]);

    NSDictionary *dict = @{
                           @"key" : @"value"
                           };
    [[SCStore defaultStore] ud_setObject:dict forKey:key];
    XCTAssert([[[SCStore defaultStore] ud_dictionaryForKey:key][@"key"] isEqualToString:@"value"]);
    
    [[SCStore defaultStore] ud_setObject:@YES forKey:key];
    XCTAssert([[SCStore defaultStore] ud_boolForKey:key]);
}

@end
