//
//  DetailViewController.m
//  Dockr
//
//  Created by Keaton Burleson on 2/20/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <NSURLConnectionDelegate, NSURLConnectionDownloadDelegate>

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *containerName = self.container.name;
        NSLog(@"Running: %@", self.container.status);
        containerName = containerName.description;
        NSString *stringWithoutSpaces = [containerName
                                         stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *stringWithoutQuotes = [stringWithoutSpaces
                                         stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *stringWithoutPar = [stringWithoutQuotes
                                      stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *stringWithoutPar2 = [stringWithoutPar
                                       stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *stringWithoutSlash = [stringWithoutPar2 stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *stringWithoutEnter = [stringWithoutSlash stringByReplacingOccurrencesOfString:@"\n" withString:@""  options:0 range:NSMakeRange(0, 1)];

        
        self.detailDescriptionLabel.text = stringWithoutEnter;
        self.title =[NSString stringWithFormat: @"Manage: %@", stringWithoutEnter];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(IBAction)stopHammerTime:(id)sender{
    NSString *containerName = self.container.name;
    
    containerName = containerName.description;
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
    

/*    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.139:4243"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = @"/containers/mcs/stop";
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSString *requestURL = [[NSString alloc] initWithBytes:[requestBodyData bytes] length:[requestBodyData length] encoding:NSASCIIStringEncoding];
    NSLog(@"URL: %@", requestURL);
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    
    
    responseData = [[NSMutableData data] retain];
    */
    
    NSMutableData *webData;
    NSString *JsonMsg = [NSString stringWithFormat:@""];
    NSString *fullURL = [NSString stringWithFormat:@"http://192.168.1.139:4243/containers/%@/stop", stringWithoutEnter];
    NSURL *url = [NSURL URLWithString: fullURL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[JsonMsg length]];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[JsonMsg dataUsingEncoding:NSUTF16BigEndianStringEncoding allowLossyConversion:YES]];
    
   NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if ( conn ) {
        webData = [NSMutableData data];
        NSString *requestReply = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
        
    }
    else {
        NSLog(@"theConnection is NULL");
    }
    
    
}

-(IBAction)startHammerTime:(id)sender{
    NSString *containerName = self.container.name;
    
    containerName = containerName.description;
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

    
    NSMutableData *webData;
    NSString *JsonMsg = [NSString stringWithFormat:@""];
    NSString *fullURL = [NSString stringWithFormat:@"http://192.168.1.139:4243/containers/%@/start", stringWithoutEnter];
    NSURL *url = [NSURL URLWithString: fullURL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[JsonMsg length]];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[JsonMsg dataUsingEncoding:NSUTF16BigEndianStringEncoding allowLossyConversion:YES]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if ( conn ) {
        webData = [NSMutableData data];
        NSString *requestReply = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
        
    }
    else {
        NSLog(@"theConnection is NULL");
    }
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response: %@", response);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
