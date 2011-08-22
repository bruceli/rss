//
//  feedItem.h
//  RSS
//
//  Created by Accthun on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface feedItem : NSObject {
    NSString *feedTitle;
    NSString *feedUrl;
    NSNumber *isNew;
    //If this feed has been readed,  isNew = 0;
    //If not isNew = 1;
    NSDate *feedDate;

}

@property (copy) NSString *feedTitle;
@property (copy) NSString *feedUrl;
@property (copy) NSNumber *isNew;
@property (copy) NSDate *feedDate;


- (id)initWithFeedTitle:(NSString*)_feedTitle feedUrl:(NSString*)_feedUrl feedDate:(NSDate*)_articleDate;


@end
