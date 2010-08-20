//
//  KPWebViewInterceptorAppDelegate.h
//  KPWebViewInterceptor
//
//  Created by Danny Wartnaby on 14/08/2010.
//  Copyright www.knowledgeisporridge.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPWebViewInterceptorViewController;

@interface KPWebViewInterceptorAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    KPWebViewInterceptorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KPWebViewInterceptorViewController *viewController;

@end

