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

/** 第一种方法：在消息转发第二步处理,把这个方法注释掉，就会走第三步，参考 https://developer.apple.com/documentation/objectivec/nsobject/1418855-forwardingtargetforselector */
- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return self;
//    } else {
//        if (!forwardClass) {
//            forwardClass = [[ForwardClass alloc] init];
//        }
//        return forwardClass;
//    }
    
    //除了上面的办法，也可以在这里也可以动态创建类，并动态添加方法，参考 http://www.jianshu.com/p/521dd19d4406
    NSString *selectorStr = NSStringFromSelector(aSelector);
    Class protectorCls = NSClassFromString(@"Protector");
    if (!protectorCls)
    {
        protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
        objc_registerClassPair(protectorCls);
    }
    
    // 检查类中是否存在该方法，不存在则添加
    if (![self isExistSelector:aSelector inClass:protectorCls])
    {
        class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],
                        [selectorStr UTF8String]);
    }
    
    Class Protector = [protectorCls class];
    id instance = [[Protector alloc] init];
    return instance;
}

- (IMP)safeImplementation:(SEL)aSelector
{
    IMP imp = imp_implementationWithBlock(^(){
        NSLog(@"%@ is called", NSStringFromSelector(aSelector));
    });
    return imp;
}


- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass
{
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString: NSStringFromSelector(aSelector)])
        {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

/** 第二种方法：在消息转发第三步处理，参考： https://developer.apple.com/documentation/objectivec/nsobject/1571955-forwardinvocation?language=objc */
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
