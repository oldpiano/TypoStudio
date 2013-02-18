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

// 받을 메일 주소
#define tsBugReporterDevMail		@"typ0s2d10@gmail.com"
// 임시 패키지 리스트 파일
#define tsBugReporterLogFileDPKG	@"/var/mobile/Library/Logs/dpkgl.log"

// 첨부할 크래쉬 리포트
#ifndef tsBugReporterCrashReporter
#define tsBugReporterCrashReporter	@"/var/mobile/Library/Logs/CrashReporter/LatestCrash.plist"
#endif

// 패키지 정보 - 메일제목에 씀
#ifndef tsPacakgeTitle
#define tsPacakgeTitle              @""
#define tsPackageVersion            @"1.0"
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
