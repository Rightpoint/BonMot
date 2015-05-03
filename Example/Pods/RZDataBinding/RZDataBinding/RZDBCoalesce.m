//
//  RZDBCoalesce.m
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

#import <objc/runtime.h>
#import <objc/message.h>

#import "RZDBCoalesce.h"

#import "NSObject+RZDataBinding.h"

static NSString* const kRZDBCoalesceStorageKey = @"RZDBCoalesce";

#pragma mark - RZDBNotification interface

@interface RZDBNotification : NSObject

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@property (strong, nonatomic) NSMutableDictionary *changeDict;

+ (instancetype)notificationWithInvocation:(NSInvocation *)invocation;

- (void)send;

@end

#pragma mark - RZDBCoalesceProxy interface

@interface RZDBCoalesceProxy : NSProxy

@property (assign, nonatomic) __unsafe_unretained id representedObject;

+ (instancetype)proxyForObject:(id)object;

@end

#pragma mark - RZDBCoalesce private interface

@interface RZDBCoalesce ()

@property (assign, nonatomic) NSInteger beginCount;
@property (strong, nonatomic, readonly) NSMutableArray *notifications;

@end

#pragma mark - RZDBCoalesce implementation

@implementation RZDBCoalesce

+ (void)begin
{
    RZDBCoalesce *current = [self currentCoalesce];

    if ( current == nil ) {
        [self setCurrentCoalesce:[[self alloc] init]];
    }
    else {
        current.beginCount++;
    }
}

+ (void)commit
{
    RZDBCoalesce *current = [self currentCoalesce];
    current.beginCount--;

    if ( current.beginCount == 0 ) {
        [self setCurrentCoalesce:nil];
        [current.notifications enumerateObjectsUsingBlock:^(RZDBNotification *notification, NSUInteger idx, BOOL *stop) {
            [notification send];
        }];
    }
}

+ (void)coalesceBlock:(void (^)())coalesceBlock
{
    NSParameterAssert(coalesceBlock);

    [RZDBCoalesce begin];
    coalesceBlock();
    [RZDBCoalesce commit];
}

#pragma mark - private methods

+ (RZDBCoalesce *)currentCoalesce
{
    return [NSThread currentThread].threadDictionary[kRZDBCoalesceStorageKey];
}

+ (void)setCurrentCoalesce:(RZDBCoalesce *)current
{
    if ( current != nil ) {
        [NSThread currentThread].threadDictionary[kRZDBCoalesceStorageKey] = current;
    }
    else {
        [[NSThread currentThread].threadDictionary removeObjectForKey:kRZDBCoalesceStorageKey];
    }
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _beginCount = 1;
        _notifications = [NSMutableArray array];
    }

    return self;
}

- (void)addNotification:(RZDBNotification *)notification
{
    NSUInteger existingIdx = [self.notifications indexOfObjectPassingTest:^BOOL(RZDBNotification *existing, NSUInteger idx, BOOL *stop) {
        return [notification isEqual:existing];
    }];

    if ( existingIdx != NSNotFound ) {
        RZDBNotification *existing = self.notifications[existingIdx];

        if ( notification.changeDict[kRZDBChangeKeyNew] != nil ) {
            existing.changeDict[kRZDBChangeKeyNew] = notification.changeDict[kRZDBChangeKeyNew];
        }
        else {
            [existing.changeDict removeObjectForKey:kRZDBChangeKeyNew];
        }
    }
    else {
        [self.notifications addObject:notification];
    }
}

@end

#pragma mark - RZDBNotification implementation

@implementation RZDBNotification

+ (instancetype)notificationWithInvocation:(NSInvocation *)invocation
{
    RZDBNotification *notification = nil;

    NSMethodSignature *methodSig = invocation.methodSignature;

    // rzdb callbacks must have void return type, and
    // if there are any arguments, the first and only argument must be a dictionary
    if ( methodSig.methodReturnLength == 0 && (methodSig.numberOfArguments == 2 || methodSig.numberOfArguments == 3) ) {
        notification = [[self alloc] init];
        notification.target = invocation.target;
        notification.action = invocation.selector;

        if ( methodSig.numberOfArguments == 3 && strcmp([methodSig getArgumentTypeAtIndex:2], @encode(id)) == 0 ) {
            __unsafe_unretained id arg1;
            [invocation getArgument:&arg1 atIndex:2];

            if ( [arg1 isKindOfClass:[NSDictionary class]] ) {
                notification.changeDict = [arg1 mutableCopy];
            }
            else {
                notification = nil;
            }
        }
    }

    return notification;
}

- (BOOL)isEqual:(id)object
{
    BOOL equal = [super isEqual:object];

    if ( !equal && [object isKindOfClass:[RZDBNotification class]] ) {
        RZDBNotification *other = (RZDBNotification *)object;

        equal = (self.target == other.target) &&
        (self.action == other.action) &&
        (self.changeDict == other.changeDict ||
         (self.changeDict[kRZDBChangeKeyObject] == other.changeDict[kRZDBChangeKeyObject] &&
          [self.changeDict[kRZDBChangeKeyKeyPath] isEqualToString:other.changeDict[kRZDBChangeKeyKeyPath]]
          )
         );
    }

    return equal;
}

- (void)send
{
    if ( self.target != nil && self.action != NULL ) {
        if ( self.changeDict != nil ) {
            ((void(*)(id, SEL, NSDictionary *))objc_msgSend)(self.target, self.action, [self.changeDict copy]);
        }
        else {
            ((void(*)(id, SEL))objc_msgSend)(self.target, self.action);
        }
    }
}

@end

#pragma mark - NSObject+RZDBCoalesce implementation

@implementation NSObject (RZDBCoalesce)

- (id)rz_coalesceProxy
{
    @synchronized (self) {
        id proxy = objc_getAssociatedObject(self, _cmd);

        if ( proxy == nil ) {
            proxy = [RZDBCoalesceProxy proxyForObject:self];
            objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        return proxy;
    }
}

@end

#pragma mark - RZDBCoalesceProxy implementation

@implementation RZDBCoalesceProxy

+ (instancetype)proxyForObject:(id)object
{
    RZDBCoalesceProxy *proxy = [self alloc];
    proxy.representedObject = object;

    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.representedObject methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    invocation.target = self.representedObject;

    RZDBCoalesce *currentCoalesce = [RZDBCoalesce currentCoalesce];

    if ( currentCoalesce != nil ) {
        // notificaton will be non-nil for a valid RZDataBinding callback
        RZDBNotification *notification = [RZDBNotification notificationWithInvocation:invocation];

        if ( notification != nil ) {
            [currentCoalesce addNotification:notification];
        }
        else {
            [invocation invoke];
        }
    }
    else {
        [invocation invoke];
    }
}

@end

