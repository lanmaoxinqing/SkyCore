//
//  exampleTests.m
//  exampleTests
//
//  Created by sky on 14/11/6.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SCFileOper.h"
#import "Test.h"

@interface exampleTests : XCTestCase

@end

@implementation exampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testUnzip{
    NSString *zipPath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.zip"];
    NSString *unzipPath=[SCSysconfig filePathByName:zipPath];
    [SCFileOper unzipFile:zipPath toDestinationPath:unzipPath password:@"1qaz2wsx" complete:^(BOOL result, NSString *unzipPath, NSError *error) {
        XCTAssert(result , @"解压失败");
        XCTAssert(!error,@"解压报错");
        XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:unzipPath],@"解压文件不存在");
    }];
}

-(void)testBaseService{
    XCTestExpectation *expect=[self expectationWithDescription:@""];
    SCBaseService *service=[[SCBaseService alloc] init];
    service.urlStr=@"http://122.224.174.181:81/";
    service.service=@"dataservice.asmx";
    service.method=@"AnalyseLocation";
    [service addParamByKey:@"longitude" value:@(120)];
    [service addParamByKey:@"latitude" value:@(30)];
    [service addParamByKey:@"type" value:@"grassinfo"];
    NSLog(@"%@",service.description);
    [service request:^(NSString *response, NSString *error) {
        NSLog(@"%@",response);
        [expect fulfill];
        XCTAssertNotNil(response , @"响应为空");
    }];
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

-(void)testProperty{
    Test *test=[Test new];
    [test enumPropertiesUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@",propertyName);
        if(idx>0){
            *stop=YES;
        }
    }];
}

-(void)testDomainDic{
    NSDictionary *dic=@{@"sid":@(1),
                        @"name":@"test",
                        @"value":@"aaabbbbccc"
                        };
    Test *test=[[Test alloc] initWithDictionary:dic];
    XCTAssertNotNil(test);
    XCTAssertEqual(test.sid, 1);
    XCTAssertEqual(test.name, @"test");
    XCTAssertEqual(test.value, @"aaabbbbccc");
}

-(void)testDomainCoding{
    NSDictionary *dic=@{@"sid":@(1),
                        @"name":@"test",
                        @"value":@"aaabbbbccc"
                        };
    Test *test=[[Test alloc] initWithDictionary:dic];
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:test];
    XCTAssertNotNil(data);
    Test *test2=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(test2);
    XCTAssertEqual(test.sid, 1);
    XCTAssertEqual(test.name, @"test");
    XCTAssertEqual(test.value, @"aaabbbbccc");
}


-(void)testStoreObj{
    Test *test1=[[Test alloc] init];
    test1.sid=1;
    test1.name=@"name1";
    test1.value=@"value1";
    
    Test *test2=[[Test alloc] init];
    test2.sid=2;
    test2.name=@"name2";
    test2.value=@"value2";

    Test *test3=[[Test alloc] init];
    test3.sid=3;
    test3.name=@"name3";
    test3.value=@"value3";

    NSArray *arr=@[test1,test2,test3];
    
    [SCAppCache setStoreObject:arr forKey:ObjectKeyMember];
    NSArray *result=(NSArray *)[SCAppCache storeObjectForKey:ObjectKeyMember];
    XCTAssertNotNil(result);
    XCTAssertEqual(arr.count, result.count);
}


@end
