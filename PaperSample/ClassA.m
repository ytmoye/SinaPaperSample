//
//  ClassA.m
//  PaperSample
//
//  Created by yutao on 21/12/2017.
//  Copyright © 2017 yutao. All rights reserved.
//

#import "ClassA.h"

@interface ClassA ()
{
    NSObject *_obj;
}

@property (nonatomic, strong) ClassB *b;
@end

@implementation ClassA

- (instancetype)init
{
    self = [super init];
    if (self) {
        _obj = [[NSObject alloc] init];
        _b = [[ClassB alloc] init];
        
        _b.block = ^{
            [self print];  //这里如果用self就会造成循环引用，需要手动解除，或者weakSelf
            NSLog(@"%p", _obj); //这句话也会造成循环引用，因为要访问_obj，本质上也是通过self的,这种属于比较隐蔽的循环引用
            NSLog(@"%p", self->_obj); //这句话与上面等效
        };
        
        //下面是正确做法
//        __weak typeof(self) weakSelf = self;
//        _b.block = ^{
//            [weakSelf print];
//            __strong typeof(self) strongSelf = weakSelf;
//            NSLog(@"%p", strongSelf->_obj);
//        };
        return self;
    }
    return nil;
}

- (void)doSomething
{
    _b.block();
}

- (void)print
{
    NSLog(@"11111");
}

- (void)dealloc
{
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
}

@end

@interface ClassB ()

@end

@implementation ClassB

- (void)dealloc
{
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
}

@end

