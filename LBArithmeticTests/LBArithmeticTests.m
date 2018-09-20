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
    NSLog(@"---------------------分割线---------------------");
    int n = 20, m = 5, measured = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < n; i++) {
        [arr addObject:@(i)];
    }
    if (measured) {
        [self measureBlock:^{
            NSArray *res = [arr lb_combinationWithCount:m];
            NSLog(@"[%d] %s %ld", __LINE__, __func__, res.count);
        }];
    }else {
        NSArray *res = [arr lb_combinationWithCount:m];
        NSLog(@"[%d] %s %@ %ld", __LINE__, __func__, res, res.count);
    }
}
- (void)test_sku {
//    NSArray *kinds1 = @[@{@"a":@[@11, @12]},
//                        @{@"b":@[@21, @22, @23]},
////                        @{@"c":@[@31, @32, @33, @34]},
////                        @{@"d":@[@41, @42, @43, @44, @45]},
//                        ];
    NSArray *kinds2 = @[@[@11, @12],
                        @[@21, @22, @23],
//                        @[@31, @32, @33, @34],
//                        @[@41, @42, @43, @44, @45],
                        ];
    NSArray *selectedKinds = @[@11, @21];
    NSArray *skus = @[
                      @{@"11|21":@{@"price":@10,@"number":@9}},
//                      @{@"11|22":@{@"price":@9,@"number":@8}},
//                      @{@"11|23":@{@"price":@8,@"number":@0}},
//                      @{@"12|21":@{@"price":@7,@"number":@6}},
//                      @{@"12|22":@{@"price":@6,@"number":@5}},
//                      @{@"12|23":@{@"price":@6,@"number":@0}},
                      ];
    NSSet *set = [LBArithmetic lb_skuWithKinds:kinds2 selectedKinds:selectedKinds skus:skus ignoreErrorSku:YES seperator:@"|" condition:^BOOL(NSDictionary *dic) {
        return [dic[@"number"] integerValue] > 0;
    }];
    NSLog(@"test_sku sku:%@", set);
}



@end
