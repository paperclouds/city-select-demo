//
//  CityCollectionCell.m
//  CitySelectDemo
//
//  Created by paperclouds on 2018/5/29.
//  Copyright © 2018年 hechang. All rights reserved.
//

#import "CityCollectionCell.h"

@implementation CityCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 0.5;
        self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.titleLbl];
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
