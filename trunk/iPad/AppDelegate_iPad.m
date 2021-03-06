//
//  AppDelegate_iPad.m
//  iVulnerable
//
//  Created by shawn on 9/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPad.h"

@implementation AppDelegate_iPad

@synthesize window;

@synthesize MGSplitVC;
@synthesize rootViewController, detailViewController;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
	self.MGSplitVC=[[MGSplitViewController alloc] init];
	MGSplitVC.dividerStyle=MGSplitViewDividerStylePaneSplitter;
	MGSplitVC.masterBeforeDetail=YES;
	MGSplitVC.showsMasterInPortrait=YES;
	MGSplitVC.showsMasterInLandscape=YES;
	MGSplitVC.splitWidth = 15.0; // make it wide enough to actually drag!
	MGSplitVC.allowsDraggingDivider = YES;
	MGSplitVC.vertical=NO;
	self.MGSplitVC.title=@"iVulnerable";
	
	rootViewController=[[[searchResultsViewController alloc] initWithNibName:@"searchResultsViewController" bundle:nil] autorelease];
	detailViewController=[[[CVEDetailsViewControllerIpad alloc] initWithNibName:@"CVEDetailsViewControllerIpad" bundle:nil] autorelease];
	rootViewController.detailsViewController=self.detailViewController;
	//UISplitViewController* splitVC = [[UISplitViewController alloc] init];
	//MGSplitVC.viewControllers = [NSArray arrayWithObjects:self.rootViewController,self.detailViewController,nil];
	
	//UINavigationController *navController=[[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
	//UINavigationController *navController=[[[UINavigationController alloc] initWithRootViewController:MGSplitVC] autorelease];
	//navController.title=@"iVulnerable";
	
	MGSplitVC.viewControllers = [NSArray arrayWithObjects:self.rootViewController,self.detailViewController,nil];
	
	
	
	[window	 addSubview:MGSplitVC.view];
	//[window	 addSubview:navController.view];
	[window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[MGSplitVC release];
    [super dealloc];
}


@end
