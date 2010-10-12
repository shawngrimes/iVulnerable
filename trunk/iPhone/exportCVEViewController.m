//
//  exportCVEViewController.m
//  iVulnerable
//
//  Created by shawn on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "exportCVEViewController.h"

@implementation exportCVEViewController

@synthesize tweetThisButton;
@synthesize emailThisButton;
@synthesize cveObject;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title=@"Export CVE";
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    ///return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


-(IBAction) tweetCVE{
	tweetCVEViewController *tweetCVEVC = [[tweetCVEViewController alloc] init];
	tweetCVEVC.modalPresentationStyle=UIModalPresentationFormSheet;
	//tweetCVEVC.modalPresentationStyle=UIModalPresentationPageSheet;
	tweetCVEVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
	tweetCVEVC.cveObject=self.cveObject;

	[self.parentViewController presentModalViewController:tweetCVEVC animated:YES];

	[tweetCVEVC release];
	
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}
-(IBAction) emailCVE{
	NSLog(@"Email it");
	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	[mailVC setSubject:cveObject.name];
	
	
	NSString *CVERichText=[NSString stringWithFormat:@"I thought you should see this:<BR><HR><STRONG>NAME:</STRONG> %@<BR><STRONG>Date:</STRONG>%@<BR><STRONG>Type:</STRONG>%@<br><STRONG>Description: </STRONG>%@<HR><BR><STRONG>References:</STRONG>", 
						   cveObject.name,
						   cveObject.cvedate,
						   cveObject.type,
						   cveObject.description];
	
	NSLog(@"Reference Count: %i", [self.cveObject.references count]);
	
	for (CVEReference *cveRef in self.cveObject.references){
		if(cveRef.url){
			CVERichText=[CVERichText stringByAppendingFormat:@"<BR><STRONG>Source:</STRONG> %@<BR><a href=\"%@\">%@</a><BR><HR>",
						 cveRef.source, cveRef.url, cveRef.value];
		}else{
			CVERichText=[CVERichText stringByAppendingFormat:@"<BR><STRONG>Source:</STRONG> %@<BR>%@<BR><HR>",
						 cveRef.source, cveRef.value];
		}
		
	}
	CVERichText=[CVERichText stringByAppendingFormat:@"</BODY></HTML>"];
	
	
	[mailVC setMessageBody:CVERichText isHTML:YES];
	mailVC.mailComposeDelegate=self;
	mailVC.modalPresentationStyle=UIModalPresentationFormSheet;
	//mailVC.modalTransitionStyle=UIModalTransitionStylePartialCurl;	
	[self presentModalViewController:mailVC animated:YES];
	[mailVC release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[tweetThisButton release], tweetThisButton=nil;
	[emailThisButton release], emailThisButton=nil;
}


@end
