//
//  LBArithmetic.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "LBArithmetic.h"

#define LBArithmeticLog(fmt,...)        NSLog(@"[%d]" fmt, __LINE__, ##__VA_ARGS__);
#define LBArithmeticLogErr(fmt, ...)    LBArithmeticLog(@"!!!"fmt, ##__VA_ARGS__)

#define LBIsEmptyArray(obj)  (![obj isKindOfClass:[NSArray class]] || obj.count <= 0)
#define LBIsNotArray(obj)    (![obj isKindOfClass:[NSArray class]])
typedef NS_ENUM(NSInteger, LBArithmeticErrorCode) {
    LBArithmeticValidateKindsError = 1000,
    LBArithmeticValidateSelectedKindsError,
    LBArithmeticValidateSkusError,
};

@interface LBArithmeticKindModel: NSObject
@property (nonatomic, copy)NSString *kind;
@property (nonatomic, assign)NSUInteger count;
@property (nonatomic, strong)id attribute;
@end
@implementation LBArithmeticKindModel
- (NSString *)description {
    return [NSString stringWithFormat:@"<%p> kind:%@ count:%lu attribute:%@", self, self.kind, self.count, self.attribute];
}
@end

@interface LBArithmeticSKUModel: NSObject
@property (nonatomic, strong)NSArray *sku;
@property (nonatomic, strong)NSDictionary *data;
- (BOOL)containedKinds:(NSArray *)kinds;
@end
@implementation LBArithmeticSKUModel
- (BOOL)containedKinds:(NSArray *)kinds {
    if (kinds.count <= 0) {
        return NO;
    }
    uint count = 0;
    NSString *a = nil;
    NSString *b = nil;
    for (LBArithmeticKindModel *m in kinds) {
        for (id obj in self.sku) {
            a = [NSString stringWithFormat:@"%@", obj];
            b = [NSString stringWithFormat:@"%@", m.attribute];
            if ([a isEqualToString:b]) {
                count++;
                break;
            }
        }
    }
    return count == kinds.count;
}
- (NSString *)description {
//    return [NSString stringWithFormat:@"<%p> sku:%@ data:%@", self, self.sku, self.data];
    return [NSString stringWithFormat:@"<%p> sku:%@", self, self.sku];
}
@end




@implementation LBArithmetic

#pragma mark - Public
+ (void)lb_combinationWithArray:(NSArray *)array outCount:(int)m outArray:(NSArray **)outArray {
    NSAssert(m > 0 && m <= array.count, @"!!! m取值超出范围\"[1,%lu]\",\"m=%d\"", [array count], m);
    [self __lb_combinationWithArray:array inCount:array.count outCount:m outArray:outArray];
}
+ (NSSet *)lb_skuWithKinds:(NSArray *)kinds
               selectedKinds:(NSArray *)selectedKinds
                      skus:(NSArray *)skus
            ignoreErrorSku:(BOOL)ignoreErrorSku
                 seperator:(NSString *)seperator
                 condition:(LBArithmeticCondition)condition {
    NSAssert([seperator isKindOfClass:[NSString class]], @"!!!分隔符不是字符串，无法进行sku算法");
    return [self __lb_skuWithKinds:kinds
                     selectedKinds:(NSArray *)selectedKinds
                              skus:skus
                    ignoreErrorSku:ignoreErrorSku
                         seperator:seperator
                         condition:condition];
}

