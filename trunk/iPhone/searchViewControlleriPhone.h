//
//  searchViewControlleriPhone.h
//  CVE_Search
//
//  Created by shawn on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "iAd/ADBannerView.h"

#import "CVEDetailsViewController.h"
#import "CVE.h"
#import "CVEReference.h"

#import "reachable.h"

#import "TBXML.h"


@interface searchViewControlleriPhone : UIViewController<ADBannerViewDelegate,MBProgressHUDDelegate, UITableViewDelegate, UISearchBarDelegate>  {
	IBOutlet UIBarButtonItem *refreshCVE;
	
	IBOutlet UIBarButtonItem *todaysAlertsButton;
	IBOutlet UIBarButtonItem *mostRecentAlertsButton;
	
	IBOutlet UISearchBar *cveSearchBar;
	IBOutlet UIToolbar *bottomToolbar;
	IBOutlet UIBarButtonItem *refreshTable;
	
	IBOutlet UITableView *resultsTableViewController;
	IBOutlet UILabel *searchTableFooterLabel;
	
	IBOutlet UILabel *CVECellTitle;
	IBOutlet UILabel *CVECellDescription;
	
	UIView *_contentView;
	id _adBannerView;
	BOOL _adBannerIsVisible;
	
	
	
	MBProgressHUD *HUD;
	
	NSMutableArray *tableData;
}

@property (nonatomic, retain) 	IBOutlet UILabel *CVECellTitle;
@property (nonatomic, retain) 	IBOutlet UILabel *CVECellDescription;

@property (nonatomic, retain) 	NSMutableArray *tableData;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *todaysAlertsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mostRecentAlertsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshCVE;
@property (nonatomic, retain)	IBOutlet UIBarButtonItem *refreshTable;
@property (nonatomic, retain) 	IBOutlet UITableView *resultsTableViewController;
@property (nonatomic, retain) 	IBOutlet UILabel *searchTableFooterLabel;
@property (nonatomic, retain) 	IBOutlet UISearchBar *cveSearchBar;
@property (nonatomic, retain) 	IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, retain) MBProgressHUD *HUD;


@property (nonatomic, retain) 	IBOutlet UIView *downloadView;


//iAd integration
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

-(IBAction) refresh:(id)sender;
-(IBAction)getTodaysAlerts;
-(IBAction)getMostRecentAlerts;
-(NSArray *) doSearch:(NSString *) searchText;
-(void) CVE2CoreData:(NSData *) CVEData;
-(void)fetchResults;


- (int)getBannerHeight:(UIDeviceOrientation)orientation;
- (int)getBannerHeight;
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)createAdBannerView;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;


@end
