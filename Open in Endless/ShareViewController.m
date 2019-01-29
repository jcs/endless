/*
 * Endless
 * Copyright (c) 2018 joshua stein <jcs@jcs.org>
 *
 * See LICENSE file for redistribution terms.
 */

#import <MobileCoreServices/MobileCoreServices.h>
#import "ShareViewController.h"

@implementation ShareViewController
{
	NSURL *url;
}

- (id)init
{
	if (self = [super init])
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	return self;
}

- (void)keyboardWillShow:(NSNotification *)note
{
	[self.view endEditing:true];
}

- (BOOL)isContentValid
{
	NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
	for (NSItemProvider *itemProvider in item.attachments) {
		if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
			[itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:@{} completionHandler:^(id<NSSecureCoding> _Nullable item, NSError * _Null_unspecified error) {
				url = (NSURL *)item;
			}];
		}
	}
	
	return YES;
}

- (void)didSelectPost
{
}

- (NSArray *)configurationItems
{
	NSString *eurl = [url absoluteString];
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^http(s)?://" options:NSRegularExpressionCaseInsensitive error:nil];
	eurl = [regex stringByReplacingMatchesInString:eurl options:0 range:NSMakeRange(0, [eurl length]) withTemplate:@"endlesshttp$1://"];
	if ([eurl containsString:@"endlesshttp"]) {
		UIResponder *responder = self;
		while (responder) {
			if ([responder respondsToSelector: @selector(openURL:)]) {
				[responder performSelector: @selector(openURL:) withObject:[NSURL URLWithString:eurl]];
			}
			responder = [responder nextResponder];
		}
	
		[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
	}
	
	return @[];
}

@end
