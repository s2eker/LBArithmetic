//
//  LBArithmeticTests.m
//  LBArithmeticTests
//
//  Created by 李兵 on 2018/8/18.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LBArithmetic.h"

@interface LBArithmeticTests : XCTestCase

@end

@implementation LBArithmeticTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_combination {
    int n = 10, m = 5;
    NSMutableArray *outArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < n; i++) {
        [arr addObject:@(i)];
    }
    [LBArithmetic lb_combinationWithArray:arr outCount:m outArray:&outArr];
    NSLog(@"out array:%ld", outArr.count);
}



@end
