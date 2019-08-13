//
//  viewController.m
//  Opengl_Light_光照
//
//  Created by CC老师 on 2019/4/5.
//  Copyright © 2019年 CC老师. All rights reserved.
//


#import "ViewController.h"
#import "GLView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLView *view = [[GLView alloc]init];
    view.frame = self.view.bounds;
    [self.view insertSubview:view atIndex:0];
    
}




@end

