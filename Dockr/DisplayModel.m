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
    NSString *sortingURL = [defaults objectForKey:@"sortingURL"];
    NSString *baseURL = [defaults objectForKey:@"baseURL"];
    
   
    if (sortingURL != nil) {
   
        
    // Download the json file
        
    jsonFileUrl= [NSURL URLWithString:sortingURL];
    }else{
        NSString *placeholder = [NSString stringWithFormat:@"http://%@/containers/json?all=1", baseURL];
        jsonFileUrl = [NSURL URLWithString:placeholder] ;
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
            
     
        
            Container *newContainer = [Container containerWithName:jsonElement[@"Names"] id:jsonElement[@"Id"] status:jsonElement[@"Running"]];
                                       
        
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



@interface ImageModel()
{
    NSMutableData *_downloadedData;
}
@end

@implementation ImageModel

- (void)downloadImages:(NSString *)name
{
    NSURL *jsonFileUrl;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 //   NSString *sortingURL = [defaults objectForKey:@"sortingURL"];
    NSString *baseURL = [defaults objectForKey:@"baseURL"];
    

    NSString *containerName = name;
    NSString *stringWithoutSpaces = [containerName
                                     stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *stringWithoutQuotes = [stringWithoutSpaces
                                     stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *stringWithoutPar = [stringWithoutQuotes
                                  stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *stringWithoutPar2 = [stringWithoutPar
                                   stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *stringWithoutSlash = [stringWithoutPar2 stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *stringWithoutEnter = [stringWithoutSlash stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    NSString *placeholder = [NSString stringWithFormat:@"http://%@/containers/%@/json", baseURL, stringWithoutEnter];
    jsonFileUrl = [NSURL URLWithString:placeholder];
  
    
    NSLog(@"URL for container: %@", placeholder);
    
    
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
    NSMutableDictionary *jsonElement = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];

    
    // Loop through Json objects, create question objects and add them to our questions array
   // for (int i = 0; i < jsonArray.count; i++)
   // {
        if (jsonArray != nil) {
     
    //    NSMutableDictionary *jsonElement = [jsonArray objectAtIndex:i];
        
        // Create a new location object and set its props to JsonElement properties
        
        if (![jsonElement[@"Name"]  isEqual: @""]) {
            
            
            
       
            
            NSMutableDictionary *runningElement = [jsonElement objectForKey:@"State"];
            
  
            Image *newImage = [Image imageWithName:jsonElement[@"Name"] id:jsonElement[@"Id"] status:runningElement[@"Running"]];

            
            
            // Add this question to the locations array
            [_athletes addObject:newImage];
        }
        }
        
  //  }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate imagesDownloaded:_athletes];
    }
}


@end


