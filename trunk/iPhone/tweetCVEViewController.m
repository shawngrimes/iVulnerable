//
//  tweetCVEViewController.m
//  iVulnerable
//
//  Created by shawn on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "tweetCVEViewController.h"


@implementation tweetCVEViewController

@synthesize sendTweetButton;
@synthesize cancelButton;
@synthesize tweetMessageTextView;
@synthesize cveObject;
@synthesize characterCountLabel;
@synthesize activityIndicator;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{


	NSURL *mcafeeShortener=[NSURL URLWithString:[NSString stringWithFormat:@"http://mcaf.ee/CREATE?v=http://cve.mitre.org/cgi-bin/cvename.cgi?name=%@", cveObject.name]];
	NSString *mcafeeResults=[NSString stringWithContentsOfURL:mcafeeShortener encoding:NSStringEncodingConversionAllowLossy error:nil];
	

	NSRange urlRange=[mcafeeResults rangeOfString:@"is mapped to</p><p> <a href=\""];
	
	NSRange spanRange=urlRange;
	spanRange.length=spanRange.length+400;
	
	NSLog(@"MCafee substring: %@", [mcafeeResults substringWithRange:spanRange]);
	
	NSRange urlEndRange=[mcafeeResults rangeOfString:@"\">" options:NSLiteralSearch range:spanRange];
	
	spanRange.location=urlRange.location+urlRange.length;
	spanRange.length=urlEndRange.location-spanRange.location;
	
	NSString *mcafeeURLString=[mcafeeResults substringWithRange:spanRange];
	NSLog(@"MCafee URL: %@", mcafeeURLString);
	
	self.tweetMessageTextView.text=[NSString stringWithFormat:@"%@... %@ - %@",[cveObject.description substringToIndex:100], cveObject.name, mcafeeURLString];
	[self updateCharacterCount];
	if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"s8ld6ihTfU5Skrmiayb5vA";
	_engine.consumerSecret = @"3XUZySbiutQW76dmQKiqbyxi8yRmFiL9aqPjcPU7yI";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller)
		[self presentModalViewController: controller animated: YES];
	else {
		
		
	}
	
	
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
	[self.activityIndicator stopAnimating];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	/*
	tweets = [[NSMutableArray alloc] init];
	
	for(NSDictionary *d in statuses) {
		
		NSLog(@"See dictionary: %@", d);
		
		Tweet *tweet = [[Tweet alloc] initWithTweetDictionary:d];
		[tweets addObject:tweet];
		[tweet release];
	}
	
	[self.tableView reloadData];
	 */
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	
	
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}


#pragma mark Send Tweet
-(IBAction) sendTweet{
	NSLog(@"Send Tweet");
	[self.activityIndicator startAnimating];
	[self.tweetMessageTextView  resignFirstResponder];
	[_engine sendUpdate:self.tweetMessageTextView.text];
	

}

- (void)textViewDidChange:(UITextView *)textView{
	[self updateCharacterCount];
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if([text isEqualToString:@"\n"]){
		[tweetMessageTextView resignFirstResponder];
		return NO;
	}
	return YES;
}

-(IBAction) updateCharacterCount{
	short int characterCount;
	characterCount=140-[self.tweetMessageTextView.text length];
	
	characterCountLabel.text=[NSString stringWithFormat:@"%i", characterCount];
	if (characterCount<0) {
		characterCountLabel.textColor=[UIColor redColor];
	}else{
		characterCountLabel.textColor=[UIColor whiteColor];
	}
}
-(IBAction) closeTweet{
	[self.activityIndicator stopAnimating];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	
}


#pragma mark Close

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
	[sendTweetButton release], sendTweetButton=nil;
	[tweetMessageTextView release], tweetMessageTextView=nil;
	[activityIndicator release], activityIndicator=nil;
}


@end
