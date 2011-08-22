//
//  RootViewController.m
//  RSS
//
//  Created by Accthun on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SettingViewController.h"
#import "SubViewController.h"


@interface RootViewController()
- (void)configureCell:(CustomCell *)cell withRSSEntry:(NSMutableDictionary *)theEntry;
- (NSString*)getRssAddressforCell:(NSIndexPath *)indexPath;
- (void) saveRssEntriesToFile;
- (BOOL) loadRssEntriesFromFile;
- (NSMutableDictionary*)rssEntryWithURL:(NSString*) theURL title:(NSString*)theTitle;
- (NSString*)getRssAddressforCell:(NSIndexPath *)indexPath;
- (void)preLoadRssEntryByURL:(NSString*)theURL;
- (BOOL)loadSettingFromFile;
- (void)saveSettingToFile;
- (void)initSettings;
-(void) setTimeFreameWithIntValue:(int)inTime;
-(NSMutableDictionary*)getFeedItemByURL:(NSString*)theURL feedIndex:(NSInteger)index;


@end

@implementation RootViewController

@synthesize allEntries ;
@synthesize settings;
@synthesize queue ;
@synthesize feedList;
@synthesize timeFrame;
@synthesize canRefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Feeds";
    self.feedList = [NSMutableArray array];
    self.queue = [[[NSOperationQueue alloc] init] autorelease];
    
    [self loadRssEntriesFromFile];
    [self loadSettingFromFile];

	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(settingAction:)] autorelease];
    
	self.navigationItem.leftBarButtonItem = addButton;
    
    UIBarButtonItem *addRefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeeds)];
    self.navigationItem.rightBarButtonItem = addRefreshButton;
    [addRefreshButton release];

    //Create Auto Refresh Thread.
    [NSThread detachNewThreadSelector:@selector(autoRefresh:) toTarget:self withObject:nil ];
    
    
    // init canRefresh here;
    canRefresh = YES;
    
    //Test function. closed
    [self preLoadRssEntryDetailInfo];
	
    NSNumber* intervalTime = [self getRefreshInterval];
    [self setTimeFreameWithIntValue:[intervalTime intValue]];

    
    //[self.rootTableView reloadData];
    //Always crash when I tried to call reloadData, Why this happen?

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



- (void)dealloc
{
    [rootTableView release];
    rootTableView = nil;
    
    [allEntries release] ;
    allEntries = nil;
    
    [feedList release] ;
    feedList = nil;
    
    [queue release];
    queue = nil;
    
    
    [super dealloc];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger counts =  [self.allEntries count];
    return counts;

/*    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger counts =  [sectionInfo numberOfObjects];
    return counts;

*/
 }

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *theEntry=[self.allEntries objectAtIndex:indexPath.row];
    [self configureCell:cell withRSSEntry:theEntry];
    
    
    return cell;
    
}

-(NSMutableDictionary*)getRssItemforCell:(NSIndexPath*)indexPath
{
    NSMutableDictionary *theEntry=[self.allEntries objectAtIndex:indexPath.row];    
    return theEntry;
}

- (NSString*)getRssAddressforCell:(NSIndexPath *)indexPath
{
    NSMutableDictionary *theEntry=[self.allEntries objectAtIndex:indexPath.row];    
    NSString *rssAddress  = [theEntry objectForKey:@"theURL"];
    return rssAddress;
}

-(BOOL)hasFeedList:(NSMutableDictionary*) rssItem
{
    BOOL isLoaded = NO;
    NSArray* array = [rssItem objectForKey:@"feedList"];
    if (array != nil) {
        isLoaded = YES;
    }
    
    return isLoaded;
}


