//
//  RZDataBinding.h
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

#import <Foundation/Foundation.h>

#pragma mark - Definitions

/**
 *  A transform that takes a value as a parameter and returns an object.
 *
 *  @param value The value that just changed on a foreign object for a bound key path.
 *
 *  @return The value to set for the bound key. Ideally the returned value should depend solely on the input value.
 */
typedef id (^RZDBKeyBindingTransform)(id value);

#pragma mark - Convenience Constants

/**
 *  If value is nil, returns @(0), otherwise returns value.
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBNilToZeroTransform;

/**
 *  If value is nil, returns @(1), otherwise returns value.
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBNilToOneTransform;

/**
 *  If value is nil, returns NSValue with CGSizeZero, otherwise returns value.
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBNilToCGSizeZeroTransform;

/**
 *  If value is nil, returns NSValue with CGRectZero, otherwise returns value.
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBNilToCGRectZeroTransform;

/**
 *  If value is nil, returns NSValue with CGRectNull, otherwise returns value.
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBNilToCGRectNullTransform;

/**
 *  Returns @(![value boolValue])
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBLogicalNegateTransform;

/**
 *  Returns @(1.0 - [value doubleValue])
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBOneMinusTransform;

/**
 *  Returns @(~[value longLongValue])
 */
OBJC_EXTERN RZDBKeyBindingTransform const kRZDBBitwiseComplementTransform;
