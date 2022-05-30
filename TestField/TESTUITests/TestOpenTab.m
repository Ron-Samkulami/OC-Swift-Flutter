//
//        TestOpenTab.m
 //       2022/3/10
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        

#import <XCTest/XCTest.h>

@interface TestOpenTab : XCTestCase

@end

@implementation TestOpenTab

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
//    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tabBars[@"Tab Bar"].buttons[@"\u5355\u5143\u6d4b\u8bd5"] tap];
    [app.staticTexts[@"\u8df3\u8f6c\u5230\u6d4b\u8bd5\u9875"] tap];
    [app.staticTexts[@"run (1000)"] tap];
    [app.staticTexts[@"run (100000)"] tap];
    [app.staticTexts[@"All Costs"] tap];
    
}


@end
