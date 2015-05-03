//
//  RZDBCoalesce.h
//
//  Created by Rob Visentin on 4/1/15.

// Copyright 2014 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#pragma mark - NSObject+RZDBCoalesce interface

/**
 *  Provides an interface for supporting coalesced data binding callbacks.
 */
@interface NSObject (RZDBCoalesce)

/**
 *  Returns a proxy object that will participate in coalescing events.
 *
 *  Use [target rz_coalesceProxy] as the target of the rz_addTarget:action: methods to support
 *  coalescing for a target/action pair. If the callback occurs during a an RZDBCoalesce event, it will be
 *  coalesced and deferred until the end RZDBCoalesce is committed.
 *
 *  @note You should generally not call methods on the coalesce proxy directly. 
 *  The proxy will treat any 0-arg or 1-dictionary-arg methods with void return type as RZDB callbacks,
 *  and coalesce them accordingly.
 *
 *  @see RZDBCoalesce for how to begin/end coalesce events.
 *
 *  @return A proxy object to use as a data binding target in the rz_addTarget:action: methods.
 */
- (id)rz_coalesceProxy;

@end

#pragma mark - RZDBCoalesce interface

/**
 *  There may be chunks of work that should be completed "atomically" with respect to RZDataBinding.
 *  That is, actions registered using the rz_addTarget:action: methods that support coalescing
 *  will be fired once, when the work is completed.
 *
 *  The RZDBCoalesce object provides class methods to manage coalescing events.
 *
 *  Coalescing is an advanced feature that should generally only be used if you encounter a performance issue,
 *  or find some other requirement for it.
 *
 *  @see NSObject+RZDBCoalesce for how to support coalesced callbacks.
 */
@interface RZDBCoalesce : NSObject

/**
 *  Begin coalescing events for the current thread.
 *  Changes that occur during the coalesce that would trigger actions registered to coalesce proxies with
 *  the rz_addTarget:action: methods are instead coalesced and executed once when the coalesce ends.
 *
 *  Every call to +begin MUST be balanced by a call to +commit on the same thread.
 *  It is fine to begin a coalesce while already coalescing--
 *  the coalesce will simply not end until both matching commits are hit.
 *
 *  @note Bindings that occur during a coalesce still occur immediately.
 *
 *  @see NSObject+RZDBCoalesce for how to support coalesced callbacks.
 */
+ (void)begin;

/**
 *  Commit the current coalesce, sending the coalesced change callbacks.
 *  If this commit closes a nested coalesce, callbacks are not sent until the outermost coalesce is committed.
 *
 *  Calling this method from outside a coalesce has no effect.
 */
+ (void)commit;

/**
 *  Convenience method that first calls +begin, then executes the block, then calls +commit.
 *  You should prefer this method where possible to avoid programmer error (i.e. forgetting to call +commit).
 *
 *  @param coalesceBlock The block to execute inside a coalesce. Must be non-nil.
 *
 *  @see NSObject+RZDBCoalesce for how to support coalesced callbacks.
 */
+ (void)coalesceBlock:(void (^)())coalesceBlock;

/**
 *  Cannot instantiate RZDBCoalesce directly. Use the class methods instead.
 */
- (instancetype)init __attribute__((unavailable("Cannot instantiate RZDBCoalesce directly. Use the class methods instead.")));

@end
