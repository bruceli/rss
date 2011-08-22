//
//  feedItem.m
//  RSS
//
//  Created by Accthun on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "feedItem.h"


@implementation feedItem

@synthesize feedTitle;
@synthesize feedUrl;
@synthesize isNew;
@synthesize feedDate;

- (id)initWithFeedTitle:(NSString*)_feedTitle feedUrl:(NSString*)_feedUrl feedDate:(NSDate*)_feedDate
{

    if ((self = [super init])) {
        feedTitle = [_feedTitle copy];
        feedUrl = [_feedUrl copy];
        isNew = [NSNumber numberWithInt:1]; // new item, init with 1
        feedDate = [_feedDate copy];
    }
    return self;
}

- (void)dealloc {
    [feedTitle release];
    feedTitle= nil;
    
    [feedUrl release];
    feedUrl= nil;
    
    [isNew release];
    isNew= nil;
    
    [feedDate release];
    feedDate= nil;
    
    [super dealloc];
}




@end
