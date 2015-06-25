//
//  ViewController.h
//  ZSPinCodeWindowController
//
//  Created by Pham Quang Thang on 6/25/15.
//  Copyright (c) 2015 ZooStudio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PinCodeViewControllerDelegate;

@interface ViewController : NSViewController <PinCodeViewControllerDelegate>
@property (weak) IBOutlet NSButton *btnSetPin;

@end

