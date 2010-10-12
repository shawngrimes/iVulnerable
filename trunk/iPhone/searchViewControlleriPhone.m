//
//  searchViewControlleriPhone.m
//  CVE_Search
//
//  Created by shawn on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "searchViewControlleriPhone.h"




@implementation searchViewControlleriPhone

@synthesize refreshCVE;
@synthesize resultsTableViewController;
@synthesize cveSearchBar;
@synthesize bottomToolbar;
@synthesize refreshTable;
@synthesize searchTableFooterLabel;
@synthesize HUD;

@synthesize tableData;

@synthesize CVECellTitle;
@synthesize CVECellDescription;

@synthesize todaysAlertsButton;
@synthesize mostRecentAlertsButton;

//iAD
@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;



NSData *receivedData;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.cveSearchBar.delegate=self;
		self.title=@"Vulnerability Search";
		receivedData=[[NSMutableData data] retain];
		
		self.tableData=[[NSMutableArray alloc] initWithCapacity:0];
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.HUD];
	self.HUD.delegate = self;

	[self createAdBannerView];
	//[self fetchResults];
	//[self.resultsTableViewController reloadData];
	
}

-(void)viewWillAppear:(BOOL)animated{
//	[self refresh];
	[super viewWillAppear:animated];
    
	

	[self fixupAdView:[UIDevice currentDevice].orientation];

	
	//[self.resultsTableViewController reloadData];
}

-(void) viewDidAppear:(BOOL)animated{
	//[self.cveSearchBar becomeFirstResponder];
	[super viewDidAppear:animated];
}

-(IBAction) refresh:(id)sender{
//	[self updateHUDLabel:@"Updating Results"];
	[self performSelectorInBackground:@selector(fetchAndReload) withObject:nil];
	//	[self.fetchedResultsController performFetch:nil];
	//	[self.resultsTableViewController reloadData];
//	[self hideHUD];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self fixupAdView:toInterfaceOrientation];
}



