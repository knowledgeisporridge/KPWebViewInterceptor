    //
//  KPMessageViewController.m
//  KPWebViewInterceptor
//
//  Created by Danny Wartnaby on 15/08/2010.
//  Copyright 2010 www.knowledgeisporridge.com. All rights reserved.
//

#import "KPMessageViewController.h"


@implementation KPMessageViewController

@synthesize titleLabel;
@synthesize messageTextView;

- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];   
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.titleLabel = nil;
    self.messageTextView = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
