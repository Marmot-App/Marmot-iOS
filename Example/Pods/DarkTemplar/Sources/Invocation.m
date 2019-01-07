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

#import "Invocation.h"
#import <objc/runtime.h>

@interface Invocation ()
  
@end


@implementation Invocation
  
+ (Invocation *)invocationWithMethodSignature:(MethodSignature *)sig {
  Invocation * obj = [[Invocation alloc] init];
  obj.instance = [NSInvocation invocationWithMethodSignature:sig.instance];
  return obj;
}
  
- (void)invoke{
  [self.instance invoke];
}
  
- (void)invokeWithTarget:(id)target {
  [self.instance invokeWithTarget:target];
}
  
- (void)setReturnValue:(void *)retLoc{
  [self.instance setReturnValue:retLoc];
}
  
- (void)getReturnValue:(void *)retLoc{
  [self.instance getReturnValue:retLoc];
}
  
-(id)getReturnObject{
  @autoreleasepool {
    id __autoreleasing obj = nil;
    [self.instance getReturnValue:&obj];
    return obj;
  }
}
  
- (void)setTarget:(id)target {
  self.instance.target = target;
}
  
- (id)target {
  return self.instance.target;
}
  
- (void)setSelector:(SEL)selector{
  self.instance.selector = selector;
}
  
- (SEL)selector{
  return self.instance.selector;
}
  
- (void)retainArguments{
  [self.instance retainArguments];
}
  
- (void)setArgument:(id)value atIndex:(NSInteger)idx{
  [self.instance setArgument:&value atIndex:idx];
}
  
- (id)getArgument:(NSInteger)offset{
  @autoreleasepool {
    id __autoreleasing obj  = nil;
    [self.instance getArgument:&obj atIndex:offset];
    return obj;
  }
}
  
  // https://github.com/JaviSoto/iOS10-Runtime-Headers/tree/master/lib/libswiftCore.dylib
- (void)setArgument:(id)argument expectedTypeEncoding: (NSString *)typeEncoding atIndex:(NSInteger)idx {
  id __autoreleasing inoutArg = argument;
  
  if ([@"c" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberCharType, &inoutArg);
  }else if ([@"s" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberShortType, &inoutArg);
  }else if ([@"i" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberIntType, &inoutArg);
  }else if ([@"q" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberLongLongType, &inoutArg);
  }else if ([@"f" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberFloatType, &inoutArg);
  }else if ([@"d" isEqualToString:typeEncoding]) {
    CFNumberGetValue((__bridge CFNumberRef)argument, kCFNumberDoubleType, &inoutArg);
  }else if ([@"@" isEqualToString: typeEncoding]) {
    if ([argument isKindOfClass: [NSMutableString class]]) {
      inoutArg = [[NSMutableString alloc] initWithString: argument];
    }else if ([argument isKindOfClass:[NSDictionary class]]) {
      inoutArg = [[NSMutableDictionary alloc] initWithDictionary: argument];
    }else if ([argument isKindOfClass:[NSArray class]]) {
      inoutArg = [[NSMutableArray alloc] initWithArray: argument];
    }else if ([argument isKindOfClass:[NSMutableSet class]]) {
      inoutArg = [[NSMutableSet alloc] initWithSet: argument];
    }
  }
  [self.instance setArgument:&inoutArg atIndex:idx];
}
  
@end
