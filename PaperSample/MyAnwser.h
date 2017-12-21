//
//  MyAnwser.h
//  PaperSample
//
//  Created by yutao on 21/12/2017.
//  Copyright © 2017 yutao. All rights reserved.
//

#ifndef MyAnwser_h
#define MyAnwser_h

/**
 
 1.
    (1)block相对于delegate的优势:代码更紧凑，写起来不会像delegate那样繁琐，另外在某些特定场合也会比较方便：例如需要对服务器返回的数据根据数据的不同做相应的解析，在每个控制器里都写一遍不太好，可能只能写在基类里面，但恰好又没有共同的基类，这种情况下可以搞一个静态方法，具体看代码示例，在ViewController.m里面
    (2)block使用的时候避免什么问题：
        ①避免循环引用
        ②看使用场景：有些时候在请求没有着陆的时候，退出了界面，希望退出的时候被释放，用weakSelf，否则用不用无所谓
 
 2.
    //可以参考：http://v.youku.com/v_show/id_XODgxODkzODI0.html  by 孙源
    autorelease对象什么时候释放：runLoop下一次睡眠之前释放。
    如何测试：可以给runLoop添加即将睡眠时的监听，打印先后调用顺序
    看了cocos2d-X的autoreleasePool的实现，是在每个loop渲染完画面之后clear的,第42行
 
    void Director::mainLoop()
    {
        if (_purgeDirectorInNextLoop)
        {
            _purgeDirectorInNextLoop = false;
            purgeDirector();
        }
        else if (_restartDirectorInNextLoop)
        {
            _restartDirectorInNextLoop = false;
            restartDirector();
        }
        else if (! _invalid)
        {
            drawScene();

            // release the objects
            PoolManager::getInstance()->getCurrentPool()->clear();
        }
    }
 
 3.
    循环引用的实际场景
    a.例如CAAnimation的delegate是strong类型的，如果自身强引用了这个Animation，就会引起循环引用（系统API）
    b.MJRefresh设置上拉和下拉刷新的时候，如果不用weakSelf也会引起循环引用，印象中是这样的，好久不用了（第三方）
    c.创建A，B两个类，B类有一个copy修饰的block，A强引用B，在那个Block里面A没有用weakSelf，就会循环引用
 
 4.
    __bridge：https://www.cnblogs.com/zzltjnh/p/3885012.html
    其他没什么好说的
 
 5.
    a.使程序一直运行并接受用户输入
    b.决定程序在何时应该处理哪些Event
    c.实现了一个message queue，使调用解耦
    d.节省cpu时间
 
 6.看示例代码
 
 */

#endif /* MyAnwser_h */
