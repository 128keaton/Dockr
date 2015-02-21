//
//  SettingsViewController.m
//  Dockr
//
//  Created by Keaton Burleson on 2/20/15.
//  Copyright (c) 2015 Keaton Burleson. All rights reserved.
//

#import "SettingsViewController.h"
#include<unistd.h>
#include<netdb.h>

@interface SettingsViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *urlField;
    NSUserDefaults *defaults;
    BOOL ifReady;
    IBOutlet UILabel *resultLabel;
    IBOutlet UITableViewCell *resultCell;
}
@end



@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ifReady = false;
    
    [urlField addTarget:self
                 action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"baseURL"]!=nil) {
        urlField.text = [defaults objectForKey:@"baseURL"];
                         
    }
    
    resultLabel.hidden = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == resultCell && ifReady == false){
    resultLabel.hidden = YES;
         return 0; //set the hidden cell's height to 0
    }
    else{
    resultLabel.hidden = NO;
        resultCell.hidden = false;
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)textFieldDidChange:(id)sender{
    [defaults setObject:urlField.text forKey:@"baseURL"];
    [defaults synchronize];
    
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        
        [self.tableView beginUpdates];
        ifReady = true;
        [self.tableView endUpdates];
        
        NSLog([self testConnection] ? @"Yes" : @"No");
        
       [self performSelector:@selector(rehideResult) withObject:nil afterDelay:3.0f];
        NSLog(@"Not implemented");
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(BOOL)testConnection{
    
    NSString *preurl = [NSString stringWithFormat:@"http://%@/containers/json?all=0", [defaults objectForKey:@"baseURL"]];
    NSLog(preurl);
    const char *uString = [preurl UTF8String];
    struct addrinfo *res = NULL; int s = getaddrinfo(uString, NULL, NULL, &res); bool network_ok = (s == 0 && res != NULL); freeaddrinfo(res);
    
    return network_ok;
    
}
-(void)rehideResult{
   
    
    [self.tableView beginUpdates];
    ifReady = false;
    [self.tableView endUpdates];

  
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
