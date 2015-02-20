//
//  AthleteModel.m
//  DepthChartzDemo
//
//  Created by Keaton Burleson on 1/7/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerModel.h"

@implementation Container



+ (instancetype)containerWithName:(NSString *)name id:(NSString *)id{
    Container *newContainer = [[self alloc] init];

    newContainer.id = id;
    
    newContainer.name = name;
    return newContainer;
    
}




@end
