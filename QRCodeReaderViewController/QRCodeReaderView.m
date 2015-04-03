/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface QRCodeReaderView ()
{
    __weak id<QRCodeReaderViewDelegate> delegate;
    CGRect       innerViewRect;
    
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation QRCodeReaderView
@synthesize innerViewRect,delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, 50, 50);

    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   += 50;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y   += (rect.size.height - minSize) / 2 - rect.size.height / 6;
        innerRect.size.height = minSize;
    }
    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
    
    innerViewRect = offsetRect;
    if(delegate)
    {
        [delegate loadView:innerViewRect];
    }
    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
    
    [self addOtherLay:offsetRect];
}

#pragma mark - Private Methods

- (void)addOverlay
{
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor redColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor lightGrayColor].CGColor;
    _overlay.lineWidth       = 1;
    _overlay.lineDashPattern = @[@50,@0];
    _overlay.lineDashPhase   = 1;
    _overlay.opacity         = 0.5;
    [self.layer addSublayer:_overlay];
}

- (void)addOtherLay:(CGRect)rect
{
    CAShapeLayer* layerTop   = [[CAShapeLayer alloc] init];
    layerTop.fillColor       = [UIColor blackColor].CGColor;
    layerTop.opacity         = 0.5;
    layerTop.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.origin.y)].CGPath;
    [self.layer addSublayer:layerTop];
    
    CAShapeLayer* layerLeft   = [[CAShapeLayer alloc] init];
    layerLeft.fillColor       = [UIColor blackColor].CGColor;
    layerLeft.opacity         = 0.5;
    layerLeft.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y, 50, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerLeft];
    
    CAShapeLayer* layerRight   = [[CAShapeLayer alloc] init];
    layerRight.fillColor       = [UIColor blackColor].CGColor;
    layerRight.opacity         = 0.5;
    layerRight.path            = [UIBezierPath bezierPathWithRect:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, rect.origin.y, 50, [UIScreen mainScreen].bounds.size.height)].CGPath;
    [self.layer addSublayer:layerRight];
    
    CAShapeLayer* layerBottom   = [[CAShapeLayer alloc] init];
    layerBottom.fillColor       = [UIColor blackColor].CGColor;
    layerBottom.opacity         = 0.5;
    layerBottom.path            = [UIBezierPath bezierPathWithRect:CGRectMake(50, rect.origin.y + rect.size.height, [UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - rect.origin.y - rect.size.height)].CGPath;
    [self.layer addSublayer:layerBottom];

}
@end