#pragma mark - Private
+ (void)__lb_combinationWithArray:(NSArray *)array inCount:(NSUInteger)n outCount:(int)m outArray:(NSArray **)outArray {
    if (LBIsNotArray(array) || n > array.count || m > n) {
        LBArithmeticLogErr(@"参数异常")
        return;
    }
    static NSMutableArray *__resultArray = nil;
    static NSMutableArray *__tmpArray = nil;
    if (!__resultArray) {
        __resultArray = [NSMutableArray arrayWithCapacity:0];
        if (m == 0) return;
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
            *outArray = __resultArray.copy;
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
+ (NSSet *)__lb_skuWithKinds:(NSArray *)kinds
               selectedKinds:(NSArray *)selectedKinds
                        skus:(NSArray *)skus
              ignoreErrorSku:(BOOL)ignoreErrorSku
                   seperator:(NSString *)seperator
                   condition:(LBArithmeticCondition)condition {
    NSError *error = nil;
    //评估并整理kinds
    NSArray *__kinds = [self __lb_validateAndPackKinds:kinds error:&error];
    if (error) return nil;
    
    //评估并整理selectedKinds
    NSArray *__selectedKinds = [self __lb_validateAndPackSelectKinds:selectedKinds allKinds:__kinds error:&error];
    if (error) return nil;
    
    //评估并整理skus
    NSArray *__skus = [self __lb_validateAndPackSkus:skus
                                      ignoreErrorSku:ignoreErrorSku
                                           kindCount:__kinds.count
                                           seperator:seperator
                                           condition:condition
                                               error:&error];
    if (error) return nil;
    
    //如果skus为空，则认为所有属性都不可用
    if (skus.count <= 0) return [NSSet setWithArray:[__kinds valueForKey:@"attribute"]];
    
    //查找过滤属性
    NSMutableSet *__filteredAttributes = [NSMutableSet set];
    
    //获取所有组合[[C(n,m)],[C(n, m-1)]...[C(n,1)]]
    NSArray *__fullCombinations = [self __lb_getFullCombinationOfKinds:__selectedKinds];
    //过滤属性
    if (__fullCombinations.count > 0) {
        for (NSArray *arr in __fullCombinations) {
            NSSet *set = [self __lb_getMissedAttributeWithKinds:[self __lb_filterKinds:__kinds trimmingKinds:arr]
                                                           skus:[self __lb_filterSkus:__skus inKinds:arr]];
            if (set.count > 0) {
                [__filteredAttributes unionSet:set];
            }
        }
    }
    NSSet *set = [self __lb_getMissedAttributeWithKinds:__kinds skus:__skus];
    if (set.count > 0) {
        [__filteredAttributes unionSet:set];
    }
    
    //过滤掉已选中的
    NSSet *tmpSet = __filteredAttributes.copy;
    for (LBArithmeticKindModel *m in __selectedKinds) {
        [tmpSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqual:m.attribute]) {
                [__filteredAttributes removeObject:obj];
                *stop = YES;
            }
        }];
    }
    return __filteredAttributes;
}
#pragma mark -- SKU Utilities
+ (NSArray <LBArithmeticKindModel *>*)__lb_validateAndPackKinds:(NSArray *)kinds
                                                          error:(NSError * __autoreleasing *)error{
    NSError *__error = [NSError errorWithDomain:@"SKU-评估kinds" code:LBArithmeticValidateKindsError userInfo:@{@"error":@"格式错误"}];
    if (LBIsEmptyArray(kinds)) {
        *error = __error;
        return nil;
    }
    NSMutableArray *__kinds = [NSMutableArray arrayWithCapacity:0];
    [kinds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {//格式：[{"a":[a1,a2]},...]
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *key = [NSString stringWithFormat:@"%@", dic.allKeys.firstObject];
            NSArray *arr = [dic valueForKey:key];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (id obj2 in arr) {
                    LBArithmeticKindModel *m = [LBArithmeticKindModel new];
                    m.kind = key;
                    m.count = arr.count;
                    m.attribute = obj2;
                    [__kinds addObject:m];
                }
            }else {
                LBArithmeticLogErr(@"评估kinds异常：格式错误")
                *error = __error;
                *stop = YES;
            }
        }else if ([obj isKindOfClass:[NSArray class]]) {//格式：[[a1,a2],...]
            NSArray *arr = (NSArray *)obj;
            for (id obj2 in arr) {
                LBArithmeticKindModel *m = [LBArithmeticKindModel new];
                m.kind = @(idx).stringValue;
                m.count = arr.count;
                m.attribute = obj2;
                [__kinds addObject:m];
            }
        }else {
            LBArithmeticLogErr(@"评估kinds异常：格式错误")
            *error = __error;
            *stop = YES;
        }
    }];
    return __kinds.copy;
}
+ (NSArray <LBArithmeticKindModel *>*)__lb_validateAndPackSelectKinds:(NSArray *)selectedKinds
                                                             allKinds:(NSArray <LBArithmeticKindModel *>*)allKinds
                                                                error:(NSError **)error{
    NSMutableArray *__selectedKinds = [NSMutableArray arrayWithCapacity:selectedKinds.count];
    for (id obj in selectedKinds) {
        for (LBArithmeticKindModel *m in allKinds) {
            if ([m.attribute isEqual:obj]) {
                [__selectedKinds addObject:m];
                break;
            }
        }
    }
    if (__selectedKinds.count > 0) {
        NSArray *arr = [__selectedKinds valueForKey:@"kind"];
        NSSet *set = [NSSet setWithArray:arr];
        if (set.count < arr.count) {
            LBArithmeticLogErr(@"评估selectedKinds异常：包含同类属性")
            *error = [NSError errorWithDomain:@"评估 selectedKinds" code:LBArithmeticValidateSelectedKindsError userInfo:@{@"error":@"选择的属性中有多个同类属性，无法进行sku计算"}];
            return nil;
        }
    }
    return __selectedKinds;
}
+ (NSArray <LBArithmeticSKUModel *>*)__lb_validateAndPackSkus:(NSArray *)skus
                                               ignoreErrorSku:(BOOL)ignoreErrorSku
                                                    kindCount:(NSUInteger)kindCount
                                                    seperator:(NSString *)seperator
                                                    condition:(LBArithmeticCondition)condition
                                                        error:(NSError **)error {
    NSMutableArray *__skus = [NSMutableArray arrayWithCapacity:skus.count];
    for (NSDictionary *dic in skus) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *key = dic.allKeys.firstObject;
            NSDictionary *dic2 = [dic valueForKey:key];
            NSArray *sku = [[NSString stringWithFormat:@"%@", key] componentsSeparatedByString:seperator];
            if ([dic2 isKindOfClass:[NSDictionary class]]) {
                if (!ignoreErrorSku && [NSSet setWithArray:sku].count != kindCount) {
                    LBArithmeticLogErr(@"评估skus异常：格式错误")
                    *error = [NSError errorWithDomain:@"评估 skus" code:LBArithmeticValidateSkusError userInfo:@{@"error":@"格式错误"}];
                    return nil;
                }
                if (condition ? condition(dic2) : YES) {
                    LBArithmeticSKUModel *m = [LBArithmeticSKUModel new];
                    m.sku = sku;
                    m.data = dic2;
                    [__skus addObject:m];
                }
            }else {
                LBArithmeticLogErr(@"评估skus异常：格式错误")
                *error = [NSError errorWithDomain:@"评估 skus" code:LBArithmeticValidateSkusError userInfo:@{@"error":@"格式错误"}];
                return nil;
            }
        }else {
            LBArithmeticLogErr(@"评估skus异常：格式错误")
            *error = [NSError errorWithDomain:@"评估 skus" code:LBArithmeticValidateSkusError userInfo:@{@"error":@"格式错误"}];
            return nil;
        }
    }
    return __skus.copy;
}

