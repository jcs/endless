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

#import "URLBlocker.h"

@implementation URLBlocker

static NSDictionary *_targets;
static NSCache *ruleCache;

#define RULE_CACHE_SIZE 20

+ (NSDictionary *)targets
{
	if (_targets == nil) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"urlblocker_targets" ofType:@"plist"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSLog(@"[URLBlocker] no target plist at %@", path);
			abort();
		}
		
		_targets = [NSDictionary dictionaryWithContentsOfFile:path];
		
#ifdef TRACE_URL_BLOCKER
		NSLog(@"[URLBlocker] locked and loaded with %lu target domains", [_targets count]);
#endif
	}
	
	return _targets;
}

+ (void)cacheBlockedURL:(NSURL *)url withRule:(NSString *)rule
{
	if (!ruleCache) {
		ruleCache = [[NSCache alloc] init];
		[ruleCache setCountLimit:RULE_CACHE_SIZE];
	}
	
	[ruleCache setObject:rule forKey:url];
}

+ (NSString *)blockRuleForURL:(NSURL *)url
{
	NSString *blocker;
	
	if (!(ruleCache && (blocker = [ruleCache objectForKey:url]))) {
		NSString *host = [[url host] lowercaseString];
		
		blocker = [[[self class] targets] objectForKey:host];
		
		if (!blocker) {
			/* now for x.y.z.example.com, try *.y.z.example.com, *.z.example.com, *.example.com, etc. */
			/* TODO: should we skip the last component for obviously non-matching things like "*.com", "*.net"? */
			NSArray *hostp = [host componentsSeparatedByString:@"."];
			for (int i = 1; i < [hostp count]; i++) {
				NSString *wc = [[hostp subarrayWithRange:NSMakeRange(i, [hostp count] - i)] componentsJoinedByString:@"."];
				
				if ((blocker = [[[self class] targets] objectForKey:wc]) != nil) {
					break;
				}
			}
		}
	}
	
	if (blocker) {
		[[self class] cacheBlockedURL:url withRule:blocker];
	}
	
	return blocker;
}

+ (BOOL)shouldBlockURL:(NSURL *)url
{
	return ([self blockRuleForURL:url] != nil);
}

+ (BOOL)shouldBlockURL:(NSURL *)url fromMainDocumentURL:(NSURL *)mainUrl
{
	/* if this same rule would have blocked our main URL, allow it since the user is probably viewing this site and this isn't a sneaky tracker */
	if (mainUrl != nil && [url isEqual:mainUrl])
		return NO;
	
	NSString *blocker = [self blockRuleForURL:url];
	if (blocker != nil && mainUrl != nil) {
		if ([blocker isEqualToString:[self blockRuleForURL:mainUrl]]) {
			return NO;
		}
		
#ifdef TRACE_URL_BLOCKER
		NSLog(@"[URLBlocker] blocking %@ (via %@) (%@)", url, mainUrl, blocker);
#endif
		
		return YES;
	}
	
	return NO;
}

@end
