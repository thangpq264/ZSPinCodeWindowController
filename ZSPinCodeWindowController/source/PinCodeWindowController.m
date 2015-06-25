//
//  PinCodeWindowController.m
//  MoneyLover-mac
//
//  Created by Pham Quang Thang on 6/12/15.
//  Copyright (c) 2015 Zoo Studio. All rights reserved.
//

#import "PinCodeWindowController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZSUtil.h"

@interface PinCodeWindowController () {
    NSString *_sPinCode;
    NSString *_sConfirm;
    NSMutableString *_sTemp;
}

@end

#define IMG_PIN_CHECKED @"img_pin_checked"
#define IMG_PIN_UNCHECKED @"img_pin_unchecked"

@implementation PinCodeWindowController
@synthesize animationView;

- (id)initWithPinCodeType:(PinCodeType)pinCodeType {
    self = [super initWithWindowNibName:@"PinCodeWindowController"];
    if (self) {
        _pinCodeType = pinCodeType;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    
    [self.window.contentView setBackgroundColor:[NSColor whiteColor]];
    _aboutView.layer.backgroundColor = [NSColor greenColor].CGColor;
    _aboutView.alphaValue = 0.5f;

    [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    
    _sTemp = [NSMutableString new];
    
    [self setupTitle];
}

- (void)setupTitle {
    switch (_pinCodeType) {
        case PinCodeTypeCreate:
            _lbDetail.stringValue = @"Choose PIN code";
            break;
        case PinCodeTypeRemove:
            _lbDetail.stringValue = @"Enter PIN code";
            break;
            
        case PinCodeTypeSecurity:
            _lbDetail.stringValue = @"Enter PIN code";
            break;
            
        default:
            break;
    }
}

- (void)keyUp:(NSEvent *)theEvent {
    NSInteger keyCode = [theEvent keyCode];
    
    // delete button
    if (keyCode == 51) {
        if ([_sTemp length] > 0) {
            [_sTemp deleteCharactersInRange:NSMakeRange(_sTemp.length-1, 1)];
        }
    }
    
    NSString *character = [ZSUtil keyboardTextFromKeyCode:keyCode];
    if (character) [_sTemp appendString:character];
    
    switch ([_sTemp length]) {
        case 0:
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            break;
        case 1:
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            break;
        case 2:
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            break;
        case 3:
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            break;
        case 4:
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_CHECKED]];
            [self notifyDelegate:_sTemp];
            break;

    }
}

- (void)notifyDelegate:(NSString*)pinCode {
    [_delegate pincodeController:self pincodeEntered:pinCode];
}

- (void)resetWithAnimation:(PinCodeAnimationStyle)animationStyle {
    [self performSelector:@selector(internalResetWithAnimation:) withObject:[NSNumber numberWithInt:animationStyle] afterDelay:0];
}

- (void)internalResetWithAnimation:(NSNumber *)animationStyleNumber {
    PinCodeAnimationStyle animationStyle = [animationStyleNumber intValue];
    switch (animationStyle) {
        case PinCodeAnimationStyleInvalid:
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDelegate:self];
            [animation setDuration:0.025];
            [animation setRepeatCount:8];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithPoint:
                                     CGPointMake(animationView.frame.origin.x - 14.0f, animationView.frame.origin.y)]];
            [animation setToValue:[NSValue valueWithPoint:
                                   CGPointMake(animationView.frame.origin.x + 14.0f, animationView.frame.origin.y)]];
            [[animationView layer] addAnimation:animation forKey:@"position"];
        }
            break;
        case PinCodeAnimationStyleConfirm:
        {
            [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
            [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];

            CATransition *transition = [CATransition animation];
            [transition setDelegate:self];
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromRight];
            [transition setDuration:0.5f];
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [[animationView layer] addAnimation:transition forKey:@"swipe"];
        }
            break;
        case PinCodeAnimationStyleNone:;
        default:
            break;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self resetView];
}

- (void)resetView {
    [_symbol0 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol1 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol2 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_symbol3 setImage:[NSImage imageNamed:IMG_PIN_UNCHECKED]];
    [_sTemp deleteCharactersInRange:NSMakeRange(0, [_sTemp length])];
}

- (BOOL)windowShouldClose:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(pincodeControllerClose:)]) {
        [_delegate pincodeControllerClose:self];
    }

    return YES;
}

@end
