//
//  BONCompatibility.h
//  BonMot
//
//  Created by Zev Eisenberg on 3/4/15.
//
//  Copyright 2015 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
// Nullability annotation compatibility.
//

// clang-format off
#if __has_feature(nullability)
#   define BONNonnull            nonnull
#   define BONNullable           nullable
#   define BONCNonnull           __nonnull
#   define BONCNullable          __nullable
#   define BON_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#   define BON_ASSUME_NONNULL_END   NS_ASSUME_NONNULL_END
#else
#   define BONNonnull
#   define BONNullable
#   define BONCNonnull
#   define BONCNullable
#   define BON_ASSUME_NONNULL_BEGIN
#   define BON_ASSUME_NONNULL_END
#endif

//
// Lightweight generics compatibility.
//

#if __has_feature(objc_generics)
#   define BONGeneric(class, ...) class<__VA_ARGS__>
#   define BONGenericType(type) type
#else
#   define BONGeneric(class, ...) class
#   define BONGenericType(type) id
#endif


#define BONStringDict BONGeneric(NSDictionary, NSString *, id)
#define BONStringMutableDict BONGeneric(NSMutableDictionary, NSString *, id)
#define BONGenericDict BONGeneric(NSDictionary, KeyType, ObjectType)

// clang-format on
