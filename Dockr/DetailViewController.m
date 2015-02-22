//
//  DetailViewController.m
//  Dockr
//
//  Created by Keaton Burleson on 2/20/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import "DetailViewController.h"
 #import "BEMSimpleLineGraphView.h"
#import "MasterViewController.h"
#import "DisplayModel.h"
@interface DetailViewController () <NSURLConnectionDelegate, NSURLConnectionDownloadDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, ImageModelProtocol>{
    IBOutlet UILabel *idLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet BEMSimpleLineGraphView *graphView;
    NSMutableArray *pointArray;
    NSString *key;
    NSArray *valueArray;
    ImageModel *_imageModel;
}

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

-(void)imagesDownloaded:(NSArray *)items{
    
    valueArray = items;
    NSLog(@"Stuff count: %lu", (unsigned long)items.count);
    

    [self.tableView reloadData];
        [self configureView];
}

-(IBAction)refresh:(id)sender{
    MasterViewController *masterViewController = [[MasterViewController alloc]init];
    [masterViewController reloadDataRemotely];
    

    [_imageModel downloadImages:self.container.name.description];
    
   // Container *container = [masterViewController.objects objectAtIndex:self.row];
   // NSLog(@"New Container Name: %@", container.name.description);
    
    [self configureView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
     
      //  NSLog(@"Running: %@", self.container.status);
        
        Image *testImage = [valueArray objectAtIndex:0];
        NSLog(@"Running: %@", testImage.status);
           NSString *containerName = testImage.name.description;
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
        idLabel.text = testImage.id.description;
        
        
      
        if ([testImage.status.description rangeOfString:@"1"].location == NSNotFound) {
                  statusLabel.text = @"Dead in the water";
        } else {
            statusLabel.text = @"Full speed ahead";
        }
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        key = [NSString stringWithFormat:@"pointArray_%@", self.container.name.description];
        if ([defaults objectForKey:key]!=nil) {
            pointArray = [NSMutableArray arrayWithArray:[defaults objectForKey:key]];
            NSLog(@"Found saved");
            
        }else{
            pointArray = [[NSMutableArray alloc]init];
            NSLog(@"Gonna make a new one");
        }
        
        
        NSString *string = testImage.status.description;
        if ([string rangeOfString:@"1"].location == NSNotFound) {
            NSLog(@"server down");
            [pointArray addObject:@"Down"];
            [graphView reloadGraph];
        } else {
            NSLog(@"server up");
            [pointArray addObject:@"Up"];
            [graphView reloadGraph];
        }
        
        NSLog(@"Count: %lu", (unsigned long)pointArray.count);
        [defaults setObject:pointArray forKey:key];
        [defaults synchronize];

        
        
   
        
        
        
    }
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    if ([pointArray count]>1) {
  
    return [pointArray count]; // Number of points in the graph.
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *string = self.container.status.description;
        if ([string rangeOfString:@"Up"].location == NSNotFound) {
            NSLog(@"server down");
            [pointArray addObject:@"Down"];
            [graphView reloadGraph];
        } else {
            NSLog(@"server up");
            [pointArray addObject:@"Up"];
            [graphView reloadGraph];
        }
        
        NSLog(@"Count: %lu", (unsigned long)pointArray.count);
        [defaults setObject:pointArray forKey:key];
        [defaults synchronize];
    
    }
    return [pointArray count];
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
   
    NSString *status = [pointArray objectAtIndex:index];
    if ([status  isEqual: @"Down"]) {
        return 0;
    }else if ([status isEqual:@"Up"]){
        return 5;
    }
    return 0;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
        _imageModel = [[ImageModel alloc]init];
    _imageModel.delegate = self;
    
    [_imageModel downloadImages:self.container.name.description];
    
 
    
   
    graphView.enableBezierCurve = YES;
    graphView.animationGraphEntranceTime = 1.0f;
    

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
  [self performSelector:@selector(timedRefresh) withObject:nil afterDelay:1.0f];
    
}

-(void)timedRefresh{
       [_imageModel downloadImages:self.container.name.description];
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
    [self performSelector:@selector(timedRefresh) withObject:nil afterDelay:1.0f];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Response: %@", response);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
