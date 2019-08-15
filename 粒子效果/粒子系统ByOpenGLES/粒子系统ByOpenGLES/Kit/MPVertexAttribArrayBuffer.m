//
//  MPVertexAttribArrayBuffer.m
//  粒子系统ByOpenGLES
//
//  Created by Maple on 2019/8/15.
//  Copyright © 2019 Maple. All rights reserved.
//

#import "MPVertexAttribArrayBuffer.h"

@implementation MPVertexAttribArrayBuffer

/**
 根据模式绘制已经准备的数据
 
 @param mode 模式
 @param first 是否是第一次
 @param count 顶点个数
 */
+ (void)drawPrepartArraysWithMode: (GLenum)mode startVertexIndex: (GLint)first numberOfVerteices: (GLsizei)count
{
    glDrawArrays(mode, first, count);
}

/**
 初始化
 
 @param stride 步长
 @param count 顶点数
 @param dataPtr 数据指针
 @param usage 用法
 */
- (id)initWithAttribStride: (GLsizeiptr) stride numberOfVertices: (GLsizei)count bytes: (const GLvoid *)dataPtr usage: (GLenum)usage
{
    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = _stride * count;
        //初始化缓存区
        //创建VBO的3个步骤
        //1.生成新缓存对象glGenBuffers
        //2.绑定缓存对象glBindBuffer
        //3.将顶点数据拷贝到缓存对象中glBufferData
        glGenBuffers(1, &_name);
        glBindBuffer(GL_ARRAY_BUFFER, self.name);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);
    }
    return self;
}


/**
 准备绘制
 
 @param index 属性
 @param count 顶点数
 @param offset 偏移量
 @param shouldEnable 是否可用
 */
- (void)prepareToDrawWithAttrib: (GLuint) index numberOfCoordinates: (GLint)count attribOffset: (GLsizeiptr)offset shouldEnable: (BOOL)shouldEnable
{
    if (count < 0 || count > 4) {
        NSLog(@"Error:Count Error");
        return ;
        
    }
    
    if (_stride < offset) {
        NSLog(@"Error:_stride < Offset");
        return;
    }
    
    if (_name == 0) {
        NSLog(@"Error:name == Null");
    }
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, (int)self.stride, NULL + offset);
}


/**
 绘制
 
 @param mode 模式
 @param first 开始位置
 @param count 顶点数
 */
- (void)drawArrayWithMode: (GLenum)mode startVertexIndex: (GLint)first numberofVertices: (GLsizei)count
{
    if (self.bufferSizeBytes < (first + count) * self.stride) {
        NSLog(@"Vertex Error!");
    }
    glDrawArrays(mode, first, count);
}


/**
 接收数据
 
 @param stride 步长
 @param count 顶点数
 @param dataPtr 数据指针
 */
- (void)reinitWithAttribStride: (GLsizeiptr)stride numberOfVertices: (GLsizei)count bytes: (const GLvoid *)dataPtr
{
    _stride = stride;
    _bufferSizeBytes = stride * count;
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
}

@end
