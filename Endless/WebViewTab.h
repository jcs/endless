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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ZOOM_OUT_SCALE 0.8

typedef NS_ENUM(NSInteger, WebViewTabSecureMode) {
	WebViewTabSecureModeInsecure,
	WebViewTabSecureModeMixed,
	WebViewTabSecureModeSecure,
	WebViewTabSecureModeSecureEV,
};

@interface WebViewTab : NSObject <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (strong, atomic) UIView *viewHolder;
@property (strong, atomic) UIWebView *webView;
@property (strong, atomic) NSURL *url;
@property BOOL needsRefresh;
@property (strong, atomic) NSNumber *tabIndex;
@property (strong, atomic) UIView *titleHolder;
@property (strong, atomic) UILabel *title;
@property (strong, atomic) UILabel *closer;
@property (strong, nonatomic) NSNumber *progress;

@property WebViewTabSecureMode secureMode;
@property (strong, atomic) NSString *evOrgName;
@property NSMutableDictionary *applicableHTTPSEverywhereRules;

/* for javascript IPC */
@property (strong, atomic) NSString *randID;
@property (strong, atomic) NSNumber *openedByTabHash;

+ (WebViewTab *)openedWebViewTabByRandID:(NSString *)randID;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame withRestorationIdentifier:(NSString *)rid;
- (void)close;
- (void)updateFrame:(CGRect)frame;
- (void)loadURL:(NSURL *)u;
- (void)searchFor:(NSString *)query;
- (BOOL)canGoBack;
- (BOOL)canGoForward;
- (void)goBack;
- (void)goForward;
- (void)refresh;
- (void)forceRefresh;
- (void)zoomOut;
- (void)zoomNormal;

@end
