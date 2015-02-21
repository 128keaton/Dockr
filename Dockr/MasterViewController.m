//
//  MasterViewController.m
//  Dockr
//
//  Created by Keaton Burleson on 2/20/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DisplayModel.h"
#import "ServerModel.h"
@interface MasterViewController () <DisplayModelProtocol, UIActionSheetDelegate>{
        DisplayModel *_displayModel;
}

@property NSArray *objects;


@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showFilterOptions:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _displayModel = [[DisplayModel alloc]init];
    _displayModel.delegate = self;
    [_displayModel downloadItems];
  
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    // Set this view controller object as the delegate for the home model object
   
    [self.tableView addSubview:self.refreshControl];
    

    
}

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    self.objects = items;
    
    // Reload the table view
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
              DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        Container *container = [[self objects] objectAtIndex:[indexPath row]];

        [controller setContainer:container];
        
        [controller setDetailItem:container.id.description];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View
-(IBAction)showFilterOptions:(id)sender{
    
    UIActionSheet *filterOptions = [[UIActionSheet alloc]initWithTitle:@"Filter:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Running", @"All", nil];
    [filterOptions showInView:self.view];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Container *container = [[self objects] objectAtIndex:[indexPath row]];

    
    NSString *containerName = container.name;
   
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
    
     //NSLog(stringWithoutEnter);
    cell.textLabel.text = stringWithoutEnter;
    return cell;
}

-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (buttonIndex == 0) {
        [defaults setValue:@"http://192.168.1.139:4243/containers/json?all=0" forKey:@"url"];
    }else if (buttonIndex == 1){
          [defaults setValue:@"http://192.168.1.139:4243/containers/json?all=1" forKey:@"url"];
    }
    [_displayModel downloadItems];
    
    [self.tableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



@end
