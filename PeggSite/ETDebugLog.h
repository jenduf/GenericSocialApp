//
//  ETDebugLog.h
//  Esteban Torres - NSLog extensions
//
//  Copyright (c) 2013 Esteban Torres. All rights reserved.
//

#import "ETAssert.h"

#ifndef __ETDebugLog_h__
#define __ETDebugLog_h__

#define TRACE 1
#define VERBOSE_LOGGING 1

#define __ET_File__ [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

#ifndef ETDebugLog
    #ifdef DEBUG
        #ifdef VERBOSE_LOGGING
            #define ETDebugLog(fmt, ...) NSLog((@"%s [%@:%d] - " fmt), __PRETTY_FUNCTION__, __ET_File__, __LINE__, ##__VA_ARGS__);
        #else
            #define ETDebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
        #endif
    #else
        #define ETDebugLog( s, ... )
    #endif // DEBUG
#endif // ETDebugLog

#ifndef ETTrace
    #ifdef TRACE
        #define ETTrace() NSLog(@"TRACE %@:%d (%s)", __ET_File__, __LINE__, __PRETTY_FUNCTION__)
    #else
        #define ETTrace()
    #endif // TRACE
#endif // ETTrace

#ifndef ETAssertRangeInclusive
    #ifdef DEBUG
        #define ETAssertRangeInclusive(value, min, max, message) ETAssert((value >= min && value <= max), message);
    #else
        #define ETAssertRangeInclusive(value, min, max, message)
    #endif // DEBUG
#endif // ETAssertRangeInclusive

#endif // __ETDebugLog_h__

