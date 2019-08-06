// Copyright (c) 2018 linhay <is.linhay@outlook.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "MethodSignature.h"

@interface Invocation : NSObject

@property(nonatomic,strong) NSInvocation* _Nullable instance;

+ (Invocation *_Nullable)invocationWithMethodSignature:(MethodSignature *_Nullable)sig;
@property (readonly, retain) NSMethodSignature * _Nullable methodSignature;

- (void)retainArguments;
@property (readonly) BOOL argumentsRetained;

@property (nullable, assign) id target;
@property SEL _Nullable selector;

- (void)invoke;
- (void)invokeWithTarget:(id _Nullable)target;

- (id _Nullable )getArgument:(NSInteger)offset;
- (void)setArgument:(id _Nullable)value atIndex:(NSInteger)idx;
- (void)setArgument:(id _Nullable)argument expectedTypeEncoding: (NSString *_Nullable)typeEncoding atIndex:(NSInteger)idx;

- (id _Nullable)getReturnObject;
- (void)getReturnValue:(void *_Nullable)retLoc;
- (void)setReturnValue:(void *_Nullable)retLoc;

@end
