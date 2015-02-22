//
//  DisplayModel.h
//  DepthTesting
//
//  Created by Keaton Burleson on 1/7/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol DisplayModelProtocol <NSObject>



- (void)itemsDownloaded:(NSArray *)items;

@end

@interface DisplayModel : NSObject
@property (nonatomic, weak) id<DisplayModelProtocol> delegate;

- (void)downloadItems;

@end




@protocol ImageModelProtocol <NSObject>



- (void)imagesDownloaded:(NSArray *)items;

@end

@interface ImageModel : NSObject
@property (nonatomic, weak) id<ImageModelProtocol> delegate;

- (void)downloadImages:(NSString *)name;

@end