- (void)configureCell:(CustomCell *)cell withRSSEntry:(NSMutableDictionary *)theEntry
{
    //NSString *cellText = theEntry.blogTitle;
    NSString *cellText = [theEntry objectForKey:@"blogTitle"];
    NSNumber *countNumber = [theEntry objectForKey:@"unReadCount"];
    NSString *countString = [countNumber stringValue];
    cell.textLabel.text = cellText ;
    
    [cell setCellCount:countString];

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubViewController *subViewController = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:nil];
    
    //Get the RSSentry from allEntries.
    NSMutableDictionary *theEntry = [allEntries objectAtIndex:indexPath.row];
    subViewController.subURL = [self getRssAddressforCell:indexPath];

    if (![self hasFeedList:theEntry]) {
        [self preLoadRssEntryByURL:[self getRssAddressforCell:indexPath]];
    }
    
    //Pass the URL to subViewController.
    subViewController.theRootController = self;
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:subViewController animated:YES];
    [subViewController release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SubViewController *subViewController = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:nil];
    
    //Get the RSSentry from allEntries.
    NSMutableDictionary *theEntry = [allEntries objectAtIndex:indexPath.row];
    subViewController.subURL = [self getRssAddressforCell:indexPath];
    
    if (![self hasFeedList:theEntry]) {
        [self preLoadRssEntryByURL:[self getRssAddressforCell:indexPath]];
    }
    
    //Pass the URL to subViewController.
    subViewController.theRootController = self;
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:subViewController animated:YES];
    [subViewController release];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void)setUnreadCount
{    
    NSIndexPath * theIndex = [NSIndexPath indexPathForRow:0 inSection:0];

    // How to add unRead count.... 
    [(CustomCell*)[self.tableView cellForRowAtIndexPath:theIndex] setCellCount:@"88"];

}

- (IBAction)settingAction:(id)sender
{
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    //settingViewController.managedObjectContext = self.managedObjectContext;
    // Pass the selected object to the new view controller.
    settingViewController.rootController = self;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
    [settingViewController release];

}

-(void)addRssEntryWithURL:(NSString*)theURL title:(NSString *)theTitle
{
    NSMutableDictionary* entryX = [self rssEntryWithURL:theURL title:theTitle];
    
    [allEntries insertObject:entryX atIndex:0];
    
    [self saveRssEntriesToFile];
}

-(void)deleteRssEntryWithIndex:(NSInteger)inIndex 
{
    [allEntries removeObjectAtIndex:inIndex];
    [self saveRssEntriesToFile];
}



-(void) refreshFeeds
{
    [self preLoadRssEntryDetailInfo];
    
}

-(void)preLoadRssEntryDetailInfo
{
    // This funtion will load each rss feed detail infomation and put it into    " NSMutableArray *feedList;"
    int i;
    for ( i= 0; i < [self.allEntries count]; i++)
    {
        NSMutableDictionary *theEntry=[self.allEntries objectAtIndex:i];    
        NSString *rssAddress  = [theEntry objectForKey:@"theURL"];

        NSURL *url = [NSURL URLWithString:rssAddress];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [queue addOperation:request];
    }
}

-(void)preLoadRssEntryByURL:(NSString*)theURL
{
    NSURL *url = [NSURL URLWithString:theURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [queue addOperation:request];    
}


-(void) setTimeFreameWithIntValue:(int)inTime
{
    timeFrame = inTime*300;
}

-(void) autoRefresh:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    while (YES) {
        // set Timeframe from setting view.
        [NSThread sleepForTimeInterval:self.timeFrame];
        
        if([self isAutoRefresh])
        {
            [self preLoadRssEntryDetailInfo];
            // Reload RSS Data HERE..... 
        }
        
    }
    
    [NSThread exit];
    [pool release];
}


-(BOOL) loadRssEntriesFromFile
{
    BOOL status = NO;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath 
                           stringByAppendingPathComponent:@"arrayFav.plist"];
    
    NSLog(@"Unsupported root element: %@", plistPath);

    NSArray* array = [NSArray arrayWithContentsOfFile:plistPath];
    if(!array) {
        allEntries = [[NSMutableArray alloc] init];
    } else {
        allEntries = [[NSMutableArray alloc] initWithArray:array];
    };

    return status;
}


