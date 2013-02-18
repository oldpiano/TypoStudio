//
//  tsHudManager.m
//  TypoStudio
//
//  Created by 낡은피아노 on 12. 10. 15..
//  Copyright (c) 2012년 TypoStudio. All rights reserved.
//

#import <UIKit/UIProgressHUD.h>

static UIProgressHUD *hud = nil;

@interface UIProgressHUD (typ0s2d10)
+ (void)show:(NSString *)msg inView:(UIView *)view;
+ (void)close;
@end

@implementation UIProgressHUD (typ0s2d10)

+ (void)show:(NSString *)msg inView:(UIView *)view
{
	hud = [[UIProgressHUD alloc] init];
	[hud setText:msg];
	[hud showInView:view];
}

+ (void)close
{
	if (hud == nil) return;
	 [hud hide];
	 [hud removeFromSuperview];
	 [hud release];
	 hud = nil;
}

@end