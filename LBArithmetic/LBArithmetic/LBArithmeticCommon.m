//
//  LBArithmeticCommon.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/30.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "LBArithmeticCommon.h"

@implementation LBArithmeticCommon

+ (void)lb_combinationWithArray:(NSArray *)array n:(int)n m:(int)m outArray:(NSArray **)outArray {
    if (n < m) return;
    
    static NSMutableArray *_resultArray = nil;
    static NSMutableArray *_tmpArray = nil;
    if (!_resultArray) {
        _resultArray = [NSMutableArray arrayWithCapacity:0];
        if (m == 0) return;
    }
    if (!_tmpArray) {
        _tmpArray = [NSMutableArray arrayWithCapacity:m];
        for (int i = 0; i < m; i++) {
            [_tmpArray addObject:@0];
        }
    }
    if (m == 0) {
        [_resultArray addObject:_tmpArray.copy];
        if ([_tmpArray.lastObject isEqual:array[_tmpArray.count-1]]) {
            *outArray = _resultArray.copy;
            [_resultArray removeAllObjects];
            _resultArray = nil;
            [_tmpArray removeAllObjects];
            _tmpArray = nil;
        }
        return;
    }
    for (int i = n; i >= m; --i) {
        [_tmpArray replaceObjectAtIndex:m-1 withObject:array[i-1]];
        [self lb_combinationWithArray:array n:i-1 m:m-1 outArray:outArray];
    }
    
}
+ (void)lb_combinationsWithArray:(NSArray *)array outArray:(NSArray **)outArray {
    NSMutableArray *_resultArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < array.count; i++) {
        NSArray *arr;
        [self lb_combinationWithArray:array n:(int)array.count m:i outArray:&arr];
        if (arr.count > 0) {
            [_resultArray addObjectsFromArray:arr];
        }
    }
    *outArray = _resultArray.copy;
}
@end

@implementation NSArray (LBArithmeticCommon)

- (NSArray *)lb_combinationWithCount:(NSUInteger)count {
    NSArray *resultArray;
    [LBArithmeticCommon lb_combinationWithArray:self n:(int)self.count m:(int)count outArray:&resultArray];
    return resultArray;
}
- (NSArray *)lb_combinations {
    NSArray *resultArray;
    [LBArithmeticCommon lb_combinationsWithArray:self outArray:&resultArray];
    return resultArray;
}
@end
