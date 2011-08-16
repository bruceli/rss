//
//  SubViewController.m
//  RSS
//
//  Created by Accthun on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubViewController.h"

@implementation SubViewController

@synthesize feeds ;
@synthesize subURL;
@synthesize webViewController;
@synthesize theRootController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{        
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.theRootController getFeedsCountByURL:subURL];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    //cell.contentView.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:1 alpha:1];
    //Get Feed from RootController
    NSMutableDictionary* feedItem;
    feedItem = [self.theRootController getFeedItemByURL:subURL feedIndex:indexPath.row];
        
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    NSString *articleDateString = [dateFormatter stringFromDate:[feedItem objectForKey:@"date"]];
    NSNumber* unReadFlag= [feedItem objectForKey:@"feedStatus"];
    
    cell.textLabel.text = [feedItem objectForKey:@"articleTitle"];      
    if ([unReadFlag intValue] == 1) {
        cell.textLabel.textColor= [UIColor colorWithRed:.2 green:.3 blue:.9 alpha:3];      
    }
    else{
        cell.textLabel.textColor= [UIColor blackColor];      

    }

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", articleDateString];
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (webViewController == nil) {
        self.webViewController = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]] autorelease];
    }
    
    NSMutableDictionary* feedItem;
    feedItem = [self.theRootController getFeedItemByURL:subURL feedIndex:indexPath.row];
    
    NSString *theURL = [feedItem objectForKey:@"theURL"];
    webViewController.theURL = theURL;
    // Remove new feed flag.
    [self.theRootController setFeedReadedByRssURL:subURL feedURL:theURL];

    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
