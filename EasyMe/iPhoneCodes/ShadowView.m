#import "ShadowView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShadowView

-(void)setupView
{
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.rasterizationScale = YES;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    
}

-(id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        [self setupView];
    }
    
    return self;
}

@end