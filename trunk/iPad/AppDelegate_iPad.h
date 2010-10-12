//
//  AppDelegate_iPad.h
//  iVulnerable
//
//  Created by shawn on 9/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchResultsViewController.h"
#import "MGSplitViewController.h"
#import "searchResultsViewController.h"
#import "CVEDetailsViewControllerIpad.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MGSplitViewController *MGSplitVC;
	searchResultsViewController *rootViewController;
	CVEDetailsViewControllerIpad *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) MGSplitViewController *MGSplitVC;
@property (nonatomic, retain) searchResultsViewController *rootViewController;
@property (nonatomic, retain) CVEDetailsViewControllerIpad *detailViewController;


@end

