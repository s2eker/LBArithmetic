//
//  ViewController.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "ViewController.h"
#import "LBArithmetic.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    int n = 10, m = 5;
//    NSMutableArray *outArr = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < n; i++) {
//        [arr addObject:@(i)];
//    }
//    [LBArithmetic lb_combinationWithArray:arr outCount:m outArray:outArr];
//    NSLog(@"out array:%@", outArr);
    
    
    {
        
    }
    
    {
        NSMutableArray *arr = nil;// [NSMutableArray arrayWithCapacity:0];
        NSLog(@"前,%p,%@", arr, arr);
        [self dealArray:arr];
        NSLog(@"后,%p,%@", arr, arr);
    }
    
    
//    {
//        int c = 0;
//        NSLog(@"前,%p,%d", &c, c);
//        [self getNumber:c];
//        NSLog(@"后,%p,%d", &c, c);        
//    }
    
}

- (void)dealArray:(id)arr {
    arr = @"a";
    NSLog(@"中,%p,%@", arr, arr);
}
- (void)getNumber:(int)c {
    c = 2;
    NSLog(@"中,%p,%d", &c, c);
}

@end
