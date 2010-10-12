//
//  exportCVEViewController.h
//  iVulnerable
//
//  Created by shawn on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "tweetCVEViewController.h"
#import "CVE.h"
#import "CVEReference.h"


@interface exportCVEViewController : UIViewController<MFMailComposeViewControllerDelegate> {

	IBOutlet UIButton *tweetThisButton;
	IBOutlet UIButton *emailThisButton;
	
	CVE *cveObject;
	
}

@property (nonatomic, retain) 	IBOutlet UIButton *tweetThisButton;
@property (nonatomic, retain) 	IBOutlet UIButton *emailThisButton;
@property (nonatomic, retain) 	CVE *cveObject;


-(IBAction) tweetCVE;
-(IBAction) emailCVE;


@end
