//
//  BViewController.m
//  PaperSample
//
//  Created by yutao on 21/12/2017.
//  Copyright © 2017 yutao. All rights reserved.
//

#import "BViewController.h"
#import "MyButton.h"

/**
 这个监听runLopp的代码，参考了YYKit
 */
static RunLoopObserver *_observer = nil;

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    if (_observer == nil) return;
    [_observer print];
}

static void runLoopObserverSetup() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _observer = [RunLoopObserver new];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                           kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                           true,
                                           0xFFFFFF,
                                           runLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation RunLoopObserver

- (void)print
{
    NSLog(@"Runloop will sleep!");
}

@end

@interface TestObj : NSObject
@end

@implementation TestObj
- (void)dealloc
{
    NSLog(@"TestObj dealloc!");
    [super dealloc];
}
@end

@interface BViewController ()
{
    MyButton *_myButton;
}
@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //建立对runLoop的监听
//    runLoopObserverSetup();
    
    _myButton = [MyButton buttonWithType:UIButtonTypeCustom];
    _myButton.frame = CGRectMake(100, 100, 200, 200);
    [_myButton setTitle:@"返回A" forState:UIControlStateNormal];
    [_myButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_myButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTestObj];
    NSLog(@"viewWillAppear 执行完毕");
}

- (void)createTestObj
{
    TestObj *testObject = [[[TestObj alloc] init] autorelease];
}

/**
 result:
 2017-12-21 17:42:34.307797+0800 PaperSample[8550:601263] viewWillAppear 执行完毕
 2017-12-21 17:42:34.309884+0800 PaperSample[8550:601263] TestObj dealloc!
 2017-12-21 17:42:34.314549+0800 PaperSample[8550:601263] Runloop will sleep!
 
 @“TestObj dealloc!”  并没有先于 @“viewWillAppear 执行完毕”  打印
 */

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc!", NSStringFromClass([self class]));
    [super dealloc];
}

@end
