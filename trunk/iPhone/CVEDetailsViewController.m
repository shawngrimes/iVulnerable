//
//  CVEDetailsViewController.m
//  Vulnerability_Search
//
//  Created by shawn on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CVEDetailsViewController.h"




@implementation CVEDetailsViewController

@synthesize webViewCVEDetails;
@synthesize cveObject;
@synthesize detailsTableView;
@synthesize descriptionTextView;
@synthesize exportCVEButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *CVERichText=[NSString stringWithFormat:@"<html><head><title>CVE Details for: %@ </title></head><body><STRONG>NAME:</STRONG> %@<BR><STRONG>Type:</STRONG>%@<br><STRONG>Description: </STRONG>%@<HR><BR><STRONG>References:</STRONG>", 
		cveObject.name,
		cveObject.name,
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
	NSLog(@"HTML: %@", CVERichText);

	//[self.webViewCVEDetails loadHTMLString:CVERichText baseURL:[NSURL URLWithString:@"http://cve.mitre.org"]];
	[self.detailsTableView reloadData];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 2;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 61.0;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if((indexPath.section==0) && (indexPath.row==3)){
		//return 100;
		
		NSLog(@"Content size: %f", self.descriptionTextView.contentSize.height);
		return [cveObject.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:CGSizeMake(300, 300) lineBreakMode:UILineBreakModeWordWrap ].height+20;
	}else if(indexPath.section==1){
		NSString *CVERichText;
		CVEReference *cveRef= [self.cveObject.references objectAtIndex:indexPath.row];
		if(cveRef.url){
			CVERichText=[NSString stringWithFormat:@"%@<a href=\"%@\">%@</a>",
						 cveRef.source, cveRef.url, cveRef.value];
		}else{
			CVERichText=[NSString stringWithFormat:@" %@(%@)",
						 cveRef.source, cveRef.value];
		}
		
		
		return [CVERichText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:CGSizeMake(200, 200) lineBreakMode:UILineBreakModeWordWrap ].height+44;
		
	}else{
		return 44;
	}
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
    //static NSString *CellNib=@"searchResultsCell";
	
	/*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      //  NSArray *nib=[[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		//cell=(UITableViewCell *) [nib objectAtIndex:0];
    }
*/
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
					cell.textLabel.text=cveObject.name;
					break;
				case 1:
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
					cell.textLabel.text=[@"Type: " stringByAppendingFormat:@"%@",cveObject.type];
					break;
				case 2:
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
					cell.textLabel.text=cveObject.cvedate;
					break;
				case 3:
					NSLog(@"description");
					
					NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"descriptionTableCell" owner:self options:nil];
					cell=(UITableViewCell *) [nib objectAtIndex:0];
					self.descriptionTextView.text=cveObject.description;
					self.descriptionTextView.font=[UIFont fontWithName:@"Helvetica" size:12.0];
					break;	
				default:
					break;
			};
			break;
		case 1:
			NSLog(@"Section 1");
			NSLog(@"Index Path Row: %i", indexPath.row);
			cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(cell.frame.origin.x+5, cell.frame.origin.y+5, cell.frame.size.width-20, cell.frame.size.height-20)];
			textView.editable=NO;
			textView.scrollEnabled=NO;
			textView.dataDetectorTypes=UIDataDetectorTypeLink;
			
			CVEReference *cveRef= [self.cveObject.references objectAtIndex:indexPath.row];
			NSString *CVERichText;
			if(cveRef.url){
				CVERichText=[NSString stringWithFormat:@"(%@) %@ %@",
							 cveRef.source, cveRef.value, cveRef.url ];
			}else{
				CVERichText=[NSString stringWithFormat:@" (%@)%@",
							 cveRef.source, cveRef.value];
			}
			textView.text=CVERichText;
			[cell.contentView addSubview:textView];
			textView.frame=CGRectMake(cell.frame.origin.x+5, cell.frame.origin.y+5, cell.frame.size.width-20, textView.contentSize.height);
			textView.backgroundColor=[UIColor clearColor];
			break;
		default:
			break;
	}
	
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
    // Configure the cell...
    return cell;
}

-(CGSize) GetSizeOfText: (NSString *) text{
	return [text sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake(220.0f, 50.0f)];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{
	//	id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	
	switch (section) {
		case 0:
			return 4;
			break;
		case 1:
			return [self.cveObject.references count];
			break;
		default:
			return 0;
			break;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	/*
	NSLog(@"Selected row: %i", indexPath.row);
	CVEDetailsViewController *CVEDetailsVC=[[CVEDetailsViewController alloc] init];
	CVEDetailsVC.cveObject=[tableData objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:CVEDetailsVC animated:YES];
	[CVEDetailsVC release];
	*/
	
	
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section{

	switch (section) {
		case 0:
			return @"CVE Details";
			break;
		case 1:
			return @"References";
			break;
		default:
			return 0;
			break;
	}
	
}

/*
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
*/

-(IBAction) exportCVE{
	/*
	exportCVEViewController *exportCVEVC = [[exportCVEViewController alloc] init];
	exportCVEVC.cveObject=self.cveObject;
	
	[self.navigationController pushViewController:exportCVEVC animated:YES];
	
//	[self presentModalViewController:exportCVEVC animated:YES];
	[exportCVEVC release];
	*/
	
	// Create the item to share (in this example, a url)
	NSString *mcafeeURLStringLookup=[NSString stringWithFormat:@"http://cve.mitre.org/cgi-bin/cvename.cgi?name=%@", cveObject.name];
	
	NSURL *url = [NSURL URLWithString:mcafeeURLStringLookup];
	SHKItem *item = [SHKItem URL:url title:[NSString stringWithFormat:@"%@, %@...", cveObject.name, [cveObject.description substringToIndex:100]]];

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
	
	item.text=CVERichText;
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromBarButtonItem:self.exportCVEButton animated:YES];
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
	
}


@end
