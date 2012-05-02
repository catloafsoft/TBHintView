//
//  HintView.m
//  TBHintView
//
//  Created by Stefan Immich on 4/5/12.
//  Copyright (c) 2012 touchbee Solutions. All rights reserved.
//

#import "TBHintView.h"
#import "UIView+SEAnimations.h"

#import <QuartzCore/QuartzCore.h>

@interface TBHintView()

@property (nonatomic) UIImageView* imageViewTitleIcon;
@property (nonatomic) UILabel* labelTitle;
@property (nonatomic) UIButton* buttonDismiss;
@property (nonatomic) UIImage *dismissImage;
@property (nonatomic) UIPageControl* pageControl;
@property (nonatomic) UIScrollView* scrollViewPages;
@property (nonatomic) NSTimer* dismissTimer;
@property (atomic,assign) BOOL isDismissing;

@end


@implementation TBHintView

@synthesize dataSource;
@synthesize delegate;
@synthesize imageViewTitleIcon;
@synthesize labelTitle;
@synthesize buttonDismiss;
@synthesize pageControl;
@synthesize scrollViewPages;
@synthesize backgroundImage;
@synthesize textColor;
@synthesize spanWidthWeight;
@synthesize presentationAnimation;
@synthesize orientation;
@synthesize dismissTimer;
@synthesize maximumHeight;
@synthesize isDismissing;
@synthesize dismissImage;


- (id)initWithDismissImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake( 0, 0, 320, 180)];
    if (self) {
        self.clipsToBounds = YES;
        self.spanWidthWeight = 1.0f;
        self.layer.cornerRadius = 12.0;
        self.maximumHeight = 160.0f;
        self.userInteractionEnabled = YES;
        self.presentationAnimation = kHintViewPresentationSlide;
        self.orientation = kHintViewOrientationBottom;
        self.dismissImage = image;
    }
    
    return self;
}

- (id)init
{
    return [self initWithDismissImage:[UIImage imageNamed:@"60-x"]];
}


-(void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
}


-(void) createSubviews
{
    self.imageViewTitleIcon.hidden = NO;
    self.labelTitle.hidden = NO;
    self.buttonDismiss.hidden = NO;
    self.pageControl.hidden = NO;
    self.scrollViewPages.hidden = NO;
}

#pragma mark - Getters

-(UIImageView *)imageViewTitleIcon
{
    if( !imageViewTitleIcon ) 
    {
        CGFloat yOffset = 0.0f;
        
        if( self.orientation == kHintViewOrientationTop )
        {
            yOffset = 10.0f;
        }
        else if( self.orientation == kHintViewOrientationBottom )
        {
            yOffset = 0.0f;
        }
        
        imageViewTitleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10 + yOffset, 20, 20)];
		imageViewTitleIcon.backgroundColor = [UIColor clearColor];

        imageViewTitleIcon.contentMode = UIViewContentModeScaleAspectFit;
        imageViewTitleIcon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        if( [self.dataSource respondsToSelector:@selector(titleIconForPage:hintView:)] )
        {
            imageViewTitleIcon.image = [self.dataSource titleIconForPage:0 hintView:self];
        }
        
        [self addSubview:imageViewTitleIcon];
    }
    
    return imageViewTitleIcon;
}


-(UILabel *)labelTitle
{
    if( !labelTitle ) 
    { 
        CGFloat yOffset = 0.0f;
        
        if( self.orientation == kHintViewOrientationTop )
        {
            yOffset = 10.0f;
        }
        else if( self.orientation == kHintViewOrientationBottom )
        {
            yOffset = 0.0f;
        }
        
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(36, 10 + yOffset, 244, 21)];
        labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		labelTitle.backgroundColor = [UIColor clearColor];
		labelTitle.adjustsFontSizeToFitWidth = YES;
		labelTitle.textAlignment = UITextAlignmentLeft;
        labelTitle.font = [UIFont boldSystemFontOfSize:17.0];
		labelTitle.shadowColor = [UIColor darkGrayColor];
		labelTitle.shadowOffset = CGSizeMake(0, -1);
        labelTitle.numberOfLines = 1;
        
        if( [self.dataSource respondsToSelector:@selector(titleForPage:hintView:)] )
        {
            labelTitle.text = [self.dataSource titleForPage:0 hintView:self];
        }
        
		[self addSubview:labelTitle];
    }
    
    return labelTitle;
}


