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
#import "CKHTTPConnection.h"

#define REWRITTEN_KEY @"_rewritten"
#define ORIGIN_KEY @"_origin"
#define WVT_KEY @"_wvt"

#define CONTENT_TYPE_OTHER	0
#define CONTENT_TYPE_HTML	1
#define CONTENT_TYPE_JAVASCRIPT	2
#define CONTENT_TYPE_IMAGE	3

#define ENCODING_DEFLATE	1
#define ENCODING_GZIP		2

@interface URLInterceptor : NSURLProtocol <CKHTTPConnectionDelegate> {
	NSMutableData *_data;
	NSURLRequest *_request;
	NSUInteger encoding;
	NSUInteger contentType;
	Boolean firstChunk;
}

@property (strong) NSURLRequest *actualRequest;
@property (assign) BOOL isOrigin;
@property (strong) NSString *evOrgName;
@property (strong) CKHTTPConnection *connection;

+ (NSString *)javascriptToInject;
+ (void)setBlockIntoLocalNets:(BOOL)val;
+ (void)setSendDNT:(BOOL)val;
+ (void)temporarilyAllow:(NSURL *)url;

- (NSMutableData *)data;
- (NSData *)htmlDataWithJavascriptInjection:incomingData;
- (NSData *)javascriptDataWithJavascriptInjection:incomingData;

@end
