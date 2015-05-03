//
//  RZDBMacros.h
//  RZDBTests
//
//  Created by Rob Visentin on 3/18/15.
//
//

#ifndef __RZDBMacros__
#define __RZDBMacros__

/**
 *  The method that should be used to log errors in RZDataBinding that are non-fatal,
 *  but may be useful in debugging. You might choose for example to `#define RZDBLog DDLogInfo`.
 *  The method defined must take exactly two parameters, a format string, and a variable list of arguments.
 *  By default, log messages are sent using NSLog.
 */
#ifndef RZDBLog
#define RZDBLog NSLog
#endif

////////////////////////////////////////
////                                ////
////    Key Path creation Macros    ////
////                                ////
////////////////////////////////////////

/**
 *  Convenience macros for creating keypaths. An invalid keypath will throw a compile-time error when compiling in debug mode.
 *
 *  The first parameter of these macros is used only for compile-time validation of the keypath.
 *
 *  @return An NSString containing the keypath.
 *
 *  @example RZDB_KP(NSObject, description.length) -> @"description.length"
 *           RZDB_KP_OBJ(MyLabel, text)            -> @"text"
 *           RZDB_KP_SELF(user.firstName)          -> @"user.firstName"
 */
#if DEBUG
#define RZDB_KP(Classname, keypath) ({\
Classname *_rzdb_keypath_obj; \
__unused __typeof(_rzdb_keypath_obj.keypath) _rzdb_keypath_prop; \
@#keypath; \
})

#define RZDB_KP_OBJ(object, keypath) ({\
__typeof(object) _rzdb_keypath_obj; \
__unused __typeof(_rzdb_keypath_obj.keypath) _rzdb_keypath_prop; \
@#keypath; \
})
#else
#define RZDB_KP(Classname, keypath) (@#keypath)
#define RZDB_KP_OBJ(self, keypath) (@#keypath)
#endif

/**
 *  @note This macro will implicitly retain self from within blocks while running in debug mode.
 *  The safe way to generate a keypath on self from  within a block 
 *  is to define a weak reference to self outside the block, and then use RZDB_KP_OBJ(weakSelf, keypath).
 */
#define RZDB_KP_SELF(keypath) RZDB_KP_OBJ(self, keypath)

/**
 *  Concatenate two keypath strings.
 *  
 *  keypath1 and keypath2 must be NSStrings like, for example, the ones created by the other RZDB keypath generation macros.
 *  The result is another NSString concatenating the two keypaths, but there is no implicit check that the key path exists.
 */
#define RZDB_KP_CONCAT(keypath1, keypath2) [keypath1 stringByAppendingFormat:@".%@", keypath2]

#endif /** __RZDBMacros__ defined */
