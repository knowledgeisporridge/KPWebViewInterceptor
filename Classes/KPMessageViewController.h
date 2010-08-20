//
//  KPMessageViewController.h
//  KPWebViewInterceptor
//
//  Created by Danny Wartnaby on 15/08/2010.
//  Copyright 2010 www.knowledgeisporridge.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KPMessageViewController : UIViewController {

    UILabel *titleLabel;
    UITextView *messageTextView;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *messageTextView;

- (IBAction)dismiss:(id)sender;

@end
