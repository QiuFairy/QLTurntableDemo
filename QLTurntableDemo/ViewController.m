//
//  ViewController.m
//  QLTurntableDemo
//
//  Created by qiu on 2017/4/18.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#import "ViewController.h"
#import "QLTurntableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120, 50)];
    [button1 setTitle:@"一键点击转盘" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor cyanColor];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)button1Click{
    
    QLTurntableViewController * vc = [[QLTurntableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
