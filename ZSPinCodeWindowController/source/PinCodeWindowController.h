//
//  PinCodeWindowController.h
//  MoneyLover-mac
//
//  Created by Pham Quang Thang on 6/12/15.
//  Copyright (c) 2015 Zoo Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class  PinCodeWindowController;
@protocol PinCodeViewControllerDelegate <NSObject>
@optional
- (void)pincodeController:(PinCodeWindowController *)controller pincodeEntered:(NSString *)passCode;
- (void)pincodeControllerCancel:(PinCodeWindowController *)controller;
- (void)pincodeControllerClose:(PinCodeWindowController*)controller;

@end

typedef enum {
    PinCodeAnimationStyleNone,
    PinCodeAnimationStyleInvalid,
    PinCodeAnimationStyleConfirm
} PinCodeAnimationStyle;

typedef enum : NSUInteger {
    PinCodeTypeSecurity = 1,
    PinCodeTypeCreate = 1 << 1,
    PinCodeTypeRemove = 1 << 2
} PinCodeType;

@interface PinCodeWindowController : NSWindowController <NSWindowDelegate>

@property (assign) PinCodeType pinCodeType;

@property (weak) IBOutlet NSView *aboutView;

@property (assign) id<PinCodeViewControllerDelegate> delegate;

@property (weak) IBOutlet NSTextField *lbDetail;
@property (weak) IBOutlet NSTextField *lbSubDetail;

@property (weak) IBOutlet NSView *animationView;
@property (weak) IBOutlet NSImageView *symbol0;
@property (weak) IBOutlet NSImageView *symbol1;
@property (weak) IBOutlet NSImageView *symbol2;
@property (weak) IBOutlet NSImageView *symbol3;

- (id)initWithPinCodeType:(PinCodeType)pinCodeType;
- (void)resetWithAnimation:(PinCodeAnimationStyle)animationStyle;
- (void)resetView;
- (void)setupTitle;
@end
