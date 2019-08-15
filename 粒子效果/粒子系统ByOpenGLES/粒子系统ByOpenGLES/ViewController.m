//
//  ViewController.m
//  粒子系统ByOpenGLES
//
//  Created by Maple on 2019/8/15.
//  Copyright © 2019 Maple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSUInteger currentEmitterIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)ChangeIndex:(UISegmentedControl *)sender {
    
    //选择不同的效果
    self.currentEmitterIndex = [sender selectedSegmentIndex];
}


@end
