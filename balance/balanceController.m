//
//  balanceController.m
//  balance
//
//  Created by Alexandr Balyberdin on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "balanceController.h"

@implementation balanceController

-(id)init
{
	if ((self = [super init]))
	{
	}

	return self;
}

-(void)dealloc
{
	[_view release];
	[balanceView release];
	[settingsView release];
	[super dealloc];
}

- (UIView *)view
{
	if (_view == nil)
	{
		_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 71)];
		
		UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/balance.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:71];

		UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
		bgView.frame = CGRectMake(2, 0, 316, 71);

		UIImageView *bgSet = [[UIImageView alloc] initWithImage:bg];
		bgSet.frame = CGRectMake(6, 0, 316, 71);

		sv = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 71)] autorelease];
		sv.contentSize = CGSizeMake(2 * 320, 71);
		sv.pagingEnabled = YES;
		sv.delegate = self;

		for (int i = 0; i < 1; i++)
		{
			balanceView = [[UIView alloc] initWithFrame:CGRectMake(i * 316, 0, 316, 71)];
			[balanceView addSubview:bgView];
			
			lblName = [[UILabel alloc] initWithFrame:CGRectMake(9, 5, 285, 15)];
			lblName.backgroundColor = [UIColor clearColor];
			lblName.textColor = [UIColor whiteColor];
			lblName.font = [UIFont systemFontOfSize: 12.0];
			lblName.text = @"Фамилия Имя Отчество";
			lblName.alpha = 1;
			[balanceView addSubview:lblName];
			[lblName release];
			
			lblText = [[UILabel alloc] initWithFrame:CGRectMake(9, 18, 75, 15)];
			lblText.backgroundColor = [UIColor clearColor];
			lblText.textColor = [UIColor whiteColor];
			lblText.font = [UIFont systemFontOfSize: 12.0];
			lblText.text = @"Ваш баланс:";
			lblText.alpha = 0.6;
			[balanceView addSubview:lblText];
			[lblText release];
			
			lblDate = [[UILabel alloc] initWithFrame:CGRectMake(9, 38, 114, 28)];
			lblDate.backgroundColor = [UIColor clearColor];
			lblDate.textColor = [UIColor whiteColor];
			lblDate.font = [UIFont systemFontOfSize: 12.0];
			lblDate.numberOfLines = 2;
			lblDate.text = @"Хватит примерно на 0 дней";
			lblDate.alpha = 0.6;
			[balanceView addSubview:lblDate];
			[lblDate release];
			
			lblBalance = [[UILabel alloc] initWithFrame:CGRectMake(135, 22, 175, 45)];
			lblBalance.backgroundColor = [UIColor clearColor];
			lblBalance.textColor = [UIColor whiteColor];
			lblBalance.font = [UIFont fontWithName: @"Helvetica-Light" size: 45.0];
			lblBalance.textAlignment = UITextAlignmentRight;
			lblBalance.text = @"0.0";
			lblBalance.alpha = 1;
			[balanceView addSubview:lblBalance];
			[lblBalance release];
			
			[sv addSubview:balanceView];
			[balanceView release];		
		}
		for (int i = 1; i < 2; i++)
		{
			settingsView = [[UIView alloc] initWithFrame:CGRectMake(i * 316, 0, 316, 71)];
			[settingsView addSubview:bgSet];
			
			loginField = [[UITextField alloc] initWithFrame:CGRectMake(330, 7, 300, 25)];
			loginField.borderStyle = UITextBorderStyleRoundedRect;
			loginField.textColor = [UIColor blackColor];
			loginField.font = [UIFont systemFontOfSize:14.0];
			loginField.placeholder = @"Логин";
			loginField.backgroundColor = [UIColor whiteColor];
			loginField.autocorrectionType = UITextAutocorrectionTypeNo;
			loginField.keyboardType = UIKeyboardTypeDefault; 
			loginField.returnKeyType = UIReturnKeyNext; 
			loginField.clearButtonMode = UITextFieldViewModeWhileEditing;
			loginField.keyboardAppearance = UIKeyboardAppearanceAlert;
			loginField.delegate = self;
			loginField.tag = 999;
			[sv addSubview:loginField];

			passField = [[UITextField alloc] initWithFrame:CGRectMake(330, 39, 300, 25)];
			passField.borderStyle = UITextBorderStyleRoundedRect;
			passField.textColor = [UIColor blackColor]; 
			passField.font = [UIFont systemFontOfSize:14.0];
			passField.placeholder = @"Пароль";
			passField.secureTextEntry = TRUE;
			passField.backgroundColor = [UIColor whiteColor];
			passField.autocorrectionType = UITextAutocorrectionTypeNo;
			passField.keyboardType = UIKeyboardTypeDefault;
			passField.returnKeyType = UIReturnKeyDone; 
			passField.clearButtonMode = UITextFieldViewModeWhileEditing;
			passField.keyboardAppearance = UIKeyboardAppearanceAlert;
			passField.delegate = self;
			[sv addSubview:passField];
			
			[sv addSubview:settingsView];
			[settingsView release];		
		}
		
//		[bgView release];
		[_view addSubview:sv];

		[[loginField superview] bringSubviewToFront:loginField];
		[[passField superview] bringSubviewToFront:passField];
		
		[sv setShowsHorizontalScrollIndicator:NO];
		[sv setShowsVerticalScrollIndicator:NO];
	}

	return _view;
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	[loginField resignFirstResponder];
	[passField resignFirstResponder];
}
	
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag == 999) {
		[passField becomeFirstResponder];
	} else {
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:loginField.text forKey:@"login"];	
		[prefs setObject:passField.text forKey:@"pass"];	
		[prefs synchronize];

		[textField resignFirstResponder];
		[self getBalance];
	}
	
    return YES;
}


- (void)viewWillAppear 
{
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getBalance) userInfo:nil repeats:NO];
}

- (void)getBalance 
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *gnLookup = [NSString stringWithFormat:
						  @"https://billing.novotelecom.ru/billing/user/api/?method=userInfo&login=%@&password=%@", 
						  [prefs objectForKey:@"login"], 
						  [prefs objectForKey:@"pass"]];
	
	NSXMLParser *gnParser = [[NSXMLParser alloc] initWithContentsOfURL: [NSURL URLWithString:gnLookup]];
	[gnParser setDelegate:self];
	[gnParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName compare:@"name"] == NSOrderedSame) {
		ntkUser = [[NSMutableString alloc] initWithCapacity:4];
	}	
	if ([elementName compare:@"days2BlockStr"] == NSOrderedSame) {
		ntkUpToDate = [[NSMutableString alloc] initWithCapacity:4];
	}
	if ([elementName compare:@"balance"] == NSOrderedSame) {
		ntkBalance = [[NSMutableString alloc] initWithCapacity:4];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (ntkUser && string) {
		[ntkUser appendString:string];
	}	
	if (ntkUpToDate && string) {
		[ntkUpToDate appendString:string];
	}
	if (ntkBalance && string) {
		[ntkBalance appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName compare:@"name"] == NSOrderedSame) {
		lblName.text = [NSString stringWithFormat:@"%@", ntkUser];
	}	
	if ([elementName compare:@"days2BlockStr"] == NSOrderedSame) {
		lblDate.text = [NSString stringWithFormat:@"%@", ntkUpToDate];
	}
	if ([elementName compare:@"balance"] == NSOrderedSame) {
		lblBalance.text = [NSString stringWithFormat:@"%@", ntkBalance];
	}			
}


- (float)viewHeight
{
	return 71.0f;
}

@end