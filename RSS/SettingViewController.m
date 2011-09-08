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
-(void)initSliderValue;
-(void)saveSliderValue;
-(NSNumber*)getRefreshInterval;
-(NSNumber*)getExpireDay;
-(NSString*)getTimeDetailLabelBy:(NSNumber*)inTime;
-(NSString*)getDayDetailLabelBy:(NSNumber*)inTime;
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
    [settingArray release];
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
    
    
    refeshInterval = [[[NSNumber alloc] initWithInt:0] retain];
    expireDay = [[[NSNumber alloc] initWithInt:0] retain];
    
    //Initialize the array.
    settingArray = [[NSMutableArray alloc] init];
    [settingArray addObject:@"Automatic refresh"];
    [settingArray addObject:@"Refresh interval"];
    [settingArray addObject:@"Remove articles after"];

    //Set the title
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *addFeedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRssFeed)];
    self.navigationItem.rightBarButtonItem = addFeedButton;
    [addFeedButton release];
    
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self initSliderValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self saveSliderValue];
    [super viewWillDisappear:animated];
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
   
    NSInteger counts = 0;
    
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
    NSString * sectionName = nil;
    
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
    //NSLog(@"Running on Section %d," ,sectionNO);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
/*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
*/
    // Set up the cell...
    
    //First get the dictionary object
    NSString *cellValue;
    switch (sectionNO) {
        case kRssSection: 
        {
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.accessoryView = nil;

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
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            }
            cell.accessoryView = nil;

            cellValue = [self.settingArray objectAtIndex:indexPath.row];
            
            // create Switchable cell button.
            if ([cellValue isEqualToString:@"Automatic refresh"]) 
            {
                //add a switch
                //NSLog(@"Running on Cell %@," ,cellValue);
                
                if(  cell.accessoryView == nil)
                {   
                    //NSLog(@"Adding Switch on Cell %@," ,cellValue);
                    
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

                //NSLog(@"Running on Cell %@," ,cellValue);
                
                if(  cell.accessoryView == nil)
                {
                    //NSLog(@"Adding Slider on Cell ------ %@," ,cellValue);
                    
                    //add a Slider   
                    //UISlider *theSlider =  [[[UISlider alloc] initWithFrame:CGRectMake(55,20,220,45)] autorelease];
                    UISlider *theSlider =  [[UISlider alloc] initWithFrame:CGRectMake(55,20,100,35)];
                    [theSlider addTarget:self action:@selector(refreshSliderMoved:) forControlEvents:UIControlEventTouchUpInside];
                    [theSlider addTarget:self action:@selector(refreshSliderDraging:) forControlEvents:UIControlEventTouchDragInside];

                    theSlider.maximumValue=5;
                    theSlider.minimumValue=1;       
                    //NSNumber* theTime = [self.rootController getRefreshInterval];
                    theSlider.value = [refeshInterval floatValue];
                    cell.accessoryView = theSlider;
                    self.sliderCell = cell;
                    [theSlider release];
                    
                    cell.detailTextLabel.text = [self getTimeDetailLabelBy:[self getRefreshInterval] ];
                }
            }
            
            if ([cellValue isEqualToString:@"Remove articles after"]) 
            {
                
                //NSLog(@"Running on Cell %@," ,cellValue);
                
                if(  cell.accessoryView == nil)
                {
                    //NSLog(@"Adding Slider on Cell ------ %@," ,cellValue);
                    
                    //add a Slider   
                    //UISlider *theSlider =  [[[UISlider alloc] initWithFrame:CGRectMake(55,20,220,45)] autorelease];
                    UISlider *theSlider =  [[UISlider alloc] initWithFrame:CGRectMake(55,20,100,35)];
                    [theSlider addTarget:self action:@selector(expireSliderMoved:) forControlEvents:UIControlEventTouchUpInside];
                    [theSlider addTarget:self action:@selector(expireSliderDraging:) forControlEvents:UIControlEventTouchDragInside];

                    theSlider.maximumValue=5;
                    theSlider.minimumValue=1;       
                    
                    // NSNumber* theTime = [self.rootController getExpireDay];
                    
                    theSlider.value = [expireDay floatValue];
                    cell.accessoryView = theSlider;
                    self.sliderCell = cell;
                    [theSlider release];
                    
                    cell.detailTextLabel.text = [self getDayDetailLabelBy:[self getExpireDay] ];
                    
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

-(void)refreshSliderMoved:(id)sender
{
    refeshInterval = [[NSNumber numberWithFloat:[(UISlider*)sender value]] retain];
}

-(void)refreshSliderDraging:(id)sender
{
    NSNumber* currentValue = [[NSNumber numberWithFloat:[(UISlider*)sender value]] retain];
    UITableViewCell* tableCell =  (UITableViewCell*)[(UISlider*)sender superview];
    tableCell.detailTextLabel.text = [self getTimeDetailLabelBy:currentValue];
    
    [currentValue release];
        
}

-(void)expireSliderDraging:(id)sender
{
    NSNumber* currentValue = [[NSNumber numberWithFloat:[(UISlider*)sender value]] retain];
    UITableViewCell* tableCell =  (UITableViewCell*)[(UISlider*)sender superview];
    tableCell.detailTextLabel.text = [self getDayDetailLabelBy:currentValue];
    
    [currentValue release];
    
}

-(void)expireSliderMoved:(id)sender
{
    expireDay = [[NSNumber numberWithFloat:[(UISlider*)sender value]] retain];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kRssSection)
    {
        
        AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
        
        //Get the RSSentry from allEntries.
        
        //Pass the URL to subViewController.
        addViewController.cellIndexPath = indexPath;
        addViewController.settingController = self;

        NSMutableDictionary *theEntry=[self.rootController.allEntries objectAtIndex:indexPath.row];
        addViewController.incomingTitle  = [theEntry objectForKey:@"blogTitle"];
        addViewController.incomingRss  = [theEntry objectForKey:@"theURL"];
        
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:addViewController animated:YES];
        [addViewController release];

    }
}

-(void) initSliderValue
{
    refeshInterval = [self.rootController getRefreshInterval];
    expireDay = [self.rootController getExpireDay];
}

-(void) saveSliderValue
{
    [self.rootController setRefreshInterval:refeshInterval];
    [self.rootController setFeedExpire:expireDay ];
}

-(NSNumber*)getRefreshInterval
{
    NSNumber* theTime = [self.rootController getRefreshInterval];
    return theTime;
}

-(NSNumber*)getExpireDay
{
    NSNumber* theTime = [self.rootController getExpireDay];
    return theTime;
}


-(NSString*)getTimeDetailLabelBy:(NSNumber*)inTime
{
    NSString* timeString = nil;
    switch ([inTime intValue]) {
        case kFastest:
            timeString = @"10 minutes";
            break;
        case kFast:
            timeString = @"30 minutes";
            break;
        case kNormal:
            timeString = @"1 hour";
            break;
        case kSlow:
            timeString = @"2 hour";
            break;
        case kSlowest:
            timeString = @"6 hour";
            break;
            
        default:
            break;
    }
    return timeString;
}

-(NSString*)getDayDetailLabelBy:(NSNumber*)inTime
{
    NSString* timeString = nil;
    switch ([inTime intValue]) {
        case kFastest:
            timeString = @"1 days";
            break;
        case kFast:
            timeString = @"5 days";
            break;
        case kNormal:
            timeString = @"10 days";
            break;
        case kSlow:
            timeString = @"20 days";
            break;
        case kSlowest:
            timeString = @"30 days";
            break;
            
        default:
            break;
    }
    return timeString;
}


@end