-(UIButton *)buttonDismiss
{
    if( !buttonDismiss )
    {
        CGFloat yOffset = 0.0f;
        
        if( self.orientation == kHintViewOrientationTop )
        {
            yOffset = 10.0f;
        }
        else if( self.orientation == kHintViewOrientationBottom )
        {
            yOffset = 0.0f;
        }
        
        buttonDismiss = [[UIButton alloc] initWithFrame:CGRectMake( 286, 5 + yOffset, 32, 32)];
        buttonDismiss.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [buttonDismiss setImage:self.dismissImage forState:UIControlStateNormal];
        [buttonDismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:buttonDismiss];
    }
    
    return buttonDismiss;
}


-(UIPageControl *)pageControl
{
    if( !pageControl )
    {
        CGFloat yOffset = 0.0f;
        
        if( self.orientation == kHintViewOrientationTop )
        {
            yOffset = 10.0f;
        }
        else if( self.orientation == kHintViewOrientationBottom )
        {
            yOffset = 0.0f;
        }
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake( 0, 157 + yOffset, 320, 36 )];
        pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        pageControl.hidesForSinglePage = YES;
        
        [pageControl addTarget:self
                        action:@selector(changePage:) 
              forControlEvents:UIControlEventValueChanged];

        [self addSubview:pageControl];
    }
    
    return pageControl;
}


-(UIScrollView *)scrollViewPages
{
    if( !scrollViewPages )
    {
        CGFloat yOffset = 0.0f;
        
        if( self.orientation == kHintViewOrientationTop )
        {
            yOffset = 10.0f;
        }
        else if( self.orientation == kHintViewOrientationBottom )
        {
            yOffset = 0.0f;
        }
        
        scrollViewPages = [[UIScrollView alloc] initWithFrame:CGRectMake( 4, 33 + yOffset, 312, 128 )];
        scrollViewPages.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        scrollViewPages.backgroundColor = [UIColor clearColor];
        scrollViewPages.delegate = self;
        scrollViewPages.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollViewPages.userInteractionEnabled = YES;
        scrollViewPages.backgroundColor = [UIColor clearColor];
        
        [self addSubview:scrollViewPages];
    }
    
    return scrollViewPages;
}


-(void) show:(NSTimeInterval)time
{
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:time 
                                                         target:self
                                                       selector:@selector(dismiss)
                                                       userInfo:nil
                                                        repeats:NO];
    
    [self show];
}


