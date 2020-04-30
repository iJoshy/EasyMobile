#import "ShadowEditText.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShadowEditText

-(void)setupView
{
    
    self.layer.borderColor = [UIColor colorWithRed:87.0/255.0 green:127.0/255.0 blue:24.0/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
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