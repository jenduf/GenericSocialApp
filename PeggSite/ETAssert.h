//
//  ETAssert.h
//
//
//  Created by Esteban Torres on 6/5/13.
//  Based on Mike Ash article - Proper Use Of Asserts [ http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html?utm_source=iOS+Dev+Weekly&utm_campaign=7dba454803-iOS_Dev_Weekly_Issue_93&utm_medium=email&utm_term=0_7bda94b7ca-7dba454803-267010305 ]
//

#ifndef _ETAssert_h
#define _ETAssert_h

// Check if we want to use CocoaLumberjack
#ifdef USE_LUMBERJACK

// If so we import the DDLog.h and define the log levels
#import "DDLog.h"
#ifdef DEBUG // If we are on Debug we default to VERBOSE
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else // Else we default to ERROR (You could and should redifine this constant)
static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif

// We define the Log macro to use DDLogError instead
#define Log(frmt, __VA_ARGS__) DDLogError(frmt, __VA_ARGS__)

#else

// If we don't want to use CocoaLumberjack then we proceed to use simple NSLog
#define Log(frmt, __VA_ARGS__) NSLog(frmt, __VA_ARGS__)

#endif

/**
 ** If you define the PRE-PROCESSOR MACRO kSHOULD_THROW_EXCEPTION=1 this will cause the assertion to 
 ** throw an exception instead of calling the 'abort()' method.
 ** We support this in the hopes of adding "custom" data to the crash report via crashing with a custom exception.
 **     The "added data" shows in the CrashReport at least pointing the to line where the assertion was called 
 ** This custom exception contains the message "Assertion Failure - #expression"; reason: #expression and the user info is a dictionary that contains
 ** the File, Line, Function and the message (if one provided with the assert)
 **/

// We define the "default" ETAssert for iOS
#define ETAssert(expression, ...) \
do { \
if(!(expression)) { \
NSString *__ETAssert_temp_string = [NSString stringWithFormat: @"### Assertion failure: (%s) | %s | %s:%d. %@ ###", #expression, __func__, __FILE__, __LINE__, [NSString stringWithFormat: @"\t-\t" __VA_ARGS__]]; \
Log(@"%@", __ETAssert_temp_string);\
if(kSHOULD_THROW_EXCEPTION){\
@throw [NSException exceptionWithName:[NSString stringWithFormat:@"Assertion Failure - %s", #expression] reason:[NSString stringWithUTF8String:#expression] userInfo:@{@"File":[NSString stringWithUTF8String:__FILE__], @"Line":@(__LINE__), @"Function":[NSString stringWithUTF8String:__func__], @"Message":[NSString stringWithFormat: @"" __VA_ARGS__]}];\
}\
else{\
abort(); \
}\
}\
} while(0)

// If we are running on Mac we can provided custom data to our crash reporter
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
// So we undefine the assert and redefine it with the crash reporting capabilities
#undef ETAssert
// Variable added in the hopes of adding extra data to the crash report.
// Apparently doesn't work on iOS so this is added only on Mac OSX
const char *__crashreporter_info__ = NULL;
asm(".desc _crashreporter_info, 0x10");
#define ETAssert(expression, ...) \
do { \
if(!(expression)) { \
NSString *__ETAssert_temp_string = [NSString stringWithFormat: @"### Assertion failure: (%s) | %s | %s:%d. %@ ###", #expression, __func__, __FILE__, __LINE__, [NSString stringWithFormat: @"\t-\t" __VA_ARGS__]]; \
if(kSHOULD_THROW_EXCEPTION){\
@throw [NSException exceptionWithName:[NSString stringWithFormat:@"Assertion Failure - %s", #expression] reason:[NSString stringWithUTF8String:#expression] userInfo:@{@"File":[NSString stringWithUTF8String:__FILE__], @"Line":@(__LINE__), @"Function":[NSString stringWithUTF8String:__func__], @"Message":[NSString stringWithFormat: @"" __VA_ARGS__]}];\
}\
else{\
__crashreporter_info__ = [__ETAssert_temp_string UTF8String]; \
abort(); \
}\
}\
} while(0)
#endif

#endif