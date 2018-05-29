//
//  ViewController.m
//  CitySelectDemo
//
//  Created by paperclouds on 2018/5/28.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "ViewController.h"
#import "CitySelectController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *cityLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.cityLbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:self.cityLbl];
    self.cityLbl.text = @"选择城市";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 200, 50)];
    [self.view addSubview:button];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button setTitle:@"点击选择城市" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
}

// 跳转选择城市列表
- (void)selectCity{
    CitySelectController *citySelect = [[CitySelectController alloc]init];
    [self.navigationController pushViewController:citySelect animated:YES];
    citySelect.selectCity = ^(NSString *cityName) {
        self.cityLbl.text = cityName;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
