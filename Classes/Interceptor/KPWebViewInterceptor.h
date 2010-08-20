//
//  KPWebViewInterceptor.h
//  Jobsworth
//
//  Created by Danny Wartnaby on 14/08/2010.
//  Copyright 2010 www.knowledgeisporridge.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPInvocation;

@interface KPWebViewInterceptor : NSObject <UIWebViewDelegate> {

    id<UIWebViewDelegate> delegate;
}

@property (retain, nonatomic) id<UIWebViewDelegate> delegate;

+ (KPWebViewInterceptor *)newInterceptorAttaching:(UIWebView *)webview to:(id<UIWebViewDelegate>)delegate_;

- (void)attach:(UIWebView *)webview to:(id<UIWebViewDelegate>)delegate_;
- (BOOL)representsCall:(NSURLRequest *)request;
- (KPInvocation *)newInvocationForRequest:(NSURLRequest *)request;

@end


@interface KPInvocation : NSObject {
    NSMutableArray * argumentNames;
    NSMutableArray * argumentValues;    
    NSString * messageName;
}

- (id)initWithMessageName:(NSString *)name;
- (void)invokeOn:(id)target;
- (BOOL)hasArguments;
- (KPInvocation *)initalArgument:(id)value;
- (KPInvocation *)argument:(NSString *)name value:(id)value;
- (id)appropriateArgumentInstance:(NSString *)expression;

@end



