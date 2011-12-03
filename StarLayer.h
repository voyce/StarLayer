//
//  TextLayerDrawer.h
//  spelling
//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/CALayer.h>

@interface StarLayer : NSObject {
    CALayer *_rootLayer;
    CALayer *_starLayer;
    CALayer *_textLayer;
}
-(id)initWithRect:(CGRect)rect;
-(void)setupLayers:(CGRect)rect;

@property (readonly) CALayer *root;
@end
