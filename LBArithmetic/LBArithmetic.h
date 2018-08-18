//
//  LBArithmetic.h
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBArithmetic : NSObject

//排列：A(n,m)


/**
 组合：C(n,m),n个元素中抽取m个进行组合

 @param array n个元素数组
 @param m 抽取的个数，取值范围：[1,n]
 @param outArray 全组合的输出数组：@[@[obj1,...,objm],...]
 */
+ (void)lb_combinationWithArray:(NSArray *)array outCount:(int)m outArray:(NSMutableArray **)outArray;

//SKU


@end
