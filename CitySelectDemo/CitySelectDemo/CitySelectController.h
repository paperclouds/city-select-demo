//
//  CitySelectController.h
//  CitySelectDemo
//
//  Created by paperclouds on 2018/5/28.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectCity)(NSString *cityName);

@interface CitySelectController : UIViewController

@property (nonatomic, strong) SelectCity selectCity;

@end
