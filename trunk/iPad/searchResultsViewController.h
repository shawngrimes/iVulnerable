//
//  searchResultsViewController.h
//  iVulnerable
//
//  Created by shawn on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CVE.h"
#import "CVEReference.h"
#import "CVEDetailsViewControllerIpad.h"

#import "reachable.h"

#import "TBXML.h"


@interface searchResultsViewController : UIViewController <MBProgressHUDDelegate, UITableViewDelegate, UISearchBarDelegate> {
	
	IBOutlet UISearchBar *cveSearchBar;
	IBOutlet UITableView *resultsTableViewController;
	IBOutlet UILabel *searchTableFooterLabel;
	
	IBOutlet UILabel *CVECellTitle;
	IBOutlet UILabel *CVECellDescription;
	
	IBOutlet UIBarButtonItem *todaysAlertsButton;
	IBOutlet UIBarButtonItem *mostRecentAlertsButton;
	
	CVEDetailsViewControllerIpad *detailsViewController;
	
	MBProgressHUD *HUD;
	
	NSMutableArray *tableData;

}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *todaysAlertsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mostRecentAlertsButton;

@property (nonatomic, retain) 	IBOutlet UILabel *CVECellTitle;
@property (nonatomic, retain) 	IBOutlet UILabel *CVECellDescription;

@property (nonatomic, retain) 	NSMutableArray *tableData;
@property (nonatomic, retain) 	IBOutlet UITableView *resultsTableViewController;
@property (nonatomic, retain) 	IBOutlet UILabel *searchTableFooterLabel;
@property (nonatomic, retain) 	IBOutlet UISearchBar *cveSearchBar;

@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) 	CVEDetailsViewControllerIpad *detailsViewController;

-(NSArray *) doSearch:(NSString *) searchText;
-(void) CVE2CoreData:(NSData *) CVEData;
-(void) fetchResults;

-(IBAction)getTodaysAlerts;
-(IBAction)getMostRecentAlerts;

@end
