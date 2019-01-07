#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DarkTemplar.h"
#import "Invocation.h"
#import "MethodSignature.h"
#import "NSObject+DarkTemplar.h"

FOUNDATION_EXPORT double DarkTemplarVersionNumber;
FOUNDATION_EXPORT const unsigned char DarkTemplarVersionString[];

