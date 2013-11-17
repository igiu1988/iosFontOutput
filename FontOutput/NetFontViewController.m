//
//  NetFontViewController.m
//  FontOutput
//
//  Created by wangyang on 13-11-14.
//  Copyright (c) 2013年 com.wy. All rights reserved.
//

#import "NetFontViewController.h"
#import <CoreText/CoreText.h>
#import "FontCell.h"

@interface NetFontViewController ()
@property (strong, nonatomic) NSString *errorMessage;

@end

@implementation NetFontViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fontNames = [[NSArray alloc] initWithObjects:
                      @"STXingkai-SC-Light",
                      @"DFWaWaSC-W5",
                      @"FZLTXHK--GBK1-0",
                      @"STLibian-SC-Regular",
                      @"LiHeiPro",
                      @"HiraginoSansGB-W3",
                      nil];
	self.fontSamples = [[NSArray alloc] initWithObjects:
						@"汉体书写信息技术标准相",
						@"容档案下载使用界面简单",
						@"支援服务升级资讯专业制",
						@"作创意空间快速无线上网",
						@"兙兛兞兝兡兣嗧瓩糎",
						@"㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩",
						nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/**
 *  查看该字体是否存在，不存在会去网上下载
 *
 *  @param fontName     字体名
 *  @param label        预览label
 *  @param progressView 下载进度
 */
- (void)asynchronouslySetFontName:(NSString *)fontName previewLabel:(UILabel *)label progressView:(UIProgressView *)progressView
{
	UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // 查看该字体在系统是否已经存在
	if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
		NSUInteger sampleIndex = [_fontNames indexOfObject:fontName];
		label.text = [_fontSamples objectAtIndex:sampleIndex];
		label.font = [UIFont fontWithName:fontName size:24.];
		return;
	}
	
    // Create a dictionary with the font's PostScript name.
	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
	__block BOOL errorDuringDownload = NO;
	
	// Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
		//NSLog( @"state %d - %@", state, progressParameter);
		
		double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
		
		if (state == kCTFontDescriptorMatchingDidBegin) {
			dispatch_async( dispatch_get_main_queue(), ^ {
                
                // Show something in the text view to indicate that we are downloading
                label.text= [NSString stringWithFormat:@"Downloading %@", fontName];
				label.font = [UIFont systemFontOfSize:14.];
				
				NSLog(@"Begin Matching");
			});
		} else if (state == kCTFontDescriptorMatchingDidFinish) {
			dispatch_async( dispatch_get_main_queue(), ^ {

                // Display the sample text for the newly downloaded font
				NSUInteger sampleIndex = [_fontNames indexOfObject:fontName];
				label.text = [_fontSamples objectAtIndex:sampleIndex];
				label.font = [UIFont fontWithName:fontName size:24.];
				
                // Log the font URL in the console
				CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
				NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
				CFRelease(fontRef);
                
				if (!errorDuringDownload) {
					NSLog(@"%@ downloaded", fontName);
				}
			});
		} else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
                // Show a progress bar
				progressView.progress = 0.0;
				progressView.hidden = NO;
				NSLog(@"Begin Downloading");
			});
		} else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
				progressView.hidden = YES;
				NSLog(@"Finish downloading");
			});
		} else if (state == kCTFontDescriptorMatchingDownloading) {
			dispatch_async( dispatch_get_main_queue(), ^ {
                // Use the progress bar to indicate the progress of the downloading
				[progressView setProgress:progressValue / 100.0 animated:YES];
				NSLog(@"Downloading %.0f%% complete", progressValue);
			});
		} else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                progressView.hidden = YES;
				NSLog(@"Download error: %@", _errorMessage);
			});
		}
        
		return (bool)YES;
	});
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_fontNames count];
}


- (FontCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"netFontCell";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	FontCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// Set up the cell.
	cell.textLabel.text = _fontNames[indexPath.row];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FontCell *cell = (FontCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self asynchronouslySetFontName:_fontNames[indexPath.row] previewLabel:cell.detailTextLabel progressView:cell.progressView];
}

@end
