//
//  MPVertexAttribArrayBuffer.h
//  粒子系统ByOpenGLES
//
//  Created by Maple on 2019/8/15.
//  Copyright © 2019 Maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef enum {
    /// 位置
    MPVertexAttribPosition = GLKVertexAttribPosition,
    /// 光照
    MPVertexAttribNormal = GLKVertexAttribNormal,
    /// 颜色
    MPVertexAttribColor = GLKVertexAttribColor,
    /// 纹理1
    MPVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    /// 纹理2
    MPVertexAttribTexCoord1 = GLKVertexAttribTexCoord1
} MPVertexAttrib;

NS_ASSUME_NONNULL_BEGIN

@interface MPVertexAttribArrayBuffer : NSObject

/// 缓存标识
@property (nonatomic, readonly) GLuint name;
/// 缓冲区大小的字节数
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
/// 缓冲区名字
@property (nonatomic, readonly) GLsizeiptr stride;

/**
 根据模式绘制已经准备的数据

 @param mode 模式
 @param first 是否是第一次
 @param count 顶点个数
 */
+ (void)drawPrepartArraysWithMode: (GLenum)mode startVertexIndex: (GLint)first numberOfVerteices: (GLsizei)count;

/**
 初始化

 @param stride 步长
 @param count 顶点数
 @param dataPtr 数据指针
 @param usage 用法
 */
- (id)initWithAttribStride: (GLsizeiptr) stride numberOfVertices: (GLsizei)count bytes: (const GLvoid *)dataPtr usage: (GLenum)usage;


/**
 准备绘制

 @param index 属性
 @param count 顶点数
 @param offset 偏移量
 @param shouldEnable 是否可用
 */
- (void)prepareToDrawWithAttrib: (GLuint) index numberOfCoordinates: (GLint)count attribOffset: (GLsizeiptr)offset shouldEnable: (BOOL)shouldEnable;


/**
 绘制

 @param mode 模式
 @param first 开始位置
 @param count 顶点数
 */
- (void)drawArrayWithMode: (GLenum)mode startVertexIndex: (GLint)first numberofVertices: (GLsizei)count;


/**
 接收数据

 @param stride 步长
 @param count 顶点数
 @param dataPtr 数据指针
 */
- (void)reinitWithAttribStride: (GLsizeiptr)stride numberOfVertices: (GLsizei)count bytes: (const GLvoid *)dataPtr;

@end

NS_ASSUME_NONNULL_END
