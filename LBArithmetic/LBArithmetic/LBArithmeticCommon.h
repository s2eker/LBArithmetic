//
//  LBArithmeticCommon.h
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/30.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBArithmeticCommon : NSObject
/**
 C(n,m)
 */
+ (void)lb_combinationWithArray:(NSArray *)array n:(int)n m:(int)m outArray:(NSArray **)outArray;


/**
 C(n,0)+...C(n,n)
 */
+ (void)lb_combinationsWithArray:(NSArray *)array outArray:(NSArray **)outArray;


@end


@interface NSArray (LBArithmeticCommon)
#pragma mark -- 组合

/**
 C(n,m)
 */
- (NSArray *)lb_combinationWithCount:(NSUInteger)count;


/**
 C(n,0)+...C(n,n)
 */
- (NSArray *)lb_combinations;
@end
