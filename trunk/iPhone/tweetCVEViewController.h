//
//  tweetCVEViewController.h
//  iVulnerable
//
//  Created by shawn on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVE.h"
#import "CVEReference.h"

#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface tweetCVEViewController : UIViewController<UITextViewDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {

	IBOutlet UIButton *sendTweetButton;
	IBOutlet UIButton *cancelButton;
	IBOutlet UITextView *tweetMessageTextView;
	IBOutlet UILabel *characterCountLabel;
	
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	CVE *cveObject;
	
	SA_OAuthTwitterEngine *_engine;
}

@property (nonatomic, retain) IBOutlet UIButton *sendTweetButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) 	IBOutlet UITextView *tweetMessageTextView;

@property (nonatomic, retain) 	IBOutlet UILabel *characterCountLabel;

@property (nonatomic, retain) 	CVE *cveObject;
@property (nonatomic, retain) 	IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction) sendTweet;
-(IBAction) updateCharacterCount;
-(IBAction) closeTweet;

@end
