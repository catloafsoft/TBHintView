//
//  BasicHintView.m
//  TBHintViewDemo
//
//  Created by Stefan Immich on 4/6/12.
//  Copyright (c) 2012 touchbee Solutions. All rights reserved.
//

#import "DemoHintView.h"



@interface CustomHintViewInfo : NSObject

@property (nonatomic,copy) NSString* text;
@property (nonatomic,copy) NSString* buttonText;
@property (nonatomic,copy) DemoHintViewBlock buttonAction;

@end


@implementation CustomHintViewInfo

@synthesize text;
@synthesize buttonText;
@synthesize buttonAction;



@end


@interface DemoHintView()

@property (nonatomic,retain) TBHintView* hintView;
@property (nonatomic,copy) DemoHintViewBlock dismissedBlock;
@property (nonatomic,copy) DemoHintViewBlock customDismissedBlock;

@property (nonatomic) NSMutableDictionary* pageContent;
@property (nonatomic) NSMutableDictionary* pageTitles;

@end


@implementation DemoHintView

@synthesize hintView;
@synthesize dismissedBlock;
@synthesize customDismissedBlock;
@synthesize pageTitles;
@synthesize pageContent;
@synthesize title;
@synthesize icon;
@synthesize maxHeight;
@synthesize hintID;


+(DemoHintView*) infoHintView
{
    DemoHintView* basicHintView = [[DemoHintView alloc] init];
    
    basicHintView.hintView.textColor = [UIColor whiteColor];
    basicHintView.hintView.backgroundImage = [UIImage imageNamed:@"pattern2.jpg"];
    basicHintView.hintView.spanWidthWeight = 0.95f;
    basicHintView.hintView.presentationAnimation = kHintViewPresentationSlide;
    basicHintView.hintView.backgroundImage = [UIImage imageNamed:@"pattern2.jpg"];
    
    basicHintView.icon = [UIImage imageNamed:@"90-lifebuoy"];
    
    __weak DemoHintView *hintView = basicHintView;
    basicHintView.customDismissedBlock = ^{
        [DemoHintView setHasDismissedHint:hintView.hintID];
    };
    
    return basicHintView;
}


+(DemoHintView*) warningHintView
{
    DemoHintView* basicHintView = [[DemoHintView alloc] init];
    
    basicHintView.hintView.textColor = [UIColor whiteColor];
    basicHintView.hintView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:10/255.0 blue:5/255.0 alpha:0.9];
    basicHintView.hintView.spanWidthWeight = 0.95f;
    basicHintView.hintView.presentationAnimation = kHintViewPresentationBounce;
    
    basicHintView.icon = [UIImage imageNamed:@"90-lifebuoy"];
    
    return basicHintView;
}


+(DemoHintView*) otherHintView
{
    DemoHintView* basicHintView = [[DemoHintView alloc] init];
    
    basicHintView.hintView.textColor = [UIColor whiteColor];
    basicHintView.hintView.backgroundColor = [UIColor colorWithRed:89.0/255.0 green:119.0/255.0 blue:39.0/255.0 alpha:0.9];
    basicHintView.hintView.spanWidthWeight = 0.95f;
    basicHintView.hintView.presentationAnimation = kHintViewPresentationFade;
    
    basicHintView.icon = [UIImage imageNamed:@"90-lifebuoy"];
    
    return basicHintView;
}


