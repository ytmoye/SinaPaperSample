//
//  SomeClass.m
//  消息转发
//
//  Created by yutao on 21/10/2016.
//  Copyright © 2016 melot. All rights reserved.
//

#import "SomeClass.h"
#import <objc/runtime.h>

@interface ForwardClass : NSObject
-(void)doSomethingElse;
@end

@implementation ForwardClass

-(void)doSomethingElse
{
    NSLog(@"doSomething was called on %@", [self class]);
}
@end

@implementation SomeClass

-(id)init
{
    if (self = [super init]) {
        forwardClass = [ForwardClass new];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
}

//第一种方法，在这里动态添加
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(doSomethingElse:)) {
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"%@ is called", NSStringFromSelector(_cmd));
}

/**
 Forwarding methods (as described in Message Forwarding) and dynamic method resolution are, largely, orthogonal. A class has the opportunity to dynamically resolve a method before the forwarding mechanism kicks in. If respondsToSelector: or instancesRespondToSelector: is invoked, the dynamic method resolver is given the opportunity to provide an IMP for the selector first. If you implement resolveInstanceMethod: but want particular selectors to actually be forwarded via the forwarding mechanism, you return NO for those selectors.
 */

/** 第二种方法：在消息转发第二步处理,把这个方法注释掉，就会走第三步，参考 https://developer.apple.com/documentation/objectivec/nsobject/1418855-forwardingtargetforselector */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        return self;
    } else {
        if (!forwardClass) {
            forwardClass = [[ForwardClass alloc] init];
        }
        return forwardClass;
    }
}

/** 第三种方法：在消息转发第三步处理，参考： https://developer.apple.com/documentation/objectivec/nsobject/1571955-forwardinvocation?language=objc */
-(void)forwardInvocation:(NSInvocation *)invocation
{
    //把注释打开也可以不崩溃，就不会调用forwardClass的方法
    /*
     invocation.target = nil;
     [invocation invoke];
     */

    //这个需要重新生成方法签名
    if (!forwardClass) {
        [self doesNotRecognizeSelector:[invocation selector]];
    }
    [invocation invokeWithTarget:forwardClass];
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (! signature) {
        //生成方法签名
        signature = [forwardClass methodSignatureForSelector:selector];
    }
    return signature;
}

@end
