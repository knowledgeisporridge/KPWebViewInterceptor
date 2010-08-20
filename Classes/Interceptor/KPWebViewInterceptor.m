//
//  KPWebViewInterceptor.m
//  Jobsworth
//
//  Created by Danny Wartnaby on 14/08/2010.
//  Copyright 2010 www.knowledgeisporridge.com. All rights reserved.
//

#import "KPWebViewInterceptor.h"

#define INVOCATION_COMMAND @"invoke"

#define ARGUMENT_CALL_OFFSET 2

@class KPInvocation;

@implementation KPWebViewInterceptor

@synthesize delegate;

+ (KPWebViewInterceptor *)newInterceptorAttaching:(UIWebView *)webview to:(id<UIWebViewDelegate>)delegate_ {
    KPWebViewInterceptor * interceptor = [[KPWebViewInterceptor alloc] init];
    
    [interceptor attach:webview to:delegate_];
    
    return interceptor;
}

/*
 * Establishes this object as the delegate for the given webview.
 */
- (void)attach:(UIWebView *)webview to:(id<UIWebViewDelegate>)delegate_ {
    
    webview.delegate = self; 
    self.delegate = delegate_;
}


#pragma mark -
#pragma mark ----- WebView Delegate methods -----

- (BOOL)webView:(UIWebView *)source shouldStartLoadWithRequest:(NSURLRequest *)request  navigationType:(UIWebViewNavigationType)navigationType {
    
    // Does this request represent an attempt to invoke a method on our delegate?
    if ( [self representsCall:request] ) {
        KPInvocation * invocation = [self newInvocationForRequest:request];
        
        [invocation invokeOn:self.delegate];
        [invocation release];
        
        // We're taking over, so don't propergate or load the request.
        return NO;
    }
    else {
        
        // We're not intercepting this request for the purpose of invoking functionality on our delegate, so pass the call on.
        if ( [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)] ) {
            return [self.delegate webView:source shouldStartLoadWithRequest:request navigationType:navigationType];
        }
        else {
            return YES;
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ( [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)] ) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ( [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)] ) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ( [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)] ) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}


#pragma mark -
#pragma mark ----- Utility methods -----

- (BOOL)representsCall:(NSURLRequest *)request {
    return [[[request URL] absoluteString] hasPrefix:INVOCATION_COMMAND];
}



#pragma mark -
#pragma mark ----- Inovation request methods -----

- (KPInvocation *)newInvocationForRequest:(NSURLRequest *)request {
    
    NSArray * requestComponents = [[[request URL] absoluteString] componentsSeparatedByString:@":"];
    
    // First value in the list an the command; this should be an invocation.
    assert( [[requestComponents objectAtIndex:0] isEqual:INVOCATION_COMMAND] );
    
    // Second value in the list is the message we're trying to send.
    NSString * message = [requestComponents objectAtIndex:1];
    
    
    KPInvocation * invocation = [[KPInvocation alloc] initWithMessageName:message];
    

    // The third is optional; it may be the first, unnamed, argument.
    if ( [requestComponents count] > 2 ) {
        [invocation initalArgument:[requestComponents objectAtIndex:2]];
    } 
    
    // Anything past the third position represents additional parameters, which should be in key-value pairs..
    if ( [requestComponents count] > 3 ) {
        NSArray * arguments = [[requestComponents subarrayWithRange:NSMakeRange( 3, [requestComponents count] - 3 )] retain];
    
        NSInteger idx = 0;
        while ( idx < [arguments count] ) {
            
            NSString * name  = [arguments objectAtIndex:idx]; idx++;
            NSString * value = [arguments objectAtIndex:idx]; idx++;
            
            [invocation argument:name value:value];
        }
        
        [arguments release];
    }
        
    return invocation;
}

- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

@end



/*
 * KPInvocation - simply encapsulates the logic and behavior needed to simplify the NSInvocation creation.
 */
@implementation KPInvocation 

/*
 * Init with the name of the message/method/selector that this KPInvocation will ultimately invoke.
 */
- (id)initWithMessageName:(NSString *)name {
    if ( self = [super init] ) {
        messageName = [name copy];
    }   
    
    return self;
}


- (void)dealloc {
	[argumentNames release], argumentNames = nil;
	[argumentValues release], argumentValues = nil;
    [messageName release], messageName = nil;
    [super dealloc];
}


/*
 * Builds and returns a string representing the method invocation represented by this object. The returned
 * selector name will include all named arguments provided.
 */
- (NSString *)buildSelectorForInvocation {
    NSMutableString * selector = [NSMutableString stringWithString:messageName];
    
    if ( [self hasArguments] ) {
        NSString * argumentName;
        for ( argumentName in argumentNames ) {
            [selector appendFormat:@"%@:", argumentName];
        }
    }
    
    return selector;
}

/*
 * Send the message represented by this invocation object to the given target.
 */ 
- (void)invokeOn:(id)target {
    SEL sel = NSSelectorFromString( [self buildSelectorForInvocation] );
   
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:sel]];
    
    [invocation setSelector:sel];
    [invocation setTarget:target];
    
    for ( NSInteger idx = 0; idx < [argumentValues count]; idx++ ) {
        id arg = [self appropriateArgumentInstance:[argumentValues objectAtIndex:idx]];
        
        [invocation setArgument:&arg atIndex:idx + ARGUMENT_CALL_OFFSET];
    }  
    
    // Kick it off. Aye.
    [invocation invoke];
}

/*
 * Returns an appropriate instance to act as the argument. For now, it's strings all the way.
 * This simply provides an extension point for future data types - dates and numbers spring to mind.
 */
- (id)appropriateArgumentInstance:(NSString *)expression {
    return [NSString stringWithString:expression];
}

/*
 * Returns true if arguments have been provided to this invocation, false otherwise.
 */
- (BOOL)hasArguments {
    return argumentNames != nil && [argumentNames count] > 0;   
}

/*
 * Sets the initial, unnamed argument for the method represented by this invocation.
 */
- (KPInvocation *)initalArgument:(id)value {
    return [self argument:@"" value:value];
}

- (KPInvocation *)argument:(NSString *)name value:(id)value {
    if ( argumentNames == nil ) {
        argumentNames  = [[NSMutableArray array] retain];
        argumentValues = [[NSMutableArray array] retain];        
    }
    
    NSInteger idx = [argumentNames count];
    [argumentNames insertObject:name atIndex:idx];
    [argumentValues insertObject:value atIndex:idx];

    return self;
}

@end

