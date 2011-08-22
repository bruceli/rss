//
//  SubViewController.h
//  RSS
//
//  Created by Accthun on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"
#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"
#import "RootViewController.h"
#import "WebViewController.h"

@interface SubViewController : UITableViewController {
    NSArray *feeds;
    NSOperationQueue *queue;
    WebViewController *webViewController;
    NSString *subURL;
    RootViewController* theRootController;
}

@property (retain) RootViewController *theRootController;
@property (retain) NSString *subURL;
@property (retain) NSArray *feeds;
@property (retain) WebViewController *webViewController;

@end