+ (NSArray <LBArithmeticSKUModel *>*)__lb_filterSkus:(NSArray <LBArithmeticSKUModel *>*)skus
                                             inKinds:(NSArray <LBArithmeticKindModel *>*)kinds {
    if (kinds.count <= 0) {
        return skus;
    }
    NSMutableArray *__skus = [NSMutableArray arrayWithCapacity:skus.count];
    for (LBArithmeticSKUModel *m in skus) {
        if ([m containedKinds:kinds]) {
            [__skus addObject:m];
        }
    }
    return __skus.copy;
}
+ (NSArray <LBArithmeticKindModel *>*)__lb_filterKinds:(NSArray <LBArithmeticKindModel *>*)allkinds
                                         trimmingKinds:(NSArray <LBArithmeticKindModel *>*)kinds {
    if (kinds.count <= 0) {
        return allkinds;
    }
    NSMutableArray *__kinds = allkinds.mutableCopy;
    for (LBArithmeticKindModel *m in kinds) {
        for (LBArithmeticKindModel *m2 in allkinds) {
            if ([m2.kind isEqual:m.kind]) {
                [__kinds removeObject:m2];
            }
        }
    }
    return __kinds.copy;
}
+ (NSArray <LBArithmeticKindModel *>*)__lb_getFullCombinationOfKinds:(NSArray <LBArithmeticKindModel *>*)kinds {
    NSMutableArray *__kindsArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = (int)kinds.count-1; i > 0; i--) {
        NSMutableArray *__kinds = [NSMutableArray arrayWithCapacity:0];
        [self __lb_combinationWithArray:kinds inCount:kinds.count outCount:i outArray:&__kinds];
        [__kindsArr addObjectsFromArray:__kinds];
    }
    return __kindsArr.copy;
}
+ (NSSet *)__lb_getMissedAttributeWithKinds:(NSArray <LBArithmeticKindModel *>*)kinds
                                       skus:(NSArray <LBArithmeticSKUModel *>*)skus {
    if (kinds.count <= 0) {
        return nil;
    }
    if (skus.count <= 0) {
        return [NSSet setWithArray:[kinds valueForKey:@"attribute"]];
    }
    
    NSMutableArray *__attributes = [NSMutableArray arrayWithCapacity:0];
    for (LBArithmeticKindModel *kindM in kinds) {
        NSUInteger count = 0;
        for (LBArithmeticSKUModel *skuM in skus) {
            if ([skuM containedKinds:@[kindM]]) {
                count++;
                break;
            }
        }
        if (count == 0) {
            [__attributes addObject:kindM];
        }
    }
    if (__attributes.count > 0) {
        return [NSSet setWithArray:[__attributes valueForKey:@"attribute"]];
    }
    return nil;
}
@end
