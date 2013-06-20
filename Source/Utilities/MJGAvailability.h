//
//  MJGImageLoader.h
//  MJGFoundation
//
//  Created by Matt Galloway on 18/01/2012.
//  Copyright 2012 Matt Galloway. All rights reserved.
//

/**
 * Example usage:
 *   If you want to see if you're using methods that are only defined in iOS 4.0 and lower 
 *   then you would use the following. Replace the __IPHONE_4_0 with whatever other macro 
 *   you require. See Availability.h for iOS versions these relate to.
 * 
 * YourProjectPrefixHeader.pch:
 *   #define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_4_0
 *   #import "MJGAvailability.h"
 *   
 *   // The rest of your prefix header as normal
 *   #import <UIKit/UIKit.h>
 * 
 * If you want to suppress a single warning (i.e. because you know that what you're doing is 
 * actually OK) then you can do something like this:
 *
 *   UINavigationBar *navBar = self.navigationController.navigationBar;
 *   if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
 *   #pragma clang diagnostic push
 *   #pragma clang diagnostic ignored "-Wdeprecated-declarations"
 *       [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
 *   #pragma clang diagnostic pop
 *   }
 *
 * Or you can use the handy macros defined in this file also, like this:
 *
 *   UINavigationBar *navBar = self.navigationController.navigationBar;
 *   if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
 *   MJG_START_IGNORE_TOO_NEW
 *       [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
 *   MJG_END_IGNORE_TOO_NEW
 *   }
 *
 */

#import <Availability.h>

#define MJG_START_IGNORE_TOO_NEW _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define MJG_END_IGNORE_TOO_NEW _Pragma("clang diagnostic pop")

#define __AVAILABILITY_TOO_NEW __attribute__((deprecated("TOO NEW!"))) __attribute__((weak_import))

#ifndef __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_OS_VERSION_MIN_REQUIRED
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_OS_VERSION_MIN_REQUIRED
    #error You cannot ask for a soft max version which is less than the deployment target
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_2_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_2_0
    #define __AVAILABILITY_INTERNAL__IPHONE_2_0 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_2_1
    #undef __AVAILABILITY_INTERNAL__IPHONE_2_1
    #define __AVAILABILITY_INTERNAL__IPHONE_2_1 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_2_2
    #undef __AVAILABILITY_INTERNAL__IPHONE_2_2
    #define __AVAILABILITY_INTERNAL__IPHONE_2_2 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_3_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_3_0
    #define __AVAILABILITY_INTERNAL__IPHONE_3_0 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_3_1
    #undef __AVAILABILITY_INTERNAL__IPHONE_3_1
    #define __AVAILABILITY_INTERNAL__IPHONE_3_1 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_3_2
    #undef __AVAILABILITY_INTERNAL__IPHONE_3_2
    #define __AVAILABILITY_INTERNAL__IPHONE_3_2 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_4_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_4_0
    #define __AVAILABILITY_INTERNAL__IPHONE_4_0 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_4_1
    #undef __AVAILABILITY_INTERNAL__IPHONE_4_1
    #define __AVAILABILITY_INTERNAL__IPHONE_4_1 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_4_2
    #undef __AVAILABILITY_INTERNAL__IPHONE_4_2
    #define __AVAILABILITY_INTERNAL__IPHONE_4_2 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_4_3
    #undef __AVAILABILITY_INTERNAL__IPHONE_4_3
    #define __AVAILABILITY_INTERNAL__IPHONE_4_3 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_5_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_5_0
    #define __AVAILABILITY_INTERNAL__IPHONE_5_0 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_5_1
    #undef __AVAILABILITY_INTERNAL__IPHONE_5_1
    #define __AVAILABILITY_INTERNAL__IPHONE_5_1 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_6_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_6_0
    #define __AVAILABILITY_INTERNAL__IPHONE_6_0 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_6_1
    #undef __AVAILABILITY_INTERNAL__IPHONE_6_1
    #define __AVAILABILITY_INTERNAL__IPHONE_6_1 __AVAILABILITY_TOO_NEW
#endif

#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED < __IPHONE_7_0
    #undef __AVAILABILITY_INTERNAL__IPHONE_7_0
    #define __AVAILABILITY_INTERNAL__IPHONE_7_0 __AVAILABILITY_TOO_NEW
#endif
