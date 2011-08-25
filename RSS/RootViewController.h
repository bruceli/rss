//
//  RootViewController.h
//  RSS
//
//  Created by Accthun on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomCell.h"

@interface RootViewController : UITableViewController {

    NSMutableArray *allEntries;
    NSMutableArray *settings;

    NSOperationQueue *queue;
    UITableView	*rootTableView;
    
    NSMutableArray *feedList;
    NSTimeInterval timeFrame;
    BOOL canRefresh;

    
}

enum {
    kFastest = 1,
    kFast,
    kNormal,
    kSlow,
    kSlowest,
};

@property (retain) NSMutableArray *allEntries;
@property (retain) NSMutableArray *settings;

@property (retain) NSOperationQueue *queue;
@property (retain) NSMutableArray *feedList;
@property (assign) NSTimeInterval timeFrame;
@property (assign) BOOL canRefresh;

- (IBAction)settingAction:(id)sender;
-(void)addRssEntryWithURL:(NSString*)theURL title:(NSString *)theTitle;
-(void)deleteRssEntryWithIndex:(NSInteger)inIndex;

-(void)refreshFeeds;
-(void)preLoadRssEntryDetailInfo;
-(NSInteger)getFeedsCountByURL:(NSString*)theURL;
-(NSMutableDictionary*) getFeedItemByURL:(NSString*)theURL feedIndex:(NSInteger)index;
-(void)setFeedReadedByRssURL:(NSString*)theRssURL feedURL:(NSString*)theFeedURL;

-(BOOL)isAutoRefresh;
-(NSNumber*)getRefreshInterval;
-(void)setAutoRefresh:(BOOL)isAuto;
-(void)setRefreshInterval:(NSNumber*)inTime;


@end
