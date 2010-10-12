//
//  CVEDetailsViewController.h
//  Vulnerability_Search
//
//  Created by shawn on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVE.h"
#import "CVEReference.h"

#import "exportCVEViewController.h"

@interface CVEDetailsViewController : UIViewController <UITableViewDelegate> {

	IBOutlet UIWebView *webViewCVEDetails;
	IBOutlet UITableView *detailsTableView;
	IBOutlet UITextView *descriptionTextView;
	IBOutlet UIBarButtonItem *exportCVEButton;
	
	CVE *cveObject;
	
}

@property (nonatomic, retain) IBOutlet UIWebView *webViewCVEDetails;
@property (nonatomic, retain) 	CVE *cveObject;
@property (nonatomic, retain) 	IBOutlet UITableView *detailsTableView;
@property (nonatomic, retain) 	IBOutlet UITextView *descriptionTextView;;
@property (nonatomic, retain) 	IBOutlet UIBarButtonItem *exportCVEButton;

-(IBAction) exportCVE;

@end
