//
//  NSObject+RZDataBinding.m
//
//  Created by Rob Visentin on 9/17/14.

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

#import "NSObject+RZDataBinding.h"

@class RZDBObserver;
@class RZDBObserverContainer;

// public change keys
NSString* const kRZDBChangeKeyObject  = @"RZDBChangeObject";
NSString* const kRZDBChangeKeyOld     = @"RZDBChangeOld";
NSString* const kRZDBChangeKeyNew     = @"RZDBChangeNew";
NSString* const kRZDBChangeKeyKeyPath = @"RZDBChangeKeyPath";

// private change keys
static NSString* const kRZDBChangeKeyBoundKey           = @"_RZDBChangeBoundKey";
static NSString* const kRZDBChangeKeyBindingFunctionKey = @"_RZDBChangeBindingFunction";

static NSString* const kRZDBDefaultSelectorPrefix = @"rzdb_default_";

static void* const kRZDBKVOContext = (void *)&kRZDBKVOContext;

#define RZDBNotNull(obj) ((obj) != nil && ![(obj) isEqual:[NSNull null]])

#pragma mark - RZDataBinding_Private interface

@interface NSObject (RZDataBinding_Private)

- (NSMutableArray *)rz_registeredObservers;
- (void)rz_setRegisteredObservers:(NSMutableArray *)registeredObservers;

- (RZDBObserverContainer *)rz_dependentObservers;
- (void)rz_setDependentObservers:(RZDBObserverContainer *)dependentObservers;

- (void)rz_addTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey bindingFunction:(RZDBKeyBindingFunction)bindingFunction forKeyPath:(NSString *)keyPath withOptions:(NSKeyValueObservingOptions)options;
- (void)rz_removeTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey forKeyPath:(NSString *)keyPath;
- (void)rz_observeBoundKeyChange:(NSDictionary *)change;
- (void)rz_setBoundKey:(NSString *)key withValue:(id)value function:(RZDBKeyBindingFunction)function;
- (void)rz_cleanupObservers;

@end

#pragma mark - RZDBObserver interface

@interface RZDBObserver : NSObject;

@property (assign, nonatomic) __unsafe_unretained NSObject *observedObject;
@property (copy, nonatomic) NSString *keyPath;
@property (copy, nonatomic) NSString *boundKey;
@property (assign, nonatomic) NSKeyValueObservingOptions observationOptions;

@property (assign, nonatomic) __unsafe_unretained id target;
@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) NSMethodSignature *methodSignature;

@property (copy, nonatomic) RZDBKeyBindingFunction bindingFunction;

- (instancetype)initWithObservedObject:(NSObject *)observedObject keyPath:(NSString *)keyPath observationOptions:(NSKeyValueObservingOptions)observingOptions;

- (void)setTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey bindingFunction:(RZDBKeyBindingFunction)bindingFunction;

- (void)invalidate;

@end

#pragma mark - RZDBObserverContainer interface

@interface RZDBObserverContainer : NSObject

@property (strong, nonatomic) NSPointerArray *observers;

- (void)addObserver:(RZDBObserver *)observer;
- (void)removeObserver:(RZDBObserver *)observer;

@end

#pragma mark - RZDataBinding implementation

@implementation NSObject (RZDataBinding)

- (void)rz_addTarget:(id)target action:(SEL)action forKeyPathChange:(NSString *)keyPath
{
    [self rz_addTarget:target action:action forKeyPathChange:keyPath callImmediately:NO];
}

- (void)rz_addTarget:(id)target action:(SEL)action forKeyPathChange:(NSString *)keyPath callImmediately:(BOOL)callImmediately
{
    NSParameterAssert(target);
    NSParameterAssert(action);

    NSKeyValueObservingOptions observationOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;

    if ( callImmediately ) {
        observationOptions |= NSKeyValueObservingOptionInitial;
    }

    [self rz_addTarget:target action:action boundKey:nil bindingFunction:nil forKeyPath:keyPath withOptions:observationOptions];
}

- (void)rz_addTarget:(id)target action:(SEL)action forKeyPathChanges:(NSArray *)keyPaths
{
    [keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
        [self rz_addTarget:target action:action forKeyPathChange:keyPath callImmediately:NO];
    }];
}

- (void)rz_removeTarget:(id)target action:(SEL)action forKeyPathChange:(NSString *)keyPath
{
    [self rz_removeTarget:target action:action boundKey:nil forKeyPath:keyPath];
}

- (void)rz_bindKey:(NSString *)key toKeyPath:(NSString *)foreignKeyPath ofObject:(id)object
{
    [self rz_bindKey:key toKeyPath:foreignKeyPath ofObject:object withFunction:nil];
}

