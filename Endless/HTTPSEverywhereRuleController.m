/*
 * Endless
 * Copyright (c) 2014-2015 joshua stein <jcs@jcs.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "HTTPSEverywhereRuleController.h"
#import "HTTPSEverywhere.h"
#import "HTTPSEverywhereRule.h"

@implementation HTTPSEverywhereRuleController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(dismissModalViewControllerAnimated:)];

	self.sortedRuleNames = [[NSMutableArray alloc] initWithCapacity:[[HTTPSEverywhere rules] count]];
	
	if ([[self.appDelegate webViewController] curWebViewTab] != nil) {
		self.inUseRuleNames = [[NSMutableArray alloc] initWithArray:[[[[[self.appDelegate webViewController] curWebViewTab] applicableHTTPSEverywhereRules] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	}
	else {
		self.inUseRuleNames = [[NSMutableArray alloc] init];
	}
	
	for (NSString *k in [[HTTPSEverywhere rules] allKeys]) {
		if (![self.inUseRuleNames containsObject:k])
			[self.sortedRuleNames addObject:k];
	}
	
	self.sortedRuleNames = [NSMutableArray arrayWithArray:[self.sortedRuleNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	self.searchResult = [NSMutableArray arrayWithCapacity:[self.sortedRuleNames count]];
	
	self.title = @"HTTPS Everywhere Rules";
	
	return self;
}

- (NSString *)ruleDisabledReason:(NSString *)rule
{
	return [[HTTPSEverywhere disabledRules] objectForKey:rule];
}

- (void)disableRuleByName:(NSString *)rule withReason:(NSString *)reason
{
	[HTTPSEverywhere disableRuleByName:rule withReason:reason];
}

- (void)enableRuleByName:(NSString *)rule
{
	[HTTPSEverywhere enableRuleByName:rule];
}

@end
