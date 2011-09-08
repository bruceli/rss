//
//  AddViewController.m
//  RSS
//
//  Created by 111 111 on 11-7-26.
//  Copyright 2011年 111. All rights reserved.
//

#import "AddViewController.h"
@interface AddViewController ()
@end

@implementation AddViewController
@synthesize titleView;
@synthesize rssView;
@synthesize settingController;
@synthesize cellIndexPath;
@synthesize incomingTitle;
@synthesize incomingRss;

//@synthesize fetchedResultsController=__fetchedResultsController;
//@synthesize managedObjectContext=__managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    
    if (incomingTitle != nil && incomingRss != nil)
    {
        titleView.text = incomingTitle;
        rssView.text = incomingRss;
    }    
}

- (void)viewDidUnload
{

    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillDisappear:(BOOL)animated  
{
    NSString * titleText = [titleView text];
    NSString * rssText = [rssView text];
    
    if (cellIndexPath)
        [settingController modifyRssAddressWith:rssText titleWith:titleText atIndex:cellIndexPath];
    else
        [settingController saveRssAddressWith:rssText titleWith:titleText];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
