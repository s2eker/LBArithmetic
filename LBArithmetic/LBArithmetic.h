//
//  LBArithmetic.h
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^LBArithmeticCondition)(NSDictionary *dic);

@interface LBArithmetic : NSObject

/**
 组合算法：C(n,m),n个元素中抽取m个进行组合

 @param array n个元素数组
 @param m 抽取的个数，取值范围：[1,n]
 @param outArray 全组合的输出数组：@[@[obj1,...,objm],...]
 */
+ (void)lb_combinationWithArray:(NSArray *)array outCount:(int)m outArray:(NSArray **)outArray;


/**
 SKU算法：一种商品有多种属性，每种属性又有不同的属性值，给定一个SKU数组，过滤出符合条件的属性值

 @param kinds 商品属性数组，格式：[{@"a":[a1,a2,a3]},{@"b":[b1,b2,b3]}...]，or[[a1,a2,a3],[b1,b2,b3]...]
 @param selectedKinds 选中的属性组合，格式：[a1,b1...]
 @param skus 单品数组，格式：[{"sku1":{dic}},{"sku2":{dic}}...]
 @param ignoreErrorSku 是否忽略异常的sku数据，YES->有异常的忽略掉；NO->发现异常就终止, default is YES
 @param seperator sku的分隔符
 @param condition 过滤的条件:dic对应skus中的dic
 @return 过滤后的属性集合，如(a1,a2,b1,b2)
 */
+ (NSSet *)lb_skuWithKinds:(NSArray *)kinds
             selectedKinds:(NSArray *)selectedKinds
                      skus:(NSArray *)skus
            ignoreErrorSku:(BOOL)ignoreErrorSku
                 seperator:(NSString *)seperator
                 condition:(LBArithmeticCondition)condition;

@end
