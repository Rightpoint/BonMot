//
//  RZDataBinding.m
//
//  Created by Rob Visentin on 4/7/15.

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

#import <CoreGraphics/CGGeometry.h>

#import "RZDBTransforms.h"

RZDBKeyBindingTransform const kRZDBNilToZeroTransform = ^(id value) {
    return (value == nil) ? @(0) : value;
};

RZDBKeyBindingTransform const kRZDBNilToOneTransform = ^(id value) {
    return (value == nil) ? @(1) : value;
};

RZDBKeyBindingTransform const kRZDBNilToCGSizeZeroTransform = ^(id value) {
    if ( value == nil ) {
        value = [NSValue valueWithBytes:&CGSizeZero objCType:@encode(CGSize)];
    }
    return value;
};

RZDBKeyBindingTransform const kRZDBNilToCGRectZeroTransform = ^(id value) {
    if ( value == nil ) {
        value = [NSValue valueWithBytes:&CGRectZero objCType:@encode(CGRect)];
    }
    return value;
};

RZDBKeyBindingTransform const kRZDBNilToCGRectNullTransform = ^(id value) {
    if ( value == nil ) {
        value = [NSValue valueWithBytes:&CGRectNull objCType:@encode(CGRect)];
    }
    return value;
};

RZDBKeyBindingTransform const kRZDBLogicalNegateTransform = ^(id value) {
    return @(![value boolValue]);
};

RZDBKeyBindingTransform const kRZDBOneMinusTransform = ^(id value) {
    return @(1.0 - [value doubleValue]);
};

RZDBKeyBindingTransform const kRZDBBitwiseComplementTransform = ^(id value) {
    return @(~[value longLongValue]);
};
