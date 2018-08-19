//
//  ViewController.m
//  LBArithmetic
//
//  Created by 李兵 on 2018/8/17.
//  Copyright © 2018年 李兵. All rights reserved.
//

#import "ViewController.h"
#import "LBSKUViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)skuDemoAction:(id)sender {
    [self.navigationController pushViewController:[LBSKUViewController vc] animated:YES];
}


@end
