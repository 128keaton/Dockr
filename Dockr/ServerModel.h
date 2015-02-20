//
//  AthleteModel.h
//  DepthTesting
//
//  Created by Keaton Burleson on 1/7/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Container : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *id;


+ (instancetype)containerWithName:(NSString *)name id:(NSString *)id;
@end

