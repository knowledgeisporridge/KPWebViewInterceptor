//
//  KPWebViewInterceptorViewController.h
//  KPWebViewInterceptor
//
//  Created by Danny Wartnaby on 14/08/2010.
//  Copyright www.knowledgeisporridge.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPWebViewInterceptor.h"
#import "KPMessageViewController.h"

@interface KPWebViewInterceptorViewController : UIViewController <UIWebViewDelegate> {

    KPWebViewInterceptor *interceptor;
    KPMessageViewController *messageViewController;
    UIWebView *webview;
}

@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) IBOutlet KPMessageViewController *messageViewController;
@property (nonatomic, retain) KPWebViewInterceptor * interceptor;

#pragma mark -
#pragma mark ----- Methods invoked directly from Javascript -----

- (void)sayHello;
- (void)say:(NSString *)message;
- (void)say:(NSString *)message withTitle:(NSString *)title;

- (void)showMessageViewControllerWith:(NSString *)message andTitle:(NSString *)title;

@end