- (void)rz_bindKey:(NSString *)key toKeyPath:(NSString *)foreignKeyPath ofObject:(id)object withFunction:(RZDBKeyBindingFunction)bindingFunction
{
    NSParameterAssert(key);
    NSParameterAssert(foreignKeyPath);
    
    if ( object != nil ) {
        @try {
            id val = [object valueForKeyPath:foreignKeyPath];

            [self rz_setBoundKey:key withValue:val function:bindingFunction];
        }
        @catch (NSException *exception) {
            [NSException raise:NSInvalidArgumentException format:@"RZDataBinding cannot bind key:%@ to key path:%@ of object:%@. Reason: %@", key, foreignKeyPath, [object description], exception.reason];
        }
        
        [object rz_addTarget:self action:@selector(rz_observeBoundKeyChange:) boundKey:key bindingFunction:bindingFunction forKeyPath:foreignKeyPath withOptions:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
    }
}

- (void)rz_unbindKey:(NSString *)key fromKeyPath:(NSString *)foreignKeyPath ofObject:(id)object
{
    [object rz_removeTarget:self action:@selector(rz_observeBoundKeyChange:) boundKey:key forKeyPath:foreignKeyPath];
}

@end

#pragma mark - RZDBObservableObject implementation

@implementation RZDBObservableObject

- (void)dealloc
{
    [self rz_cleanupObservers];
}

@end

#pragma mark - RZDataBinding_Private implementation

@implementation NSObject (RZDataBinding_Private)

- (NSMutableArray *)rz_registeredObservers
{
    return objc_getAssociatedObject(self, @selector(rz_registeredObservers));
}

- (void)rz_setRegisteredObservers:(NSMutableArray *)registeredObservers
{
    objc_setAssociatedObject(self, @selector(rz_registeredObservers), registeredObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (RZDBObserverContainer *)rz_dependentObservers
{
    return objc_getAssociatedObject(self, @selector(rz_dependentObservers));
}

- (void)rz_setDependentObservers:(RZDBObserverContainer *)dependentObservers
{
    objc_setAssociatedObject(self, @selector(rz_dependentObservers), dependentObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)rz_addTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey bindingFunction:(RZDBKeyBindingFunction)bindingFunction forKeyPath:(NSString *)keyPath withOptions:(NSKeyValueObservingOptions)options
{
    NSMutableArray *registeredObservers = nil;
    RZDBObserverContainer *dependentObservers = nil;

    RZDBObserver *observer = [[RZDBObserver alloc] initWithObservedObject:self keyPath:keyPath observationOptions:options];

    [observer setTarget:target action:action boundKey:boundKey bindingFunction:bindingFunction];

    @synchronized (self) {
        registeredObservers = [self rz_registeredObservers];

        if ( registeredObservers == nil ) {
            registeredObservers = [NSMutableArray array];
            [self rz_setRegisteredObservers:registeredObservers];
        }

        [registeredObservers addObject:observer];
    }

    @synchronized (target) {
        dependentObservers = [target rz_dependentObservers];

        if ( dependentObservers == nil ) {
            dependentObservers = [[RZDBObserverContainer alloc] init];
            [target rz_setDependentObservers:dependentObservers];
        }

        [dependentObservers addObserver:observer];
    }
}

- (void)rz_removeTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey forKeyPath:(NSString *)keyPath
{
    @synchronized (self) {
        NSMutableArray *registeredObservers = [self rz_registeredObservers];

        [registeredObservers enumerateObjectsUsingBlock:^(RZDBObserver *observer, NSUInteger idx, BOOL *stop) {
            BOOL targetsEqual   = (target == observer.target);
            BOOL actionsEqual   = (action == NULL || action == observer.action);
            BOOL boundKeysEqual = (boundKey == observer.boundKey || [boundKey isEqualToString:observer.boundKey]);
            BOOL keyPathsEqual  = [keyPath isEqualToString:observer.keyPath];

            BOOL allEqual = (targetsEqual && actionsEqual && boundKeysEqual && keyPathsEqual);

            if ( allEqual ) {
                [observer invalidate];
            }
        }];
    }
}

- (void)rz_observeBoundKeyChange:(NSDictionary *)change
{
    NSString *boundKey = change[kRZDBChangeKeyBoundKey];
    
    if ( boundKey != nil ) {
        id value = change[kRZDBChangeKeyNew];

        [self rz_setBoundKey:boundKey withValue:value function:change[kRZDBChangeKeyBindingFunctionKey]];
    }
}

- (void)rz_setBoundKey:(NSString *)key withValue:(id)value function:(RZDBKeyBindingFunction)function
{
    id currentValue = [self valueForKey:key];

    if ( function != nil ) {
        value = function(value);
    }

    if ( currentValue != value && ![currentValue isEqual:value] ) {
        [self setValue:value forKey:key];
    }
}

- (void)rz_cleanupObservers
{
    NSMutableArray *registeredObservers = [self rz_registeredObservers];
    RZDBObserverContainer *dependentObservers = [self rz_dependentObservers];

    [[registeredObservers copy] enumerateObjectsUsingBlock:^(RZDBObserver *obs, NSUInteger idx, BOOL *stop) {
        [obs invalidate];
    }];

    [dependentObservers.observers compact];
    [[dependentObservers.observers allObjects] enumerateObjectsUsingBlock:^(RZDBObserver *obs, NSUInteger idx, BOOL *stop) {
        [obs invalidate];
    }];
}

#if RZDB_AUTOMATIC_CLEANUP
static SEL kRZDBDefautDeallocSelector;
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            SEL selector = NSSelectorFromString(@"dealloc");
            SEL replacementSelector = @selector(rz_dealloc);
            
            Method originalMethod = class_getInstanceMethod(self, selector);
            Method replacementMethod = class_getInstanceMethod(self, replacementSelector);
            
            kRZDBDefautDeallocSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", kRZDBDefaultSelectorPrefix, NSStringFromSelector(selector)]);
            
            class_addMethod(self, kRZDBDefautDeallocSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            class_replaceMethod(self, selector, method_getImplementation(replacementMethod), method_getTypeEncoding(replacementMethod));
        }
    });
}

- (void)rz_dealloc
{
    [self rz_cleanupObservers];
    
    ((void(*)(id, SEL))objc_msgSend)(self, kRZDBDefautDeallocSelector);
}
#endif

@end

#pragma mark - RZDBObserver implementation

@implementation RZDBObserver

- (instancetype)initWithObservedObject:(NSObject *)observedObject keyPath:(NSString *)keyPath observationOptions:(NSKeyValueObservingOptions)observingOptions
{
    self = [super init];
    if ( self != nil ) {
        _observedObject = observedObject;
        _keyPath = keyPath;
        _observationOptions = observingOptions;
    }
    
    return self;
}

- (void)setTarget:(id)target action:(SEL)action boundKey:(NSString *)boundKey bindingFunction:(RZDBKeyBindingFunction)bindingFunction
{
    self.target = target;
    self.action = action;
    self.methodSignature = [target methodSignatureForSelector:action];

    self.boundKey = boundKey;
    self.bindingFunction = bindingFunction;

    [self.observedObject addObserver:self forKeyPath:self.keyPath options:self.observationOptions context:kRZDBKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == kRZDBKVOContext ) {
        if ( self.methodSignature.numberOfArguments > 2 ) {
            NSDictionary *changeDict = [self changeDictForKVOChange:change];

            ((void(*)(id, SEL, NSDictionary *))objc_msgSend)(self.target, self.action, changeDict);
        }
        else {
            ((void(*)(id, SEL))objc_msgSend)(self.target, self.action);
        }
    }
}

- (NSDictionary *)changeDictForKVOChange:(NSDictionary *)kvoChange
{
    NSMutableDictionary *changeDict = [NSMutableDictionary dictionary];
    
    if ( self.observedObject != nil ) {
        changeDict[kRZDBChangeKeyObject] = self.observedObject;
    }
    
    if ( RZDBNotNull(kvoChange[NSKeyValueChangeOldKey]) ) {
        changeDict[kRZDBChangeKeyOld] = kvoChange[NSKeyValueChangeOldKey];
    }
    
    if ( RZDBNotNull(kvoChange[NSKeyValueChangeNewKey]) ) {
        changeDict[kRZDBChangeKeyNew] = kvoChange[NSKeyValueChangeNewKey];
    }
    
    if ( self.keyPath != nil ) {
        changeDict[kRZDBChangeKeyKeyPath] = self.keyPath;
    }
    
    if ( self.boundKey != nil ) {
        changeDict[kRZDBChangeKeyBoundKey] = self.boundKey;
    }
    
    if ( self.bindingFunction != nil ) {
        changeDict[kRZDBChangeKeyBindingFunctionKey] = self.bindingFunction;
    }
    
    return [changeDict copy];
}

- (void)invalidate
{
    [[self.target rz_dependentObservers] removeObserver:self];
    [[self.observedObject rz_registeredObservers] removeObject:self];

    // KVO throws an exception when removing an observer that was never added.
    // This should never be a problem given how things are setup, but make sure to avoid a crash.
    @try {
        [self.observedObject removeObserver:self forKeyPath:self.keyPath context:kRZDBKVOContext];
    }
    @catch (__unused NSException *exception) {
        RZDBLog(@"RZDataBinding attempted to remove an observer from object:%@, but the observer was never added. This shouldn't have happened, but won't affect anything going forward.", self.observedObject);
    }
    
    self.observedObject = nil;
    self.target = nil;
    self.action = NULL;
    self.methodSignature = nil;
}

@end

#pragma mark - RZDBObserverContainer implementation

@implementation RZDBObserverContainer

- (instancetype)init
{
    self = [super init];
    if ( self != nil ) {
        _observers = [NSPointerArray pointerArrayWithOptions:(NSPointerFunctionsWeakMemory | NSPointerFunctionsOpaquePersonality)];
    }
    return self;
}

- (void)addObserver:(RZDBObserver *)observer
{
    @synchronized (self) {
        [self.observers addPointer:(__bridge void *)(observer)];
    }
}

- (void)removeObserver:(RZDBObserver *)observer
{
    @synchronized (self) {
        NSUInteger observerIndex = [[self.observers allObjects] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return obj == observer;
        }];

        if ( observerIndex != NSNotFound ) {
            [self.observers removePointerAtIndex:observerIndex];
        }
    }
}

@end
