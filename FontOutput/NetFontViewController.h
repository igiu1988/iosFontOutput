//
//  NetFontViewController.h
//  FontOutput
//
//  Created by wangyang on 13-11-14.
//  Copyright (c) 2013年 com.wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetFontViewController : UITableViewController
@property (strong, nonatomic) NSArray *fontNames;
@property (strong, nonatomic) NSArray *fontSamples;
@property (weak, nonatomic) IBOutlet UITableView *fTableView;
@property (weak, nonatomic) IBOutlet UITextView *fTextView;
@property (weak, nonatomic) IBOutlet UIProgressView *fProgressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fActivityIndicatorView;
@end
