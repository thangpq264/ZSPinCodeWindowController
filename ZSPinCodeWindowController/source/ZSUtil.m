//
//  ZSUtil.m
//  ZSPinCodeWindowController
//
//  Created by Pham Quang Thang on 6/25/15.
//  Copyright (c) 2015 ZooStudio. All rights reserved.
//

#import "ZSUtil.h"

@implementation ZSUtil

+ (NSString*)keyboardTextFromKeyCode:(NSInteger)code {
    switch (code) {
        case 18:
        case 83:
            return @"1";
            break;
        case 19:
        case 84:
            return @"2";
            break;
            
        case 20:
        case 85:
            return @"3";
            break;
            
        case 21:
        case 86:
            return @"4";
            break;
            
        case 23:
        case 87:
            return @"5";
            break;
            
        case 22:
        case 88:
            return @"6";
            break;
            
        case 26:
        case 89:
            return @"7";
            break;
            
        case 28:
        case 91:
            return @"8";
            break;
            
        case 25:
        case 92:
            return @"9";
            break;
            
        case 29:
        case 82:
            return @"0";
            break;
            
        default:
            break;
    }
    return nil;
}

@end
