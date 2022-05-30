//
//  TESTTests.m
//  TESTTests
//
//  Created by 111 on 2020/9/18.
//

#import <XCTest/XCTest.h>

@interface TESTTests : XCTestCase

@end

@implementation TESTTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"---------setUP");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"---------tearDown");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"---------testExample");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
//        for (NSInteger i = 0; i < 1024; i++) {
//            NSLog(@"Test:%zd",i);
//        }
        NSLog(@"---------testPerformanceExample");
    }];
}


- (void)testDocumentOpening {
    //测试多个异步操作
    XCTestExpectation *documentOpenExpextation = [self expectationWithDescription:@"document open"];
    NSURL *docUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestDocument" withExtension:@"myDoc"];
    UIDocument *doc = [[UIDocument alloc] initWithFileURL:docUrl];
    [doc openWithCompletionHandler:^(BOOL success) {
        XCTAssert(success);
        // 对结果进行判断,进行处理或者抛出异常
        // 结束当前的expectation,该操作会触发 waitForExpectation 方法
        
        [documentOpenExpextation fulfill];//标记完成
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        [doc closeWithCompletionHandler:nil];
    }];
}

@end
