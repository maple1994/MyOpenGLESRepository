//
//  MPPointParticleEffect.m
//  粒子系统ByOpenGLES
//
//  Created by Maple on 2019/8/15.
//  Copyright © 2019 Maple. All rights reserved.
//

#import "MPPointParticleEffect.h"
#import "MPVertexAttribArrayBuffer.h"

typedef struct {
    /// 发射位置
    GLKVector3 emissionPosition;
    /// 发射速度
    GLKVector3 emissionVelocity;
    /// 发射重力
    GLKVector3 emissionForce;
    /// 发射大小
    GLKVector2 size;
    /// 发射时间和寿命
    GLKVector2 emissionTimeAndLife;
} MPParticleAttributes;

enum
{
    /// MVP矩阵
    MPMVPMatrix,
    /// Samplers2D纹理
    MPSamplers2D,
    /// 耗时
    MPElapsedSeconds,
    /// 重力
    MPGravity,
    /// Uniform个数
    MPNumUniforms
};

typedef enum {
    /// 粒子发射位置
    MPParticleEmissionPosition = 0,
    /// 粒子发射速度
    MPParticleEmissionVelocity,
    /// 粒子发射重力
    MPParticleEmissionForce,
    /// 粒子发射大小
    MPParticleSize,
    /// 粒子发射时间和寿命
    MPParticleEmissionTimeAndLine
}MPParticleAttrib;

@interface MPPointParticleEffect()
{
    /// 耗时
    GLfloat elapsedSeconds;
    /// 程序
    GLuint program;
    /// uniform数组
    GLint uniforms[MPNumUniforms];
}
/// 顶点属性数组缓冲区
@property (nonatomic, strong, readwrite) MPVertexAttribArrayBuffer *particleAttributeBuffer;
/// 粒子个数
@property (nonatomic, assign, readonly) NSUInteger nmberOfParticles;
/// 粒子属性数据
@property (nonatomic, strong, readwrite) NSMutableData *particleAttributesData;
/// 是否更新例子数据
@property (nonatomic, assign, readwrite) BOOL particleDataWasUpdated;

@end;

@implementation MPPointParticleEffect

@synthesize gravity;
@synthesize elapsedSeconds;
@synthesize texture2d0;
@synthesize transform;
@synthesize particleAttributeBuffer;
@synthesize particleAttributesData;
@synthesize particleDataWasUpdated;

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化纹理属性
        texture2d0 = [[GLKEffectPropertyTexture alloc] init];
        texture2d0.enabled = YES;
        /*
         等价于:
         void glGenTextures (GLsizei n, GLuint *textures);
         //在数组textures中返回n个当期未使用的值，表示纹理对象的名称
         //零作为一个保留的纹理对象名，它不会被此函数当做纹理对象名称而返回
         */
        texture2d0.name = 0;
        texture2d0.target = GLKTextureTarget2D;
        //纹理用于计算其输出片段颜色的模式。看到GLKTextureEnvMode。
        /*
         GLKTextureEnvModeReplace,输出颜色设置为从纹理获取的颜色。忽略输入颜色
         GLKTextureEnvModeModulate, 默认!输出颜色是通过将纹理的颜色乘以输入颜色来计算的
         GLKTextureEnvModeDecal,输出颜色是通过使用纹理的alpha组件来混合纹理颜色和输入颜色来计算的。
         */
        texture2d0.envMode = GLKTextureEnvModeReplace;
        transform = [[GLKEffectPropertyTransform alloc] init];
        gravity = MPDefualtGravity;
        particleAttributesData = [NSMutableData data];
    }
    return self;
}

/// 获取粒子属性值
- (MPParticleAttributes)paricleAtIndex: (NSUInteger)aIndex
{
    //bytes:指向接收者内容的指针
    //获取粒子属性结构体内容
    const MPParticleAttributes *particlesPtr = (const MPParticleAttributes *)[self.particleAttributesData bytes];
    //获取属性结构体中的某一个指标
    return particlesPtr[aIndex];
}

/// 设置粒子的属性

- (void)addParticleAtPosition: (GLKVector3)aPosition
                     velocity: (GLKVector3)aVelocity
                        force: (GLKVector3)aForce
                         size: (float)aSize
               lifeSpanSecond: (NSTimeInterval)aSapn
                 fadeDuration: (NSTimeInterval)aDuration
{
    
}

/// 准备绘制
- (void)prepareToDraw
{
    
}

/// 绘制
- (void)draw
{
    
}

@end
