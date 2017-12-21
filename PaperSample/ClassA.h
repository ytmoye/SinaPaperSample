//
//  ClassA.h
//  PaperSample
//
//  Created by yutao on 21/12/2017.
//  Copyright © 2017 yutao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SampleBlock)(void);

@interface ClassA : NSObject
- (void)doSomething;
@end

@interface ClassB : NSObject
@property (nonatomic, copy) SampleBlock block;
@end
