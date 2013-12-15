//
//  HintView.h
//  TBHintView
//
//  Created by Stefan Immich on 4/5/12.
//  Copyright (c) 2012 touchbee Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kHintViewOrientationTop,
    kHintViewOrientationBottom
    
} TBHintViewOrientation;


typedef enum
{
    kHintViewPresentationFade,
    kHintViewPresentationDrop,
    kHintViewPresentationSwirl,
    kHintViewPresentationSlide,
    kHintViewPresentationBounce
    
} TBHintViewPresentationAnimation;


@protocol TBHintViewDataSource;
@protocol TBHintViewDelegate;

@interface TBHintView : UIView <UIScrollViewDelegate>

@property (nonatomic,weak) id<TBHintViewDataSource> dataSource;
@property (nonatomic,strong) id<TBHintViewDelegate> delegate;

@property (nonatomic,copy) UIImage* backgroundImage;
@property (nonatomic,copy) UIColor *textColor, *titleColor;
@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,assign) CGFloat spanWidthWeight; // Width weight between 0.01f and 1.0f
@property (nonatomic,assign) TBHintViewPresentationAnimation presentationAnimation;
@property (nonatomic,assign) TBHintViewOrientation orientation;
@property (nonatomic,assign) CGFloat maximumHeight;
@property (nonatomic,assign) NSTextAlignment titleAlignment;
@property (nonatomic,assign) BOOL handleLandscape;

- (id)initWithDismissImage:(UIImage *)image;

-(void) show;
-(void) show:(NSTimeInterval)duration;

-(void) dismiss;

@end



@protocol TBHintViewDataSource<NSObject>

@required

-(NSInteger) numberOfPagesInHintView:(TBHintView*)hintView; 

@optional

// However, one of these 3 need to be implemented
-(UIView*) viewForPage:(NSUInteger)page hintView:(TBHintView*)hintView;
-(NSString*) textForPage:(NSUInteger)page hintView:(TBHintView*)hintView;
-(UIImage*) imageForPage:(NSUInteger)page hintView:(TBHintView*)hintView;

// Get the font used to render the text on the page (only used if textForPage is implemented)
- (UIFont *) fontForPage:(NSUInteger)page hintView:(TBHintView *)hintView;

-(UIButton*) buttonForPage:(NSUInteger)page hintView:(TBHintView*)hintView;
-(CGSize) buttonSizeForPage:(NSUInteger)page hintView:(TBHintView*)hintView;

-(NSString*) titleForPage:(NSUInteger)page hintView:(TBHintView*)hintView;
-(UIImage*) titleIconForPage:(NSUInteger)page hintView:(TBHintView*)hintView;

@end



@protocol TBHintViewDelegate<NSObject>

@optional

-(void) dismissedHintView:(TBHintView*)hintView;
-(CGFloat) heightForHintView:(TBHintView*)hintView;

@end
