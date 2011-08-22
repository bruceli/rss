//
//  RSSEntry.h
//  RssReader
//
//  Created by Accthun on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "feedItem.h"

@interface RSSEntry : NSObject {
    NSString *blogTitle;
    NSString *articleTitle;
    NSString *articleUrl;
    NSDate *articleDate;
    NSMutableArray *feedList;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSDate *articleDate;
@property (copy) NSMutableArray *feedList;

- (id)initWithBlogTitle:(NSString*)_blogTitle articleTitle:(NSString*)_articleTitle articleUrl:(NSString*)_articleUrl articleDate:(NSDate*)_articleDate;

@end
