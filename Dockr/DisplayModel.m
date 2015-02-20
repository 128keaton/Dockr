//
//  DisplayModel.m
//  DepthTesting
//
//  Created by Keaton Burleson on 1/7/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ServerModel.h"
#import "DisplayModel.h"


@interface DisplayModel()
{
    NSMutableData *_downloadedData;
}
@end

@implementation DisplayModel

- (void)downloadItems
{
    NSURL *jsonFileUrl;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [defaults objectForKey:@"url"];
    if (url == nil) {
   
    // Download the json file
    jsonFileUrl= [NSURL URLWithString:@"http://192.168.1.139:4243/containers/json?all=0"];
    }else{
       jsonFileUrl= [NSURL URLWithString:[defaults objectForKey:@"url"]];
    }
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}


#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableArray *_athletes = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
   
        if (![jsonElement[@"Name"]  isEqual: @""]) {
            
     
        
            Container *newContainer = [Container containerWithName:jsonElement[@"Names"] id:jsonElement[@"Id"]];
                                       
        
        // Add this question to the locations array
        [_athletes addObject:newContainer];
        }
        
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_athletes];
    }
}


@end

