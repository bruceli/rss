//
//  SettingViewController.m
//  RSS
//
//  Created by Accthun on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "AddViewController.h"
@interface SettingViewController ()
- (void)configureCell:(UITableViewCell *)cell withRSSEntry:(NSMutableDictionary *)theEntry;
@end

@implementation SettingViewController
@synthesize settingArray;
@synthesize switchCell;
@synthesize sliderCell;
@synthesize rootController;

enum {
    kRssSection = 0,
    kSettingSection,
};

- (void)dealloc
{
    [settingArray dealloc];
    settingArray = nil;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize the array.
    self.settingArray = [[NSMutableArray alloc] init];
    [settingArray addObject:@"Automatic refresh"];
    [settingArray addObject:@"Refresh interval"];
    [settingArray addObject:@"Remove articles"];

    //Set the title
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *addFeedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRssFeed)];
    self.navigationItem.rightBarButtonItem = addFeedButton;
    [addFeedButton release];
    
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated
{
 /*   UISwitch *switchview = self.switchCell.accessoryView;
    if ([switchview isOn]) {
        int k =1;
    }
    else{
        int w = 1;
    }
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 2;
    return count;
// We have 2 sections in Setting View
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//Number of rows it should expect should be based on the section
   
    NSInteger counts;
    
    switch (section) {
        case kRssSection: 
        {
            //counts = [[self.fetchedResultsController sections] count];    
            //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
           counts =  [self.rootController.allEntries count];
           //counts =  [sectionInfo numberOfObjects];

        }            
        break;  
        case kSettingSection: 
        {
            counts = [self.settingArray count];
        }            
            break; 
    }

    return counts;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * sectionName;
    
    switch (section) {
        case kRssSection: 
            sectionName = @"RSS feeds list";
            break;  
        case kSettingSection: 
            sectionName = @"Refresh";
            break; 
    }
    return sectionName;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger sectionNO= indexPath.section;

    static NSString *CellIdentifier = @"Cell";
    NSLog(@"Running on Section %d," ,sectionNO);

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    //First get the dictionary object
    NSString *cellValue;
    cell.accessoryView = nil;
    switch (sectionNO) {
        case kRssSection: 
        {
            NSMutableDictionary *theEntry=[self.rootController.allEntries objectAtIndex:indexPath.row];
            [self configureCell:cell withRSSEntry:theEntry];
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(55,20,100,45)];
            deleteButton.tag = indexPath.row;
            [deleteButton setImage:[UIImage imageNamed:@"DeleteButton"] forState:0];
            [deleteButton addTarget:self action:@selector(deleteCellItem:) forControlEvents:UIControlEventTouchUpInside];

            cell.accessoryView = deleteButton;
            [deleteButton release];

            
        }            
        break;
            
        case kSettingSection:
        {
            //Setting Section.
            cellValue = [self.settingArray objectAtIndex:indexPath.row];
            
            // create Switchable cell button.
            if ([cellValue isEqualToString:@"Automatic refresh"]) 
            {
                //add a switch
                NSLog(@"Running on Cell %@," ,cellValue);
                
                if(  cell.accessoryView == nil)
                {   
                    NSLog(@"Adding Switch on Cell %@," ,cellValue);
                    
                    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchview addTarget:self action:@selector(autoRefeshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    BOOL isOn = [self.rootController isAutoRefresh];
                    [switchview setOn:isOn];
                    cell.accessoryView = switchview;
                    
                    [switchview release];
                    self.switchCell = cell;

                }
            }
            
            if ([cellValue isEqualToString:@"Refresh interval"]) 
            {
                NSLog(@"Running on Cell %@," ,cellValue);
                
                if(  cell.accessoryView == nil)
                {
                    NSLog(@"Adding Slider on Cell ------ %@," ,cellValue);
                    
                    //add a Slider   
                    //UISlider *theSlider =  [[[UISlider alloc] initWithFrame:CGRectMake(55,20,220,45)] autorelease];
                    UISlider *theSlider =  [[UISlider alloc] initWithFrame:CGRectMake(55,20,100,35)];
                    [theSlider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventTouchUpInside];

                    theSlider.maximumValue=5;
                    theSlider.minimumValue=1;       
                    NSNumber* theTime = [self.rootController getRefreshInterval];
                    theSlider.value = [theTime floatValue];
                    cell.accessoryView = theSlider;
                    self.sliderCell = cell;
                    [theSlider release];
                    
                }
            }
            cell.textLabel.text  = cellValue;
        }
        break;
            

    }
            
//    NSLog([NSString stringWithFormat:@"%s", "End of this round\n."]);
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withRSSEntry:(NSMutableDictionary *)theEntry
{
    //NSString *cellText = theEntry.blogTitle;
    NSString *cellText = [theEntry objectForKey:@"blogTitle"];
    cell.textLabel.text = cellText ;
}


-(void) addRssFeed
{
    AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    addViewController.settingController = self;

    [self.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
}

-(void)saveRssAddressWith:(NSString*) rssAddress titleWith:(NSString*) titleText
{
    if([rssAddress length]!=0 && [titleText length]!=0)
        [self.rootController addRssEntryWithURL:rssAddress title:titleText];
}

-(void)deleteCellItem:(id)sender
{
    NSInteger deleteItemInxex = ((UIButton *)sender).tag;
    [self.rootController deleteRssEntryWithIndex:deleteItemInxex];    
    [[self tableView] reloadData];

}

-(void)autoRefeshButtonClicked:(id)sender
{
    [self.rootController setAutoRefresh:[(UISwitch*)sender isOn] ];
}

-(void)sliderMoved:(id)sender
{
    [self.rootController setRefreshInterval:[NSNumber numberWithFloat:[(UISlider*)sender value]] ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    
    //Get the RSSentry from allEntries.
    
    //Pass the URL to subViewController.
    addViewController.cellIndexPath = indexPath;
    
    NSMutableDictionary *theEntry=[self.rootController.allEntries objectAtIndex:indexPath.row];
    addViewController.incomingTitle  = [theEntry objectForKey:@"blogTitle"];
    addViewController.incomingRss  = [theEntry objectForKey:@"theURL"];
    
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:addViewController animated:YES];
    [addViewController release];
}

@end