-(void) saveRssEntriesToFile
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath 
                           stringByAppendingPathComponent:@"arrayFav.plist"];
    
    [allEntries writeToFile:plistPath atomically:YES];   
}



-(void) saveSettingToFile
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath 
                           stringByAppendingPathComponent:@"setting.plist"];
    
    [settings writeToFile:plistPath atomically:YES];   
}


-(BOOL) loadSettingFromFile
{
    BOOL status = NO;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES) objectAtIndex:0];
    NSString *plistPath = [rootPath 
                           stringByAppendingPathComponent:@"setting.plist"];
    
    NSLog(@"Unsupported root element: %@", plistPath);
    
    NSArray* array = [NSArray arrayWithContentsOfFile:plistPath];
    if(!array) {
        settings = [[NSMutableArray alloc] init];
        [self initSettings];
    } else {
        settings = [[NSMutableArray alloc] initWithArray:array];
    };
    
    return status;
}

-(void)initSettings
{
    NSNumber* autoFlag = [NSNumber numberWithInt:0];
    NSNumber* refreshInterval = [NSNumber numberWithInt:1]; 
    
    NSArray* keys = [NSArray arrayWithObjects:@"autoRefresh", @"RefreshInterval",nil];

    NSMutableArray* settingInfo = [NSMutableArray arrayWithObjects:autoFlag, refreshInterval,nil];
    NSMutableDictionary* settingEntry = [NSMutableDictionary dictionaryWithObjects:settingInfo forKeys:keys];
    
    [settings insertObject:settingEntry atIndex:0];
}

-(BOOL)isAutoRefresh
{
    BOOL isAuto = NO;
    NSMutableDictionary* settingEntry = [settings objectAtIndex:0];
    NSNumber* autoFlag = [settingEntry valueForKey:@"autoRefresh"];
    
    if([autoFlag intValue] == 1) 
        isAuto = YES;

    return isAuto;
}

-(NSNumber*)getRefreshInterval
{
    NSMutableDictionary* settingEntry = [settings objectAtIndex:0];
    NSNumber* theTime = [settingEntry valueForKey:@"RefreshInterval"];

    return theTime;
}

-(void)setAutoRefresh:(BOOL)isAuto
{
    NSMutableDictionary* settingEntry = [NSMutableDictionary dictionaryWithDictionary:[settings objectAtIndex:0]];
    if (isAuto) 
        [settingEntry setObject:[NSNumber numberWithInt:1] forKey:@"autoRefresh"];
    else
        [settingEntry setObject:[NSNumber numberWithInt:0] forKey:@"autoRefresh"];

    [settings replaceObjectAtIndex:0 withObject:settingEntry];
    [self saveSettingToFile];
}


-(void)setRefreshInterval:(NSNumber*)inTime
{
    NSMutableDictionary* settingEntry = [NSMutableDictionary dictionaryWithDictionary:[settings objectAtIndex:0]];
    int theTime = [inTime intValue];
    [settingEntry setObject:[NSNumber numberWithInt:theTime] forKey:@"RefreshInterval"];
    
    [settings replaceObjectAtIndex:0 withObject:settingEntry];
        
    [self saveSettingToFile];
    
    [self setTimeFreameWithIntValue:theTime];
}


-(NSMutableDictionary*)rssEntryWithURL:(NSString*) theURL title:(NSString*)theTitle
{
    NSNumber* theCount = [NSNumber numberWithInt:0];
    NSMutableArray* feedArray = [NSMutableArray array];
    NSArray* keys = [NSArray arrayWithObjects:@"theURL", @"blogTitle",@"unReadCount",@"feedList",nil];
    NSMutableArray* entryInfo = [NSMutableArray arrayWithObjects:theURL, theTitle, theCount,feedArray,nil];
   
    NSMutableDictionary* rssEntry = [NSMutableDictionary dictionaryWithObjects:entryInfo forKeys:keys];
    return rssEntry;    
}

