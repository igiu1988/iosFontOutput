//
//  ViewController.m
//  FontOutput
//
//  Created by wangyang on 13-11-13.
//  Copyright (c) 2013年 com.wy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UILabel *label;
    __weak IBOutlet UITextView *textView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSArray *fonts = [UIFont familyNames];
    for (NSString *font in fonts) {
        NSString *display = [NSString stringWithFormat:@"%@123汪洋\n", font];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:display attributes:@{NSFontAttributeName: [UIFont fontWithName:font size:21]}];
        [totalString appendAttributedString:attString];
    }
    textView.attributedText = totalString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
