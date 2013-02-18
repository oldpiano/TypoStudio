//
//  tsBugReporter.h
//  TypoStudio
//
//  Created by 낡은피아노 on 12. 10. 15..
//  Copyright (c) 2012년 TypoStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "../Erica/uidevice-extension/UIDevice-Hardware.h"

#define tsBugReporterDevMail		@"typ0s2d10@gmail.com"
#define tsBugReporterLogFileDPKG	@"/var/mobile/Library/Logs/dpkgl.log"

#ifndef tsBugReporterCrashReporter
#define tsBugReporterCrashReporter	@"/var/mobile/Library/Logs/CrashReporter/LatestCrash.plist"
#endif


@interface tsBugReporter : NSObject <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) NSBundle *bundle;
@property (nonatomic, retain) NSString *bundleTableName;
@property (nonatomic, retain) NSArray *attachments;

@property (nonatomic, assign) UIBarButtonItem *barButton;
@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) UIWebView *webView;

+ (id)sharedReporter;

- (void)showMailComposer;
- (void)showActionSheet:(id)sender;

@end
