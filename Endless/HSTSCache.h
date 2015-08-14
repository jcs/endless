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

#define HSTS_HEADER @"Strict-Transport-Security"
#define HSTS_KEY_EXPIRATION @"expiration"
#define HSTS_KEY_ALLOW_SUBDOMAINS @"allowSubdomains"
#define HSTS_KEY_PRELOADED @"preloaded"

/* subclassing NSMutableDictionary is not easy, so we have to use composition */

@interface HSTSCache : NSObject
{
	NSMutableDictionary *_dict;
}

@property NSMutableDictionary *dict;

+ (HSTSCache *)retrieve;

- (void)persist;
- (NSURL *)rewrittenURI:(NSURL *)URL;
- (void)parseHSTSHeader:(NSString *)header forHost:(NSString *)host;

/* NSMutableDictionary composition pass-throughs */
- (id)objectForKey:(id)aKey;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (void)setValue:(id)value forKey:(NSString *)key;
- (void)removeObjectForKey:(id)aKey;
- (NSArray *)allKeys;

@end
