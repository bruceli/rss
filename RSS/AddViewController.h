//
//  AddViewController.h
//  RSS
//
//  Created by 111 111 on 11-7-26.
//  Copyright 2011年 111. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@interface AddViewController : UIViewController
{
    UITextField *rssView;
    UITextField *titleView;
    SettingViewController *settingController;
    NSIndexPath *cellIndexPath;
    NSString *incomingRss;
    NSString *incomingTitle;
    
}
@property (retain) SettingViewController *settingController;
@property (retain) NSIndexPath *cellIndexPath;

@property (retain) NSString *incomingRss;
@property (retain) NSString *incomingTitle;

@property (retain) IBOutlet UITextField *rssView;
@property (retain) IBOutlet UITextField *titleView;

//@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
