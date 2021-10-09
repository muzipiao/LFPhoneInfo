//
//  main.m
//  LFPhoneInfoDemo
//
//  Created by lifei on 2021/10/9.
//

#import <UIKit/UIKit.h>
#import "LFAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([LFAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
