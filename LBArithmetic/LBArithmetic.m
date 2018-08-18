//
//  LBArithmetic.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "LBArithmetic.h"

@implementation LBArithmetic

#pragma mark - Public
+ (void)lb_combinationWithArray:(NSArray *)array outCount:(int)m outArray:(NSMutableArray **)outArray {
    NSAssert(m > 0 && m <= array.count, @"!!! m取值超出范围\"[1,%lu]\",\"m=%d\"", [array count], m);
    [self __lb_combinationWithArray:array inCount:array.count outCount:m outArray:outArray];
}

#pragma mark - Private
+ (void)__lb_combinationWithArray:(NSArray *)array inCount:(NSUInteger)n outCount:(int)m outArray:(NSMutableArray **)outArray {
    static NSMutableArray *__resultArray = nil;
    static NSMutableArray *__tmpArray = nil;
    if (!__resultArray) {
        __resultArray = [NSMutableArray arrayWithCapacity:0];
    }
    if (!__tmpArray) {
        __tmpArray = [NSMutableArray arrayWithCapacity:m];
        for (int i = 0; i < m; i++) {
            [__tmpArray addObject:@0];
        }
    }
    if (m == 0) {
        [__resultArray addObject:__tmpArray.copy];
        if ([__tmpArray.lastObject isEqual:array[__tmpArray.count-1]]) {
            *outArray = __resultArray.mutableCopy;
            [__resultArray removeAllObjects];
            __resultArray = nil;
            [__tmpArray removeAllObjects];
            __tmpArray = nil;
        }
        return;
    }
    for (int i = (int)n; i >= m; --i) {
        [__tmpArray replaceObjectAtIndex:m-1 withObject:array[i-1]];
        [self __lb_combinationWithArray:array inCount:i-1 outCount:m-1 outArray:outArray];
    }
}

@end
