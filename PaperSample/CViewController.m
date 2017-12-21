//
//  CViewController.m
//  PaperSample
//
//  Created by yutao on 21/12/2017.
//  Copyright © 2017 yutao. All rights reserved.
//

#import "CViewController.h"

@interface TestObject : NSObject
{
    @package
    int _tag;
    id _vc;
}

- (void)doSomething;
@end
@implementation TestObject

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"TestObj alloc");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ tag:%d dealloc!", NSStringFromClass([self class]), _tag);
}
@end

@interface CViewController ()

@end

@implementation CViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        TestObject *obj = [[TestObject alloc] init];
        obj->_tag = 1;
//        obj->_vc = self;  //如果强引用了self，会导致self也无法释放
        [obj doSomething];  //这里引发异常会导致obj无法释放
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
