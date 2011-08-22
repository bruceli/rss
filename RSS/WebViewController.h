//
//  WebViewController.h
//  RSS
//
//  Created by Accthun on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
    
    UIWebView *webView;
    NSString *theURL;

}

@property (retain) IBOutlet UIWebView *webView;
@property (retain) NSString *theURL;
//@property (retain) WebViewController *webViewController;


@end
