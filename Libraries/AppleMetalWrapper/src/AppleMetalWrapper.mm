#include <iostream>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface MetalViewDelegate : NSObject <MTKViewDelegate>
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
@end

@implementation MetalViewDelegate
- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        _commandQueue = [_device newCommandQueue];
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
        [window.contentView addSubview:metalView];

        MetalViewDelegate *delegate = [[MetalViewDelegate alloc] initWithDevice:device];
        metalView.delegate = delegate;

        [app run];
    }
    return 0;
}