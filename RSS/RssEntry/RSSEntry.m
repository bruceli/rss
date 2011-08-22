//
//  RSSEntry.m
//  RssReader
//
//  Created by Accthun on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSSEntry.h"


@implementation RSSEntry

@synthesize blogTitle;// = _blogTitle;
@synthesize articleTitle;// = _articleTitle;
@synthesize articleUrl;// = _articleUrl;
@synthesize articleDate;// = _articleDate;
@synthesize feedList;


- (id)initWithBlogTitle:(NSString*)_blogTitle articleTitle:(NSString*)_articleTitle articleUrl:(NSString*)_articleUrl articleDate:(NSDate*)_articleDate;
{
    if ((self = [super init])) {
        blogTitle = [_blogTitle copy];
        articleTitle = [_articleTitle copy];
        articleUrl = [_articleUrl copy];
        articleDate = [_articleDate copy];
    }
    return self;
}


- (void)dealloc {
    [blogTitle release];
    blogTitle = nil;
    [articleTitle release];
    articleTitle = nil;
    [articleUrl release];
    articleUrl = nil;
    [articleDate release];
    articleDate = nil;
    [super dealloc];
}

@end
