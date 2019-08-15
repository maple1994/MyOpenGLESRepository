//
//  ViewController.m
//  CAEmitterLayer使用
//
//  Created by Maple on 2019/8/15.
//  Copyright © 2019 Maple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CAEmitterLayer *colorBallLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupEmitter];
}

- (void)setupEmitter
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50);
    label.textColor = [UIColor whiteColor];
    label.text = @"轻点或拖动来改变发射源位置";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    // 开始设置EmitterLayer
    CAEmitterLayer *colorBallLayer = [CAEmitterLayer layer];
    self.colorBallLayer = colorBallLayer;
    [self.view.layer addSublayer:self.colorBallLayer];
    // 发射源尺寸
    colorBallLayer.emitterSize = self.view.frame.size;
    // 发射源形状
    colorBallLayer.emitterShape = kCAEmitterLayerPoint;
    // 发射源模式
    colorBallLayer.emitterMode = kCAEmitterLayerPoint;
    // 发射源中心点
    colorBallLayer.emitterPosition = CGPointMake(self.view.frame.size.width, 0);
    
    // 配置EmiiterCell
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.name = @"colorBallCell";
    // 粒子产生率
    cell.birthRate = 20.0f;
    // 粒子生命周期
    cell.lifetime = 10.0f;
    // 粒子速度
    cell.velocity = 40.0f;
    // 粒子速度范围
    cell.velocityRange = 100.0f;
    // 粒子Y轴加速度
    cell.yAcceleration = 15.f;
    // 指定纬度，纬度角代表x-z轴之间的夹角
    cell.emissionLongitude = M_PI;
    // 范围
    cell.emissionRange = M_PI_4;
    // 缩放比例
    cell.scale = 0.2;
    // 比例范围
    cell.scaleRange = 0.1;
    // 内容
    cell.contents = (id)[UIImage imageNamed:@"circle_white"].CGImage;
    // 颜色
    cell.color = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:1].CGColor;
    // RGBA变化区间，变化速度
    cell.redRange = 1.0f;
    cell.greenRange = 1.0f;
    cell.alphaRange = 0.8;
    cell.blueSpeed = 1.0f;
    cell.alphaSpeed = -0.1;
    // 添加Cell
    colorBallLayer.emitterCells = @[cell];
}

- (void)setBallPosition: (CGPoint)position
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"emitterCells.colorBallCell.scale"];
    anim.fromValue = @0.2f;
    anim.toValue = @0.5f;
    anim.duration = 1.0f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.colorBallLayer addAnimation:anim forKey:nil];
    [self.colorBallLayer setValue:[NSValue valueWithCGPoint:position] forKey:@"emitterPosition"];
    [CATransaction commit];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self setBallPosition:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self setBallPosition:point];
}


@end
