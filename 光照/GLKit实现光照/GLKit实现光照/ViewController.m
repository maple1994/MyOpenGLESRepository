//
//  ViewController.m
//  GLKit实现光照
//
//  Created by Maple on 2019/8/13.
//  Copyright © 2019 Maple. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sceneUtil.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
//额外Effect
@property(nonatomic, strong) GLKBaseEffect *extraEffect;
/// 顶点buffer
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;
/// 法线buffer
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *extraBuffer;
/// 中心点的高
@property(nonatomic, assign) GLfloat centexVertexHeight;
/// 是否绘制法线
@property(nonatomic,assign)BOOL shouldDrawNormals;

@end

@implementation ViewController
{
    //三角形-8面
    SceneTriangle triangles[NUM_FACES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContext];
    [self setupEffect];
    [self setupBuffer];
}

- (void)setupContext
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:self.context];
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = self.context;
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}

- (void)setupEffect
{
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    
    self.extraEffect = [[GLKBaseEffect alloc] init];
    self.extraEffect.useConstantColor = GL_TRUE;
    
    // 光的漫射部分，RGBA
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1);
    // 光的位置
    self.baseEffect.light0.position = GLKVector4Make(1.0, 1.0, 0.5, 0);
    
    // 调整模型矩阵，方便观察
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60), 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30), 0, 0, 1);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0, 0, 0.25);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    self.extraEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)setupBuffer
{
    //确定图形的8个面
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
    // 初始化缓存区
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles) / sizeof(SceneVertex) bytes:triangles usage:GL_DYNAMIC_DRAW];
    
    self.extraBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStride:sizeof(SceneVertex) numberOfVertices:0 bytes:NULL usage:GL_DYNAMIC_DRAW];
    
    self.centexVertexHeight = 0;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.3, 0.3, 0.3, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    // 设置顶点数据
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, position) shouldEnable:YES];
    // 设置法线数据
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, normal) shouldEnable:YES];
    // 绘制
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)];
    if (self.shouldDrawNormals) {
        [self drawNormals];
    }
}

- (void)drawNormals
{
    GLKVector3 normalLineVertices[NUM_LINE_VERTS];
    //1.以每个顶点的坐标为起点，顶点坐标加上法向量的偏移值作为终点，更新法线显示数组
    //参数1: 三角形数组
    //参数2：光源位置
    //参数3：法线显示的顶点数组
    SceneTrianglesNormalLinesUpdate(triangles, GLKVector3MakeWithArray(self.baseEffect.light0.position.v), normalLineVertices);
    //2.为extraBuffer重新开辟空间
    [self.extraBuffer reinitWithAttribStride:sizeof(GLKVector3) numberOfVertices:NUM_LINE_VERTS bytes:normalLineVertices];
    //3.准备绘制数据
    [self.extraBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    //4.修改extraEffect
    //法线
    /*
     指示是否使用常量颜色的布尔值。
     如果该值设置为gl_true，然后存储在设置属性的值为每个顶点的颜色值。如果该值设置为gl_false，那么你的应用将使glkvertexattribcolor属性提供每顶点颜色数据。默认值是gl_false。
     */
    self.extraEffect.useConstantColor = GL_TRUE;
    // 设置光源颜色为绿色，画顶点法线
    self.extraEffect.constantColor = GLKVector4Make(0, 1, 0, 1);
    // 绘制绿色法线
    [self.extraEffect prepareToDraw];
    [self.extraBuffer drawArrayWithMode:GL_LINES startVertexIndex:0 numberOfVertices:NUM_NORMAL_LINE_VERTS];
    
    // 设置光源颜色为黄色 red + green = yellow
    self.extraEffect.constantColor = GLKVector4Make(1, 1, 0, 1);
    [self.extraEffect prepareToDraw];
    [self.extraBuffer drawArrayWithMode:GL_LINES startVertexIndex:NUM_NORMAL_LINE_VERTS numberOfVertices:2];
}

/// 更新法向量
- (void)updateNormals
{
    SceneTrianglesUpdateFaceNormals(triangles);
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles) / sizeof(SceneVertex) bytes:triangles];
}

- (void)setCentexVertexHeight:(GLfloat)centexVertexHeight
{
    _centexVertexHeight = centexVertexHeight;
    // 更新顶点E
    SceneVertex newVertexE = vertexE;
    newVertexE.position.z = _centexVertexHeight;
    
    triangles[2] = SceneTriangleMake(vertexD, vertexB, newVertexE);
    triangles[3] = SceneTriangleMake(newVertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, newVertexE, vertexH);
    triangles[5] = SceneTriangleMake(newVertexE, vertexF, vertexH);
    // 更新法线
    [self updateNormals];
}

- (IBAction)changeCenterVertexHeight:(UISlider *)sender {
    
    self.centexVertexHeight = sender.value;
}

//绘制法线
- (IBAction)takeShouldDrawNormals:(UISwitch *)sender {
    
    self.shouldDrawNormals = sender.isOn;
}


@end
