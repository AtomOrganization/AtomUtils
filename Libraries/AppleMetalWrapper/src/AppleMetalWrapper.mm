#import <Cocoa/Cocoa.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface MetalViewDelegate : NSObject <MTKViewDelegate>
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
@end

typedef struct {
    vector_float2 position;
} Vertex;

id<MTLDevice> _device = MTLCreateSystemDefaultDevice();
id<MTLLibrary> library = [_device newDefaultLibrary];
id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragmentShader"];

@implementation MetalViewDelegate
- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        _commandQueue = [_device newCommandQueue];

        // Définir les sommets du carré (de -0.5 à 0.5 pour être centré)
        static const Vertex vertices[] = {
            { .position = { -0.5, -0.5 } },
            { .position = {  0.5, -0.5 } },
            { .position = { -0.5,  0.5 } },
            { .position = {  0.5,  0.5 } }
        };

        _vertexBuffer = [_device newBufferWithBytes:vertices
                                             length:sizeof(vertices)
                                            options:MTLResourceStorageModeShared];

       // Load compiled shader
        NSError *error = nil;
        NSURL *libraryURL = [[NSBundle mainBundle] URLForResource:@"triangle" withExtension:@"metallib"];
        id<MTLLibrary> library = [_device newLibraryWithURL:libraryURL error:&error];
        if (!library) {
            NSLog(@"Failed to load Metal library: %@", error);
            return nil;
        }
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragmentShader"];
        if (!vertexFunction || !fragmentFunction) {
            NSLog(@"Failed to load shader functions");
            return nil;
        }
        // Configurer l'état du pipeline
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;

        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:nil];
         if (!_pipelineState) {
            NSLog(@"Failed to create pipeline state: %@", error);
            return nil;
        }
    }
    return self;
}

- (void)drawInMTKView:(MTKView *)view {
    @autoreleasepool {
        id<CAMetalDrawable> drawable = view.currentDrawable;
        MTLRenderPassDescriptor *passDescriptor = view.currentRenderPassDescriptor;

        if (drawable && passDescriptor) {
            id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
            id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];

            // Configurer le pipeline et les buffers
            [encoder setRenderPipelineState:_pipelineState];
            [encoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];

            // Dessiner le carré
            [encoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];

            [encoder endEncoding];
            [commandBuffer presentDrawable:drawable];
            [commandBuffer commit];
        }
    }
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {}

@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        NSWindow *window = [[NSWindow alloc]
                            initWithContentRect:NSMakeRect(0, 0, 800, 600)
                            styleMask:(NSWindowStyleMaskTitled |
                                       NSWindowStyleMaskClosable |
                                       NSWindowStyleMaskResizable |
                                       NSWindowStyleMaskMiniaturizable)
                            backing:NSBackingStoreBuffered
                            defer:NO];
        [window setTitle:@"Metal Example"];
        [window makeKeyAndOrderFront:nil];

        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        MTKView *metalView = [[MTKView alloc] initWithFrame:window.contentView.bounds device:device];
        metalView.autoresizingMask = (NSViewWidthSizable | NSViewHeightSizable);
        metalView.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
        [window.contentView addSubview:metalView];

        MetalViewDelegate *delegate = [[MetalViewDelegate alloc] initWithDevice:device];
        metalView.delegate = delegate;

        [app run];
    }
    return 0;
}