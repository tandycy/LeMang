//
//  IconImageViewLoaderWithButton.m
//  LeMang
//
//  Created by LZ on 9/24/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "IconImageViewLoaderWithButton.h"

@implementation IconImageViewLoaderWithButton
{
    SEL onButtonPress;
    id selTarget;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void) InitButton
{
    UIImageButton *cornerButton = [[UIImageButton alloc]initWithFrame:CGRectMake(67, 0, 15, 15)];
    [cornerButton setBackgroundColor:[UIColor whiteColor]];
    [cornerButton addTarget:self action:@selector(_cornerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setUserInteractionEnabled:YES];
    [self addSubview:cornerButton];
    
    localButton = cornerButton;
}

- (void) SetButtonSelector:(SEL)sel target:(id)target
{
    onButtonPress = sel;
    selTarget = target;
}

- (void) SetButtonImage:(UIImage *)img
{
    if (localButton == nil)
        [self InitButton];
    
    [localButton setImage:img forState:UIControlStateNormal];
}

-(IBAction)_cornerButtonClick:(id)sender
{
    if (onButtonPress != nil && onButtonPress != NULL && selTarget != NULL && selTarget != nil)
        [selTarget performSelector:onButtonPress withObject:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