-(NSMutableDictionary*)feedItemWithURL:(NSString*) theURL title:(NSString*)theTitle date:(NSDate*)theDate
{
    NSNumber* isNew = [NSNumber numberWithInt:1];
    //If this feed has been readed,  isNew = 0;

    NSArray* keys = [NSArray arrayWithObjects:@"theURL", @"articleTitle",@"date",@"feedStatus",nil];
    NSMutableArray* feedInfo = [NSMutableArray arrayWithObjects:theURL, theTitle, theDate, isNew,nil];
    NSMutableDictionary* feedEntry = [NSMutableDictionary dictionaryWithObjects:feedInfo forKeys:keys];
    return feedEntry;    
}

-(NSMutableArray*)getFeedArrayByURL:(NSString*)theURL
{
    NSMutableArray* feedArray = nil;
    for ( int i= 0; i < [self.allEntries count]; i++) {
        
        NSMutableDictionary* entryX=[allEntries objectAtIndex:i];
        NSString *targetURL= [entryX valueForKey:@"theURL"];
        
        if ([targetURL compare:theURL] == NSOrderedSame) {
             feedArray = [entryX objectForKey:@"feedList"];
        }
    }
    return feedArray;
}

-(NSInteger)getFeedsCountByURL:(NSString*)theURL
{
    NSInteger count = 0;
    NSMutableArray* feedArray = [self getFeedArrayByURL:theURL];
    if(feedArray != nil){
        count = [feedArray count];
    }
    return count;
}


-(NSMutableDictionary*)getFeedItemByURL:(NSString*)theURL feedIndex:(NSInteger)index
{
    NSMutableDictionary* feedItem;
    NSMutableArray* feedArray = [self getFeedArrayByURL:theURL];
    if(feedArray != nil){
        feedItem = [feedArray objectAtIndex:index];
    }
    return feedItem;
}


-(NSInteger)getUnreadFeedsCountByURL:(NSString*)theURL
{
    NSInteger count = 0;
    NSMutableArray* feedArray = [self getFeedArrayByURL:theURL];
    if(feedArray != nil){
        for ( int i= 0; i < [feedArray count]; i++) {
            NSMutableDictionary* entryX=[feedArray objectAtIndex:i];
            NSNumber* status= [entryX objectForKey:@"feedStatus"];
            if([status intValue] == 1)    //If this feed has been readed,  isNew = 0;
                count++;
        }
    }
    return count;
}

-(void)countUnreadFeeds
{
    for ( int i= 0; i < [self.allEntries count]; i++) {
        NSMutableDictionary *theEntry=[self.allEntries objectAtIndex:i];    
        NSString *rssAddress  = [theEntry objectForKey:@"theURL"];
        NSInteger thecount = [self getUnreadFeedsCountByURL:rssAddress];
        NSNumber* unreadCount = [NSNumber numberWithInt:thecount];
        [theEntry setValue:unreadCount forKey:@"unReadCount"];
    }
}

// -(NSMutableDictionary*):(NSString*)theRSSURL feedURL:(NSString*)theFeedURL

-(NSMutableDictionary*)getFeedItemByRssURL:(NSString*)theRssURL feedURL:(NSString*)theFeedURL
{
    NSMutableDictionary* feedItem = nil;
    NSMutableArray* feedArray = [self getFeedArrayByURL:theRssURL];
    if(feedArray != nil){
        for ( int i= 0; i < [feedArray count]; i++) {
            NSMutableDictionary* entryX=[feedArray objectAtIndex:i];
            NSString *targetURL= [entryX valueForKey:@"theURL"];
            if ([targetURL compare:theFeedURL] == NSOrderedSame) {
                feedItem = entryX;
            }
        }
    }
    return feedItem;
}