-(id)init
{
    self = [super init];
    
    if( self )
    {
        self.hintView = [[TBHintView alloc] init];
        
        self.hintView.dataSource = self;
        self.hintView.delegate = self;
        
        self.pageContent = [NSMutableDictionary dictionaryWithCapacity:10];
        self.pageTitles = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    return self;
}




-(void) addPageWithTitle:(NSString*)title_ text:(NSString*)text_
{
    NSNumber* pageNumber = @(self.pageContent.count);
    
    [self.pageContent setObject:text_ forKey:pageNumber];
    [self.pageTitles setObject:title_ forKey:pageNumber];
}


-(void) addPageWithTitle:(NSString*)title_ image:(UIImage*)image_
{
    NSNumber* pageNumber = @(self.pageContent.count);
    
    [self.pageContent setObject:image_ forKey:pageNumber];
    [self.pageTitles setObject:title_ forKey:pageNumber];
}


-(void) addPageWithText:(NSString*)text
{
    NSNumber* pageNumber = @(self.pageContent.count);
    
    [self.pageContent setObject:text forKey:pageNumber];
}


-(void) addPageWithImage:(UIImage*)image
{
    NSNumber* pageNumber = @(self.pageContent.count);
    
    [self.pageContent setObject:image forKey:pageNumber];
}


-(void) addPageWithtitle:(NSString*)title_ text:(NSString*)text buttonText:(NSString*)buttonText buttonAction:(DemoHintViewBlock)buttonAction
{
    NSNumber* pageNumber = @(self.pageContent.count);
    
    [self.pageTitles setObject:title_ forKey:pageNumber];
    
    CustomHintViewInfo* customHintViewInfo = [[CustomHintViewInfo alloc] init];
    
    customHintViewInfo.text = text;
    customHintViewInfo.buttonText = buttonText;
    customHintViewInfo.buttonAction = buttonAction;
    
    [self.pageContent setObject:customHintViewInfo forKey:pageNumber];
}


-(void) addPageWithText:(NSString*)text buttonText:(NSString*)buttonText buttonAction:(DemoHintViewBlock)buttonAction
{
    CustomHintViewInfo* customHintViewInfo = [[CustomHintViewInfo alloc] init];
    
    customHintViewInfo.text = text;
    customHintViewInfo.buttonText = buttonText;
    customHintViewInfo.buttonAction = buttonAction;
    
    NSNumber* pageNumber = @(self.pageContent.count);
    [self.pageContent setObject:customHintViewInfo forKey:pageNumber];
}


-(void) setDismissedHandler:(DemoHintViewBlock)dismissed
{
    self.dismissedBlock = dismissed;
}


-(void) showInView:(UIView*)view duration:(NSTimeInterval)duration
{
    [self showInView:view orientation:kHintViewOrientationBottom duration:duration];
}


-(void) showInView:(UIView*)view orientation:(TBHintViewOrientation)orientation_ duration:(NSTimeInterval)duration
{
    self.hintView.orientation = orientation_;
    
    // Keep self alive until dismissed
    
    [view addSubview:self.hintView];
    [view bringSubviewToFront:self.hintView];
    
    [self.hintView show:duration];
}


-(void) showInView:(UIView*)view
{    
    [self showInView:view orientation:kHintViewOrientationBottom];
}


-(void) showInView:(UIView*)view orientation:(TBHintViewOrientation)orientation_
{
    self.hintView.orientation = orientation_;
    
    // Keep self alive until dismissed
    
    [view addSubview:self.hintView];
    [view bringSubviewToFront:self.hintView];
    
    [self.hintView show]; 
}


-(void) showInView:(UIView*)view duration:(NSTimeInterval)duration presentation:(TBHintViewPresentationAnimation)presentation
{
    [self showInView:view duration:duration presentation:presentation];
}


-(void) showInView:(UIView*)view orientation:(TBHintViewOrientation)orientation_ duration:(NSTimeInterval)duration presentation:(TBHintViewPresentationAnimation)presentation
{
    self.hintView.orientation = orientation_;
    self.hintView.presentationAnimation = presentation;
    
    // Keep self alive until dismissed
    
    [view addSubview:self.hintView];
    [view bringSubviewToFront:self.hintView];
    
    [self.hintView show:duration]; 
}


-(void) showInView:(UIView*)view presentation:(TBHintViewPresentationAnimation)presentation
{
    [self showInView:view orientation:kHintViewOrientationBottom presentation:presentation];
}


-(void) showInView:(UIView*)view orientation:(TBHintViewOrientation)orientation_ presentation:(TBHintViewPresentationAnimation)presentation
{
    self.hintView.orientation = orientation_;
    self.hintView.presentationAnimation = presentation;
    
    // Keep self alive until dismissed
    
    [view addSubview:self.hintView];
    [view bringSubviewToFront:self.hintView];
    
    [self.hintView show];
}


-(NSInteger)numberOfPagesInHintView:(TBHintView *)hintView
{
    return self.pageContent.count;
}


-(NSString *)titleForPage:(NSUInteger)page hintView:(TBHintView *)hintView
{
    if( self.title )
    {
        return self.title;
    }
    
    return self.pageTitles[@(page)];
}


-(NSString *)textForPage:(NSUInteger)page hintView:(TBHintView *)hintView
{
    id content = self.pageContent[@(page)];
    
    if( !content || ![content isKindOfClass:[NSString class]] )
    {
        return nil;
    }
    
    return content;
}


-(UIImage *)imageForPage:(NSUInteger)page hintView:(TBHintView *)hintView
{
    id content = self.pageContent[@(page)];
    
    if( !content || ![content isKindOfClass:[UIImage class]] )
    {
        return nil;
    }
    
    return content;
}


-(UIView *)viewForPage:(NSUInteger)page hintView:(TBHintView *)hintView_
{
    id content = self.pageContent[@(page)];
    
    if( !content || ![content isKindOfClass:[CustomHintViewInfo class]] )
    {
        return nil;
    }
    
    CustomHintViewInfo* customHintViewInfo = (CustomHintViewInfo*)content;

    // Build view
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    customView.userInteractionEnabled = YES;
    customView.backgroundColor = [UIColor clearColor];
    
    UILabel* labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 63)];
    labelText.backgroundColor = [UIColor clearColor];
    labelText.textColor = hintView_.textColor;
    labelText.numberOfLines = 0;
    labelText.font = [UIFont systemFontOfSize:15.0f];
    labelText.text = customHintViewInfo.text;
    labelText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    labelText.textAlignment = NSTextAlignmentCenter;

    UIButton* buttonAction = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonAction.frame = CGRectMake(13, 66, 173, 34);
    buttonAction.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    buttonAction.tag = page;
    [buttonAction setTitle:customHintViewInfo.buttonText forState:UIControlStateNormal];
    [buttonAction addTarget:self action:@selector(triggerButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [customView addSubview:labelText];
    [customView addSubview:buttonAction];

    return customView;
}


-(void) triggerButtonAction:(id)sender
{
    UIButton* button = (UIButton*)sender;
    
    CustomHintViewInfo* customHintViewInfo = self.pageContent[@(button.tag)];
    
    customHintViewInfo.buttonAction();
}


-(UIImage *)titleIconForPage:(NSUInteger)page hintView:(TBHintView *)hintView
{
    return self.icon;
}


-(void)dismissedHintView:(TBHintView *)hintView
{    
    if( self.customDismissedBlock )
    {
        self.customDismissedBlock();
    }
    
    if( self.dismissedBlock )
    {
        self.dismissedBlock();
    }
}


-(void) dismiss
{
    [self.hintView dismiss];
}


+(void) setHasDismissedHint:(NSUInteger)hintType
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"hints.seen.%@", @(hintType)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL) shouldShowHint:(NSUInteger)hintType
{
    if( ![DemoHintView hintsEnabled] )
    {
        return NO;
    }
    
    return ![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"hints.seen.%@", @(hintType)]];
}


+(void)resetAllHints
{
    for( NSUInteger hintID = kHintID_First; hintID < kHintID_Last; hintID++ ) 
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"hints.seen.%@", @(hintID)]];
    }
}


+(void) enableHints:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"HintsEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL) hintsEnabled
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"HintsEnabled"];
}


+(BOOL) isHintVisibleInView:(UIView*)view
{
    for (UIView* subview in view.subviews ) 
    {
        if( [subview isKindOfClass:[TBHintView class]] )
        {
            return YES;
        }
    }
    
    return NO;
}


+(void) dismissVisibleHintInView:(UIView*)view
{
    for (UIView* subview in view.subviews ) 
    {
        if( [subview isKindOfClass:[TBHintView class]] )
        {
            TBHintView* hintView = (TBHintView*)subview;
            [hintView dismiss];
        }
    }
}

@end
