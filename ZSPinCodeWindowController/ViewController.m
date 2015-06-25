//
//  ViewController.m
//  ZSPinCodeWindowController
//
//  Created by Pham Quang Thang on 6/25/15.
//  Copyright (c) 2015 ZooStudio. All rights reserved.
//

#import "ViewController.h"
#import "PinCodeWindowController.h"
#import "AppDelegate.h"

@interface ViewController () {
    PinCodeWindowController *_pinCodeWindowController;
    BOOL hasPass;
    BOOL isConfirmPin;
    NSString *_sPinCode;
    NSString *_sConfirmCode;
    PinCodeType _pinCodeType;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkHasPass];
    _btnSetPin.state = hasPass;
    if (hasPass) {
        _pinCodeType = PinCodeTypeRemove;
    } else {
        _pinCodeType = PinCodeTypeCreate;
    }
    // Do any additional setup after loading the view.
}

- (void)checkHasPass {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *pass = [prefs valueForKey:PIN_CODE];
    _sPinCode = pass;
    hasPass = _sPinCode.length > 0;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)enablePinOnClicked:(id)sender {
    PinCodeType pinCodeType = hasPass ? PinCodeTypeRemove : PinCodeTypeCreate;
    
    if (!_pinCodeWindowController) {
        _pinCodeWindowController = [[PinCodeWindowController alloc]initWithPinCodeType:pinCodeType];
        _pinCodeWindowController.delegate = self;
    } else {
        _pinCodeWindowController.pinCodeType = pinCodeType;
        [_pinCodeWindowController setupTitle];
    }
    [_pinCodeWindowController showWindow:nil];
    _btnSetPin.enabled = NO;
    _btnSetPin.state = !_btnSetPin.state;
}

- (NSString*)enCryptPinCode:(NSString*)pinCode {
    int pin = [pinCode intValue];
    //processing... blo...bla
    //it's fun :D
    pin += 5;
    return [NSString stringWithFormat:@"%d",pin];
    
}

#pragma mark - PinCodeViewControllerDelegate
- (void)pincodeController:(PinCodeWindowController *)controller pincodeEntered:(NSString *)passCode {
    
    passCode = [self enCryptPinCode:passCode];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_pinCodeType & PinCodeTypeCreate ) {
        if (!isConfirmPin) {
            isConfirmPin = YES;
            _sPinCode = passCode;
            [controller resetWithAnimation:PinCodeAnimationStyleConfirm];
            _pinCodeWindowController.lbDetail.stringValue = @"Confirm PIN code";
            return;
        }
        
        if (![_sPinCode isEqualToString:passCode]) {
            [controller resetWithAnimation:PinCodeAnimationStyleInvalid];
            return;
        }
        isConfirmPin = NO;
        
        [userDefaults setObject:_sPinCode forKey:PIN_CODE];
        [userDefaults synchronize];
        
        
        _btnSetPin.state = NSOnState;
        _pinCodeType = PinCodeTypeRemove;
        [controller resetView];
        [controller.window orderOut:nil];
        _btnSetPin.enabled = YES;
        return;
    }
    
    else if (_pinCodeType & PinCodeTypeRemove) {
        if (![_sPinCode isEqualToString:passCode]) {
            [controller resetWithAnimation:PinCodeAnimationStyleInvalid];
            return;
        }
        
        [userDefaults setObject:@"" forKey:PIN_CODE];
        [userDefaults synchronize];
        
        _pinCodeType = PinCodeTypeCreate;
        _btnSetPin.state = NSOffState;
        [controller resetView];
        [controller.window orderOut:nil];
    }
    
    _btnSetPin.enabled = YES;

}

- (void)pincodeControllerClose:(PinCodeWindowController *)controller {
    _btnSetPin.enabled = YES;
}

@end