-(void)setFeedReadedByRssURL:(NSString*)theRssURL feedURL:(NSString*)theFeedURL
{
    NSMutableDictionary* feedItem = [self getFeedItemByRssURL:theRssURL feedURL:theFeedURL];
    if (feedItem) {
        NSNumber* isRead = [NSNumber numberWithInt:0]; //If this feed has been readed,  isNew = 0;
        [feedItem setValue:isRead forKey:@"feedStatus"];
    }
    [self countUnreadFeeds];
    [self saveRssEntriesToFile];
}

-(BOOL)isFeed:(NSMutableDictionary*)inFeedItem alreadyExistIn:(NSString*)theURL
{
	BOOL isExist = NO;
	NSString* theFeedURL = [inFeedItem valueForKey:@"theURL"];
	if([self getFeedItemByRssURL:theURL feedURL:theFeedURL] != nil)

		isExist = YES;
	
	return isExist;
}

-(void)addFeed:(NSMutableDictionary*)inFeedItem intoRssEntry:(NSString*)theURL
{
	NSMutableArray* theFeedArray = [self getFeedArrayByURL:theURL];
	[theFeedArray addObject:inFeedItem ];
    
}


-(void)saveFeedItem:(NSMutableArray*)feedLists byURL:(NSString*)theURL
{
    
    for ( int i= 0; i < [self.allEntries count]; i++) {
        
        NSMutableDictionary* entryX=[allEntries objectAtIndex:i];
        NSString *targetURL= [entryX valueForKey:@"theURL"];
        
        if ([targetURL compare:theURL] == NSOrderedSame) {
			
			for(int k = 0; k < [feedLists count]; k ++)
			{
				NSMutableDictionary* feedItem = [feedList objectAtIndex:k];
				
				if(![self isFeed:feedItem alreadyExistIn:theURL])
					[self addFeed:feedItem intoRssEntry:theURL];
			}
        }
       
    }
    [self countUnreadFeeds];
    [self saveRssEntriesToFile];
}


#pragma mark ----- HTTP  Services 

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {            
        
        //NSString *blogTitle = [channel valueForChild:@"title"];                    
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];            
            NSString *articleDateString = [item valueForChild:@"pubDate"];
            NSDate *articleDate;
            if(articleDateString)
                articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
			NSMutableDictionary *feedEntry = [self feedItemWithURL:articleUrl title:articleTitle date:articleDate];
						
			[entries addObject:feedEntry];
            
        }      
    }
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    //NSString *blogTitle = [rootElement valueForChild:@"title"];                    
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) {
        
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrl = nil;
        NSArray *links = [item elementsForName:@"link"];        
        for(GDataXMLElement *link in links) {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue]; 
            if ([rel compare:@"alternate"] == NSOrderedSame && 
                [type compare:@"text/html"] == NSOrderedSame) {
                articleUrl = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];        
        //        NSDate *articleDate = nil;
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];

        
		NSMutableDictionary *feedEntry = [self feedItemWithURL:articleUrl title:articleTitle date:articleDate];
			
		[entries addObject:feedEntry];
    }      
    
}


- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {    
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    } else if ([rootElement.name compare:@"feed"] == NSOrderedSame) {                       
        [self parseAtom:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    
    [queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData] 
                                                               options:0 error:&error];
        if (doc == nil) { 
            NSLog(@"Failed to parse %@", request.url);
        } else
        
        {
           // NSMutableArray *entries = [[NSMutableArray alloc] autorelease];
            NSMutableArray *entries = [NSMutableArray array];

            [self parseFeed:doc.rootElement entries:entries];                
            
            if(request != nil)
            {
                // Get Orignal URL from Request
                NSURL *theURL= [request originalURL];
                NSString *theString = [theURL absoluteString];

				// Find target URL from allEntries, and put all RSS feeds into FeedList
                
                [self saveFeedItem:entries byURL:theString];
                
                
            }
                
        }        
    }];
    
    [[self tableView] reloadData];
    
}




@end
