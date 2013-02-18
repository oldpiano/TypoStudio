//
//  tsBugReporter.m
//  TypoStudio
//
//  Created by 낡은피아노 on 12. 10. 15..
//  Copyright (c) 2012년 TypoStudio. All rights reserved.
//

#import "tsBugReporter.h"
#import "tsHudManager.m"

static tsBugReporter *bugReporter;

@implementation tsBugReporter

@synthesize bundle, bundleTableName, attachments;
@synthesize barButton, navigationController, webView;

+ (id)sharedReporter
{
	if (!bugReporter) {
		bugReporter = [[tsBugReporter alloc] init];
	}
	
	return bugReporter;
}

- (void)setBarButton:(UIBarButtonItem *)button
{
	button.target = self;
	button.action = @selector(showActionSheet:);
	barButton = button;
}

- (id)init
{
	self = [super init];
	
	bundle = [NSBundle mainBundle];
	bundleTableName = @"tsBugReporter";
	
	return self;
}

- (void)dealloc
{
	[attachments release];
	[bundleTableName release];
	[super dealloc];
}

- (NSString *)localizedStringForKey:(NSString *)key
{
	return [bundle localizedStringForKey:key value:nil table:bundleTableName];
}

- (void)showMailComposer
{
	if (![MFMailComposeViewController canSendMail]) return;
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		controller.modalInPopover = YES;
		controller.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	UIDevice *device = [UIDevice currentDevice];
//	NSLog(@"%@", [device uniqueIdentifier]);
	
	[controller setSubject:[NSString stringWithFormat:[self localizedStringForKey:@"Subject"], tsPacakgeTitle, tsPackageVersion]];
	[controller setToRecipients:[NSArray arrayWithObject:tsBugReporterDevMail]];
	[controller setMessageBody:[NSString stringWithFormat:[self localizedStringForKey:@"Body"],
								[device platformString],
								[device systemVersion],
								[device uniqueIdentifier], nil]
				  isHTML:NO];

	NSFileManager *fm = [NSFileManager defaultManager];
	
	system([[NSString stringWithFormat:@"dpkg -l > %@", tsBugReporterLogFileDPKG] cStringUsingEncoding:NSUTF8StringEncoding]);
	if ([fm fileExistsAtPath:tsBugReporterLogFileDPKG]) {
		[controller addAttachmentData:[NSData dataWithContentsOfFile:tsBugReporterLogFileDPKG]
					   mimeType:@"text/plain"
					   fileName:[tsBugReporterLogFileDPKG lastPathComponent]];
	}
	
	if ([fm fileExistsAtPath:tsBugReporterCrashReporter]) {
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:tsBugReporterCrashReporter];
		[controller addAttachmentData:[[dict objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding]
					   mimeType:@"text/plain"
					   fileName:@"CrashLog.crash"];
	}
	
	for (NSString *path in attachments) {
		BOOL isDir;
		if ([fm fileExistsAtPath:path isDirectory:&isDir] && isDir) {
			NSError *error = nil;
			NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:path] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLContentModificationDateKey] options:0 error:&error];
			if (error) continue;

			NSMutableDictionary *urlWithDate = [NSMutableDictionary dictionaryWithCapacity:list.count];
			for (NSURL *f in list) {
			    NSDate *date;
			    if ([f getResourceValue:&date forKey:NSURLContentModificationDateKey error:&error]) {
			        [urlWithDate setObject:date forKey:f];
			    }
			}

			list = [urlWithDate keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			    return [obj2 compare:obj1];
			}];
			for (int i = 0; i < MIN(3, list.count); i++) {
				NSURL *url = [list objectAtIndex:i];
				[controller addAttachmentData:[NSData dataWithContentsOfURL:url]
									 mimeType:@"text/plain"
									 fileName:[url lastPathComponent]];
			}
		}
		else if ([fm fileExistsAtPath:path]) {
			[controller addAttachmentData:[NSData dataWithContentsOfFile:path]
								 mimeType:@"text/plain"
								 fileName:[path lastPathComponent]];
		}
	}
	
	[navigationController presentModalViewController:controller animated:YES];
	[controller release];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark UIActionSheet

- (void)showActionSheet:(id)sender
{
	UIActionSheet *sheet = [[[UIActionSheet alloc] init] autorelease];
	sheet.delegate = self;
	sheet.title = [NSString stringWithFormat:@"%@ %@ © typ0s2d10", tsPacakgeTitle, tsPackageVersion];
	
	if (webView) {
		[sheet addButtonWithTitle:[self localizedStringForKey:@"Open via Safari"]];
	}
	
	[sheet addButtonWithTitle:[self localizedStringForKey:@"Bug Report"]];
	[sheet addButtonWithTitle:[self localizedStringForKey:@"Cancel"]];
	
	sheet.destructiveButtonIndex = sheet.numberOfButtons - 2;
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
	
	[sheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.numberOfButtons - 2) {
		[self showMailComposer];
	}
	else if (buttonIndex == actionSheet.numberOfButtons - 3) {
		[[UIApplication sharedApplication] openURL:webView.request.URL];
	}
}

@end
