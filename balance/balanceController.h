//
//  balanceController.h
//  balance
//
//  Created by Alexandr Balyberdin on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BBWeeAppController-Protocol.h>

@interface balanceController : NSObject <BBWeeAppController, UIScrollViewDelegate, UITextFieldDelegate, NSXMLParserDelegate>
{
	UILabel *lblName;
	UILabel *lblText;
	UILabel *lblDate;
	UILabel *lblBalance;
	
	UIView *_view;
	UIView *balanceView, *settingsView;

	UIScrollView *sv;
	
	UITextField * loginField;
	UITextField * passField;
	
	NSMutableString *ntkUser;
	NSMutableString *ntkUpToDate;
	NSMutableString *ntkBalance;
}

- (UIView *)view;
- (void)viewWillAppear;
- (void)getBalance;

@end