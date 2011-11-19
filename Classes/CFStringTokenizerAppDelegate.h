//
//  CFStringTokenizerAppDelegate.h
//  CFStringTokenizer
//
//  Created by 大森 智史 on 10/11/19.
//  Copyright 2010 Satoshi Oomori. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFStringTokenizerViewController;

@interface CFStringTokenizerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CFStringTokenizerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CFStringTokenizerViewController *viewController;

@end

