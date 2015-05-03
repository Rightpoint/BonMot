# RZDataBinding

[![Version](https://img.shields.io/cocoapods/v/RZDataBinding.svg?style=flat)](http://cocoadocs.org/docsets/RZDataBinding)

<p align="center">
<img src="http://cl.ly/image/1r0I0x401W2m/chain.png"
alt="RZDataBinding">
</p>
## Overview
RZDataBinding is a framework designed to help maintain data integrity in your iOS or OS X app. It is built using the standard Key-Value Observation (KVO) framework, but is safer and provides additional functionality. Like KVO, RZDataBinding helps to avoid endless delegate chains by establishing direct callbacks for when an object changes state.

## Installation
Install using [CocoaPods](http://cocoapods.org) (recommended) by adding the following line to your Podfile:

`pod "RZDataBinding"`

Alternatively, download the repository and add the contents of the RZDataBinding directory to your project.

## Demo Project
An example project is available in the Example directory. You can quickly check it out with

`pod try RZDataBinding`

Or download the zip from github and run it manually.

<p align="center">
<img src="http://cl.ly/image/152x112l0i2n/rzdb.gif"
alt="RZDataBinding">
</p>

The demo shows a basic usage of RZDataBinding, but is by no means the canonical or most advanced use case. 

##Usage
**Register a callback for when the keypath of an object changes:**
``` obj-c
// Register a selector to be called on a given target whenever keyPath changes on the receiver.
// Action must take either zero or exactly one parameter, an NSDictionary. 
// If the method has a parameter, the dictionary will contain values for the appropriate 
// RZDBChangeKeys. If keys are absent, they can be assumed to be nil. Values will not be NSNull.
- (void)rz_addTarget:(id)target
        action:(SEL)action
        forKeyPathChange:(NSString *)keyPath;
```

**Bind values of two objects together either directly or with a function:**
``` obj-c
// Binds the value of a given key of the receiver to the value of a key path of another object. 
// When the key path of the object changes, the bound key of the receiver is also changed.
- (void)rz_bindKey:(NSString *)key
        toKeyPath:(NSString *)foreignKeyPath
        ofObject:(id)object;

// Same as the above method, but the binding function is first applied 
// to the changed value before setting the value of the bound key.
// If nil, the identity function is assumed, making it identical to regular rz_bindKey.
- (void)rz_bindKey:(NSString *)key 
        toKeyPath:(NSString *)foreignKeyPath 
        ofObject:(id)object
        withFunction:(RZDBKeyBindingFunction)bindingFunction;
```
Targets can be removed and keys unbound with corresponding removal methods, but unlike with standard KVO, you are not obligated to do so. RZDataBinding will automatically cleanup observers before objects are deallocated. 

## Why not use plain KVO?
Consider the following code, which calls `nameChanged:` when a user object's name changes, and reload a collection view when the user's preferences change:

**Using KVO:**
``` obj-c
static void* const MyKVOContext = (void *)&MyKVOContext;

- (void)setupKVO
{
    [self.user addObserver:self
               forKeyPath:@"name"
               options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
               context:MyKVOContext]; 
                  
    [self.user addObserver:self
               forKeyPath:@"preferences"
               options:kNilOptions
               context:MyKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context
{
  if ( context == MyKVOContext ) {
        if ( [object isEqual:self.user] ) {
            if ( [keyPath isEqualToString:@"name"] ) {
                [self nameChanged:change];
            }
            else if ( [keyPath isEqualToString:@"preferences"] ) {
                [self.collectionView reloadData];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.user removeObserver:self forKeyPath:@"name" context:MyKVOContext];
    [self.user removeObserver:self forKeyPath:@"preferences" context:MyKVOContext];
}
```

**Using RZDataBinding:**
``` obj-c
- (void)setupKVO
{
    [self.user rz_addTarget:self 
               action:@selector(nameChanged:) 
               forKeyPathChange:@"name"];
    
    [self.user rz_addTarget:self.collectionView 
               action:@selector(reloadData) 
               forKeyPathChange:@"preferences"];
}
```
Aside from the obvious reduction in code, the RZDataBinding implementation demonstrates several other wins:

1. No need to manage different KVO contexts and check which object/keypath changed
2. No need to implement an instance method, meaning *any* object can be added as a target
3. No need to teardown before deallocation (standard KVO crashes if you fail to do this)

## Safe Keypaths

RZDataBinding also provides [several convenience macros](RZDataBinding/RZDBMacros.h) to create type-safe keypaths. When running in `DEBUG` mode, invalid keypaths will generate a compiler error:

``` obj-c
// Creates the keypath @"text", ensuring it exists on objects of type UILabel
RZDB_KP(UILabel, text);

// Creates @"layer.cornerRadius", ensuring the keypath exists on myView
RZDB_KP_OBJ(myView, layer.cornerRadius);

// Creates @"session.user.name", ensuring the keypath exists on self
RZDB_KP_SELF(session.user.name);
```

You should *always* use these macros instead of literal strings, because of the additional type checks they provide. Note that in production these macros simplify to literal string generation to avoid any additional overhead.

## Callback Coalescing (Advanced)

RZDataBinding also provides a coalescing mechanism for fine-tuning areas of your application that receive or send a high number of KVO notifications, which may incur a performance cost. For example, a complex view might trigger an expensive layout operation whenever one of several properties changes. Or, some work may require changing properties several times before they settle to final values. In these cases, it may be beneficial to have RZDataBinding treat a block of work as an "atomic" event. That is, supported callbacks should be coalesced and sent once, when the work completes.

[`RZDBCoalesce`](RZDataBinding/RZDBCoalesce.h) provides a block interface:

``` obj-c
[RZDBCoalesce coalesceBlock:^{
        // Callbacks within this block are coalesced,
        // and sent only once, after the block completes
}];
```

Callbacks are not coalesced by default, even within an `RZDBCoalesce` event. The `rz_addTarget:action:` methods can opt in to support coalescing by specifying a coalesce proxy as the callback target:

``` obj-c
[object rz_addTarget:[self rz_coalesceProxy] 
              action:@selector(expensiveCallback) 
    forKeyPathChange:RZDB_KP_OBJ(object, key.path)];
```

In this example, the intended target is `self`, but if a coalesce event is in progress these messages will be coalesced and deferred until the event completes. Note that only `rz_addTarget:action:` callbacks may support coalescing; bindings established with the `rz_bindKey:` methods will never be coalesced.

## Author
Rob Visentin, rob.visentin@raizlabs.com

## License
RZDataBinding is available under the MIT license. See the LICENSE file for more info.
