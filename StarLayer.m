//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 Ian Voyce. All rights reserved.
//

#import "StarLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation StarLayer

@synthesize root = _rootLayer;

-(id)initWithRect:(CGRect)rect  {
    self = [super init];
    if (self) {
        // Initialization code
        [self setupLayers:rect];
    }
    return self;
    
}

-(void)setupLayers:(CGRect)rect {
    _rootLayer = [CALayer layer];
    _rootLayer.frame = rect;
    
    _starLayer = [CALayer layer];
	_starLayer.frame = CGRectMake(0,0,rect.size.width,rect.size.height);
    _starLayer.delegate = self;
    [_starLayer setNeedsDisplay];
    
    float TWOPI = 2 * 3.1415926535;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration=8.0;
    animation.repeatCount=HUGE_VALF;
    animation.autoreverses=NO;
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:TWOPI];
    [_starLayer addAnimation:animation forKey:@"rotation"];
    
    [_rootLayer addSublayer:_starLayer];

    _textLayer = [CALayer layer];
    _textLayer.delegate = self;
    _textLayer.frame = CGRectMake(0, 0, rect.size.width,rect.size.height);
    [_textLayer setNeedsDisplay];
    
    [_rootLayer addSublayer:_textLayer];
}

- (void)drawLayer:(CALayer *)theLayer
        inContext:(CGContextRef)context 
{
    if (theLayer == _textLayer)
    {
        UIGraphicsPushContext(context);
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:24.0];
        NSString *s = @"Hello!";
        CGSize sz = [s sizeWithFont:font 
                 constrainedToSize:theLayer.bounds.size 
                     lineBreakMode:UILineBreakModeClip];
        CGRect r = CGRectOffset(CGRectMake(0, 0, theLayer.bounds.size.width, sz.height), 0, (theLayer.bounds.size.height-sz.height)/2);
        [s drawInRect:r 
             withFont:font
        lineBreakMode:UILineBreakModeClip 
            alignment:UITextAlignmentCenter];
        CGContextRestoreGState(context);
        UIGraphicsPopContext();
        return;
    }
    CGRect frame = theLayer.frame;
    CGPoint offset = CGPointMake(frame.size.width/2, frame.size.height/2);
    int r1 = frame.size.width/2;
    int r2 = r1 - 20;
    int npoints = 60;
    float TWOPI = 2 * 3.1415926535;
    CGMutablePathRef r = CGPathCreateMutable();
    for (float n=0; n < npoints; n+=3)
    {
        int x1 = offset.x + sin((TWOPI/npoints) * n) * r2;
        int y1 = offset.y + cos((TWOPI/npoints) * n) * r2;
        if (n==0)
            CGPathMoveToPoint(r, NULL, x1, y1);
        else
            CGPathAddLineToPoint(r, NULL, x1, y1);
        int x2 = offset.x + sin((TWOPI/npoints) * n+1) * r1;
        int y2 = offset.y + cos((TWOPI/npoints) * n+1) * r1;
        CGPathAddLineToPoint(r, NULL, x2, y2);
        int x3 = offset.x + sin((TWOPI/npoints) * n+2) * r2;
        int y3 = offset.y + cos((TWOPI/npoints) * n+2) * r2;
        CGPathAddLineToPoint(r, NULL, x3, y3);
    }
    CGPathCloseSubpath(r);
    
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(4, 4), 5); 
    
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddPath(context, r);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

@end
