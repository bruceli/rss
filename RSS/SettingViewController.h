//
//  SettingViewController.h
//  RSS
//
//  Created by Accthun on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@interface SettingViewController : UITableViewController {
    NSMutableArray *settingArray ;
    UITableViewCell *sliderCell;
    UITableViewCell *switchCell;
    RootViewController *rootController;
    NSNumber *refeshInterval;
    NSNumber *expireDay;

}
//@property (nonatomic, retain) IBOutlet UITableView *tableSettingView;
@property (retain)NSMutableArray *settingArray;
@property (retain)UITableViewCell *switchCell;
@property (retain)UITableViewCell *sliderCell;
@property (retain)RootViewController *rootController;


-(void)saveRssAddressWith:(NSString*) rssAddress titleWith:(NSString*) titleText;
-(void)modifyRssAddressWith:(NSString*) rssAddress titleWith:(NSString*) titleText atIndex:(NSIndexPath*)index;

@end
