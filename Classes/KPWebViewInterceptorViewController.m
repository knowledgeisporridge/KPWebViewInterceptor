//
//  KPWebViewInterceptorViewController.m
//  KPWebViewInterceptor
//
//  Created by Danny Wartnaby on 14/08/2010.
//  Copyright www.knowledgeisporridge.com 2010. All rights reserved.
//

#import "KPWebViewInterceptorViewController.h"

@implementation KPWebViewInterceptorViewController

@synthesize webview;
@synthesize messageViewController;
@synthesize interceptor;

- (void)viewDidLoad {
    
    // The important part to note is the interceptor - instantiate one, telling it to act as the middle man between our
    // view controller and it's webview.
    self.interceptor = [KPWebViewInterceptor newInterceptorAttaching:self.webview 
                                                                  to:self];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"interceptorexample" 
                                                                                                                  ofType:@"html"] isDirectory:NO]]];

    [super viewDidLoad];
}



#pragma mark -
#pragma mark ----- Methods invoked directly from Javascript -----


- (void)sayHello {
    [self showMessageViewControllerWith:@"Hello" andTitle:@"..."];
}

- (void)say:(NSString *)message {
    [self showMessageViewControllerWith:message andTitle:@"..."];
}

- (void)say:(NSString *)message withTitle:(NSString *)title {
    [self showMessageViewControllerWith:message andTitle:title];
}


- (void)showMessageViewControllerWith:(NSString *)message andTitle:(NSString *)title {
  
    messageViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:messageViewController animated:YES];
    
    messageViewController.titleLabel.text = title;
    messageViewController.messageTextView.text = message;
}


- (void)viewDidUnload {
	self.webview = nil;
        
    [super viewDidUnload];
}


- (void)dealloc {
    [self.webview release];
    [interceptor release];
    
    [super dealloc];
}

@end
