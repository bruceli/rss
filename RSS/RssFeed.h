//
//  RssFeed.h
//  RSS
//
//  Created by Accthun on 7/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RssFeed : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * articleTitle;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSDate * articleDate;
@property (nonatomic, retain) NSManagedObject * relationship;

@end
