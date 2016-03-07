//
//  BONCompatibility.h
//  BonMot
//
//  Created by Zev Eisenberg on 3/4/15.
//

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