-(void) show
{
    CGRect oldFrame = self.frame;
    
    // Initialization code
    self.frame = CGRectMake( 0, 0, 320, 180 );
    
    [self createSubviews];
    
    self.frame = oldFrame;

    CGRect parentFrame = self.superview.bounds;
    
    CGFloat height = self.maximumHeight;
 
    self.labelTitle.textColor = self.textColor;

    
    CGFloat width = parentFrame.size.width * spanWidthWeight;
    CGFloat margin = ( parentFrame.size.width - width ) / 2.0f;
    
    if( self.orientation == kHintViewOrientationBottom )
    {
        self.frame = CGRectMake( margin, 
                                parentFrame.origin.y + parentFrame.size.height - height + 10, 
                                width, 
                                height );
        
        CGRect outerFrame = self.superview.frame;
        outerFrame.size.height += 10;
        
        UIView* temp = [[UIView alloc] initWithFrame:outerFrame];
        
        if( self.presentationAnimation == kHintViewPresentationSlide )
        {
            [self animationSlideInWithDirection:kSEAnimationBottom boundaryView:temp duration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationFade )
        {
            [self animationFadeInWithDuration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationDrop )
        {
            [self animationDropInWithDuration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationSwirl )
        {
            [self animationSwirlInWithDuration:0.7];
        }
        else if( self.presentationAnimation == kHintViewPresentationBounce )
        {
            [self animationBounceInWithDirection:kSEAnimationBottom boundaryView:temp duration:0.3];
        }
    }
    else
    {
        self.frame = CGRectMake( margin, 
                                -10, 
                                width, 
                                height );
        
        CGRect outerFrame = self.superview.frame;
        outerFrame.size.height -= 10;
        
        UIView* temp = [[UIView alloc] initWithFrame:outerFrame];
        
        if( self.presentationAnimation == kHintViewPresentationSlide )
        {
            [self animationSlideInWithDirection:kSEAnimationTop boundaryView:temp duration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationFade )
        {
            [self animationFadeInWithDuration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationDrop )
        {
            [self animationDropInWithDuration:0.3];
        }
        else if( self.presentationAnimation == kHintViewPresentationSwirl )
        {
            [self animationSwirlInWithDuration:0.7];
        }
        else if( self.presentationAnimation == kHintViewPresentationBounce )
        {
            [self animationBounceInWithDirection:kSEAnimationTop boundaryView:temp duration:0.3];
        }
    }
    
    [self createPages];
    [self showPage:0];
}


-(void) dismiss
{    
    if( self.isDismissing )
    {
        return;
    }
    
    self.isDismissing = YES;
    
    if( self.dismissTimer )
    {
        [self.dismissTimer invalidate];
    }
        
    if( self.orientation == kHintViewOrientationBottom )
    {
        if( self.presentationAnimation == kHintViewPresentationSlide )
        {
            [self animationSlideOutWithDirection:kSEAnimationBottom boundaryView:self.superview duration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationFade )
        {
            [self animationFadeOutWithDuration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationDrop )
        {
            [self animationDropOutWithDuration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationSwirl )
        {
            [self animationSwirlOutWithDuration:0.7 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationBounce )
        {
            [self animationBounceOutWithDirection:kSEAnimationBottom boundaryView:self.superview duration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
    }
    else if( self.orientation == kHintViewOrientationTop )
    {
        if( self.presentationAnimation == kHintViewPresentationSlide )
        {
            [self animationSlideOutWithDirection:kSEAnimationTop boundaryView:self.superview duration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationFade )
        {
            [self animationFadeOutWithDuration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationDrop )
        {
            [self animationDropOutWithDuration:0.3 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationSwirl )
        {
            [self animationSwirlOutWithDuration:0.7 delegate:self startSelector:nil stopSelector:@selector(dismissAnimationCompleted)];
        }
        else if( self.presentationAnimation == kHintViewPresentationBounce )
        {
            [self animationBounceOutWithDirection:kSEAnimationTop
                                     boundaryView:self.superview
                                         duration:0.3 
                                         delegate:self
                                    startSelector:nil 
                                     stopSelector:@selector(dismissAnimationCompleted)];
        }
    }
}


-(void) dismissAnimationCompleted
{
    if( [self.delegate respondsToSelector:@selector(dismissedHintView:)] )
    {
        [self.delegate dismissedHintView:self];
    }
    
    [self removeFromSuperview];
}


-(void) createPages
{
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInHintView:self];
    self.pageControl.numberOfPages = numberOfPages;
    
    CGFloat scrollIndicatorOffset;
    if (numberOfPages > 1) {
        self.scrollViewPages.pagingEnabled = YES;
        scrollIndicatorOffset = 8.0f;
    } else { // Only one page
        self.scrollViewPages.pagingEnabled = NO;
        scrollIndicatorOffset = 0.0f;        
    }
    
    self.scrollViewPages.contentSize = CGSizeMake(self.scrollViewPages.bounds.size.width * numberOfPages, 
                                                  self.scrollViewPages.bounds.size.height - scrollIndicatorOffset);
    
    for( NSUInteger page = 0; page < numberOfPages; page++ )
    {
        if( [self.dataSource respondsToSelector:@selector(viewForPage:hintView:)] )
        {
            UIView* pageContent = [self.dataSource viewForPage:page hintView:self];
            
            if( pageContent )
            {
                pageContent.frame = CGRectMake(
                                               page * self.scrollViewPages.bounds.size.width + 5, 
                                               0, 
                                               self.scrollViewPages.bounds.size.width - 10, 
                                               self.scrollViewPages.bounds.size.height - scrollIndicatorOffset );
                
                [self.scrollViewPages addSubview:pageContent];
                
                continue;
            }
        }
        
        // Fetch the page components from the delegate
        
        UIImage* imageContent = nil;
        NSString* textContent = nil;
        UIButton *buttonContent = nil;
        
        if( [self.dataSource respondsToSelector:@selector(imageForPage:hintView:)] )
        {
            imageContent = [self.dataSource imageForPage:page hintView:self];
        }
        
        if( [self.dataSource respondsToSelector:@selector(textForPage:hintView:)] )
        {
            textContent = [self.dataSource textForPage:page hintView:self];
        }
        
        if( [self.dataSource respondsToSelector:@selector(buttonForPage:hintView:)] )
        {
            buttonContent = [self.dataSource buttonForPage:page hintView:self];
        }

        CGFloat pageHeight = self.scrollViewPages.bounds.size.height - scrollIndicatorOffset;

        if (buttonContent) { // Leave some room for a button under the content
            pageHeight -= 29;    
        }
        
        if( imageContent )
        {
            UIImageView* imageViewPage = [[UIImageView alloc] initWithFrame:CGRectMake( 
                                                                                       page * self.scrollViewPages.bounds.size.width + 5, 
                                                                                       0, 
                                                                                       self.scrollViewPages.bounds.size.width - 10, 
                                                                                       pageHeight)
                                          ];
            
            imageViewPage.image = imageContent;
            imageViewPage.contentMode = UIViewContentModeCenter;
            imageViewPage.backgroundColor = [UIColor clearColor];
            
            [self.scrollViewPages addSubview:imageViewPage];
        }
                
        if( textContent )
        {
            UILabel* labelText = [[UILabel alloc] initWithFrame:CGRectMake( 
                                                                           page * self.scrollViewPages.bounds.size.width + 5, 
                                                                           0, 
                                                                           self.scrollViewPages.bounds.size.width - 10, 
                                                                           pageHeight)
                                                                           ];
            
            labelText.numberOfLines = 0;
            labelText.textAlignment = UITextAlignmentCenter;
            labelText.text = textContent;
            labelText.textColor = self.textColor;
            labelText.backgroundColor = [UIColor clearColor];
            labelText.font = [UIFont systemFontOfSize:15.0f];
            
            [self.scrollViewPages addSubview:labelText];
        }

        if (buttonContent) {
            CGFloat buttonWidth = self.scrollViewPages.bounds.size.width * 0.7f;

            buttonContent.contentMode = UIViewContentModeCenter;
            buttonContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            buttonContent.frame = CGRectMake((self.scrollViewPages.bounds.size.width - buttonWidth)/2.0f, pageHeight, 
                                             buttonWidth, 29);
            [self.scrollViewPages addSubview:buttonContent];
        }
    
    }
    
    if( numberOfPages > 1 )
    {
        [self.scrollViewPages flashScrollIndicators];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = self.scrollViewPages.contentOffset.x / self.scrollViewPages.bounds.size.width;
    if( page < 0 ) 
        page = 0;
    
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInHintView:self];
    if( page >= numberOfPages )
        page = numberOfPages - 1;
    
    // Update page control
    self.pageControl.currentPage = page;
    
    // Update title
    if( [self.dataSource respondsToSelector:@selector(titleForPage:hintView:)] )
    {
        labelTitle.text = [self.dataSource titleForPage:page hintView:self];
    }
    
    // Update title icon
    if( [self.dataSource respondsToSelector:@selector(titleIconForPage:hintView:)] )
    {
        self.imageViewTitleIcon.image = [self.dataSource titleIconForPage:page hintView:self];
    }
}


-(void) changePage:(id)sender
{
    [self showPage:self.pageControl.currentPage];
}


-(void)showPage:(NSInteger)page
{
    self.scrollViewPages.contentOffset = CGPointMake( page * self.scrollViewPages.bounds.size.width, 0 );
    
    // Update title
    if( [self.dataSource respondsToSelector:@selector(titleForPage:hintView:)] )
    {
        self.labelTitle.text = [self.dataSource titleForPage:page hintView:self];
    }
    
    // Update title icon
    if( [self.dataSource respondsToSelector:@selector(titleIconForPage:hintView:)] )
    {
        self.imageViewTitleIcon.image = [self.dataSource titleIconForPage:page hintView:self];
    }
}


-(void)setSpanWidthWeight:(CGFloat)spanWidthWeight_
{
    spanWidthWeight = spanWidthWeight_;
    
    if( spanWidthWeight > 1.0f )
    {
        spanWidthWeight = 1.0f;
    }
    
    if( spanWidthWeight < 0.1f )
    {
        spanWidthWeight = 0.1f;
    }
}


-(void)setBackgroundImage:(UIImage *)backgroundImage_
{
    self.layer.contents = (id)backgroundImage_.CGImage;
}

@end
