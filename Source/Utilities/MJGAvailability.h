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
 */

#import <Availability.h>

#define __AVAILABILITY_TOO_NEW __attribute__((deprecated("TOO NEW!")))

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