#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];

	
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
	
	//NSLog(@"Received data: %f", ((float)[receivedData length]/expectedFilesize));
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	UIAlertView *failedConnectionAlertView=[[UIAlertView alloc] initWithTitle:@"Error Downloading" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[failedConnectionAlertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
		
	
	//[self hideHUD];
	//[self performSelectorInBackground:@selector(refreshCVEDatabase) withObject:nil];
	
	[self performSelectorInBackground:@selector(CVE2CoreData) withObject:nil];
	


	
    // release the connection, and the data object
	if([connection retainCount]>0){
		[connection release];
	}
	
}


#pragma mark Search Bar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.resultsTableViewController.allowsSelection = NO;
    self.resultsTableViewController.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.resultsTableViewController.allowsSelection = YES;
    self.resultsTableViewController.scrollEnabled = YES;
	
	if([reachable connectedToNetwork]){
		
		//[self.tableData removeAllObjects];
		
		//[self fetchResults];
	}else{
	//	UIAlertView *noNetwork=[[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"There is no connection to the Internet." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
	//	[noNetwork show];
	}
	
	

	
	
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some 
    // api that you are using to do the search
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.resultsTableViewController.allowsSelection = YES;
    self.resultsTableViewController.scrollEnabled = YES;
	
	if([reachable connectedToNetwork]){
	
		[self.tableData removeAllObjects];
	
		[self fetchResults];
	}else{
		UIAlertView *noNetwork=[[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"There is no connection to the Internet." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
		[noNetwork show];
	}
	
}

-(void)fetchAndReload{
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc]init];
	[self performSelectorOnMainThread:@selector(updateHUDLabel:) withObject:@"Fetching Results..." waitUntilDone:YES];
	
	
	
    [self.resultsTableViewController reloadData];
	[self performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
	[pool drain];
}

#pragma mark HUD Controls
-(void) updateHUDLabel:(NSString *)textForLabel{
	// The hud will dispable all input on the view
	self.HUD.mode=MBProgressHUDModeIndeterminate;
	
    // Add HUD to screen
    
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    
	
	//self.HUD.mode=MBProgressHUDModeIndeterminate;
	self.HUD.labelText=textForLabel;
//	self.HUD.detailsLabelText=@"This could take a few minutes";
	[self.HUD show:NO];
	usleep(30000);
	NSLog(@"Updated HUD Label: %@", textForLabel);

	
}

-(void) updateProgressHUD:(NSNumber *) progress{
	self.HUD.progress=[progress floatValue];
	self.HUD.mode=MBProgressHUDModeDeterminate;
	usleep(30000);
	NSLog(@"Updated HUD progress: %@", progress);
}

-(void) hideHUD{
	NSLog(@"Hiding HUD");
	[self.HUD hide:YES];
//	[self.HUD removeFromSuperview];
//	 [self.HUD release];
	usleep(30000);
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
//    [self.HUD removeFromSuperview];
   // [self.HUD release];
}

#pragma mark CVE Functions
-(IBAction)getTodaysAlerts{
	self.cveSearchBar.text=@"todaysAlerts";
	[self searchBarSearchButtonClicked:self.cveSearchBar];
	
}

-(IBAction)getMostRecentAlerts{
	self.cveSearchBar.text=@"";
	[self searchBarSearchButtonClicked:self.cveSearchBar];
	
}
-(void) CVE2CoreData{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSUInteger count=0, LOOP_LIMIT=1000;
	
	int processingStatus=0;
	NSNumber *processPercent=[[NSNumber alloc] init];
	
	[self performSelectorOnMainThread:@selector(updateHUDLabel:) withObject:@"Loading results..." waitUntilDone:YES];
	
	NSString *tempString=[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
	//NSLog(@"Temp String: %@", tempString);
	int processingTotal=[[tempString componentsSeparatedByString:@"</item>"] count];
	[tempString release];
	NSLog(@"ProcessingTotal: %i", processingTotal);
	NSError *error;
	
	
	TBXML *xmlData=[[TBXML alloc] initWithXMLData:receivedData];

	if (xmlData.rootXMLElement){
		//NSLog(@"Found root element: %@", [TBXML textForElement:xmlData.rootXMLElement]);
		
		TBXMLElement *xmlCVEElement=[TBXML	childElementNamed:@"item" parentElement:xmlData.rootXMLElement];
		while(xmlCVEElement){
			count++;
			
			//NSLog(@"CVE: %@", [TBXML valueOfAttributeNamed:@"name" forElement:xmlCVEElement]);
			processPercent = [NSNumber numberWithFloat:(float)(++processingStatus)/(float)(processingTotal)];
			NSLog(@"Process percent: %i of %i (%@)", processingStatus, processingTotal, processPercent);
			
			[self performSelectorOnMainThread:@selector(updateProgressHUD:) withObject:processPercent waitUntilDone:YES];
			
			
			CVE *cveEntry=[[CVE alloc] init];
			
			cveEntry.name=[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:xmlCVEElement]];
			cveEntry.sequence=[TBXML textForElement:[TBXML childElementNamed:@"sequence" parentElement:xmlCVEElement]];
			cveEntry.cvedate=[TBXML textForElement:[TBXML childElementNamed:@"date" parentElement:xmlCVEElement]];
			cveEntry.type=[TBXML textForElement:[TBXML childElementNamed:@"type" parentElement:xmlCVEElement]];
			cveEntry.description=[TBXML textForElement:[TBXML childElementNamed:@"description" parentElement:xmlCVEElement]];
			
			NSLog(@"CVE: %@", cveEntry.name);
			
			TBXMLElement *xmlREFParent=[TBXML childElementNamed:@"refs" parentElement:xmlCVEElement];
			if(xmlREFParent){
				TBXMLElement *xmlREFChild=[TBXML childElementNamed:@"ref" parentElement:xmlREFParent];
				while(xmlREFChild){

					CVEReference *cveRef=[[CVEReference alloc] init];
					//NSLog(@"Reference: %@", [TBXML textForElement:[TBXML childElementNamed:@"source" parentElement:xmlREFChild]]);
					cveRef.source=[TBXML textForElement:[TBXML childElementNamed:@"source" parentElement:xmlREFChild]];;
					cveRef.url=[NSURL URLWithString:[TBXML textForElement:[TBXML childElementNamed:@"url" parentElement:xmlREFChild]]];
					cveRef.value=[TBXML textForElement:[TBXML childElementNamed:@"value" parentElement:xmlREFChild]];;
					[cveEntry.references addObject:cveRef];
					//NSLog(@"References count before add: %i", [cveEntry.references count]);
					xmlREFChild=xmlREFChild->nextSibling;
				}
				
			}
			//NSLog(@"References count before add: %i", [cveEntry.references count]);
			[tableData addObject:cveEntry];
			NSLog(@"Getting next CVE Entry");
			xmlCVEElement=xmlCVEElement->nextSibling;
		}
	}
	
	[self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
	
	//[self performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
	NSLog(@"Finished loading CVE into Database");
	
	[pool drain];
	
}


-(void) fetchResults{
	[self updateHUDLabel:@"Searching..."];
	usleep(50000);
	
	NSString *cveRemotePath=@"http://ivulnerable.com/mod_perl/cveSearch.pl";
	if([cveSearchBar.text length]>0){
		cveRemotePath=[cveRemotePath stringByAppendingFormat:@"?search=%@", cveSearchBar.text];
	}
	// Create the request.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:cveRemotePath]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:900];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
		
	} else {
		// Inform the user that the connection failed.
	}
	
}


#pragma mark resultsTableViewController Delegate
-(void) reloadTable{
	NSLog(@"Table Count: %i", [tableData count]);
	[self.resultsTableViewController reloadData];
	[self.HUD hide:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 61.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
    static NSString *CellNib=@"searchResultsCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
		//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
		cell=(UITableViewCell *) [nib objectAtIndex:0];
    }
	
		CVE *cveEntry=[tableData objectAtIndex:indexPath.row];
	
		CVECellTitle.text=cveEntry.name;
		CVECellDescription.text=cveEntry.description;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	/*
	 NSLog(@"Pose Title: %@", poseInfo.title);
	 NSLog(@"Pose notes: %@", poseInfo.notes);
	 NSLog(@"Pose sortIndex: %@", poseInfo.sortIndex);
	 */
	
    // Configure the cell...
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
//	id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	
	return [tableData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	NSLog(@"Selected row: %i", indexPath.row);
	CVEDetailsViewController *CVEDetailsVC=[[CVEDetailsViewController alloc] init];
	CVEDetailsVC.cveObject=[tableData objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:CVEDetailsVC animated:YES];
	[CVEDetailsVC release];
	
	
	
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	static NSString *cellIdentifier=@"scoreFooterCell";
	static NSString *CellNib=@"searchTableFooter";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell==nil){
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
		//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		cell=(UITableViewCell *) [nib objectAtIndex:0];
	}
	
	NSError *errorAlert;
	
	self.searchTableFooterLabel.text=[NSString stringWithFormat:@"%i Results", [tableData count]];
					
	return cell;
	
}



#pragma mark iAD Integration
- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.adBannerView = [[[classAdBannerView alloc] 
							  initWithFrame:CGRectZero] autorelease];
        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
														  ADBannerContentSizeIdentifier320x50, 
														  ADBannerContentSizeIdentifier480x32, nil]];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier320x50];            
        }
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0, 
											 -[self getBannerHeight])];
        [_adBannerView setDelegate:self];
		
        [self.view addSubview:_adBannerView];        
    }
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation {
    if (_adBannerView != nil) {        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
			 ADBannerContentSizeIdentifier320x50];
        }          
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible) {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 0;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 
			[self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height - 
			[self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
			NSLog(@"ContentView Frame Origin: %f x %f", contentViewFrame.origin.x, contentViewFrame.origin.y);
        } else {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 
			-[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            _contentView.frame = contentViewFrame;            
        }
        [UIView commitAnimations];
    }   
}

#pragma mark iADIntegration
- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}




#pragma mark ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (!_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}
 

#pragma mark exitView
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	NSLog(@"Did receive memory warning");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
	self.contentView = nil;
	self.adBannerView = nil;
	
	[self.HUD release], self.HUD=nil;
	
	[receivedData release], receivedData=nil;
	[cveSearchBar release], cveSearchBar=nil;
	[resultsTableViewController release], resultsTableViewController=nil;
	[tableData release], tableData=nil;
	[super dealloc];
}


@end
