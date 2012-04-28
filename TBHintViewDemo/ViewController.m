//
//  ViewController.m
//  TBHintViewDemo
//
//  Created by Stefan Immich on 4/9/12.
//  Copyright (c) 2012 touchbee Solutions. All rights reserved.
//

#import "ViewController.h"
#import "DemoHintView.h"


@interface ViewController ()

-(void) displayHint;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  //  [self displayHint];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void) displayHint
{
    if( ![DemoHintView shouldShowHint:kHintID_Home] )
    {
        return;
    }
    
    __unsafe_unretained DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    //hintView.title = @"Welcome to the Demo!";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"Page 1" text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
    
    [hintView addPageWithTitle:@"Page 2" text:@"This is some demo text. Swipe this message to see the next hint!"];
    [hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    [hintView addPageWithTitle:@"Page 4" text:@"Text B"];
    [hintView addPageWithTitle:@"Page 5" text:@"Text C"];
    
    [hintView showInView:self.view orientation:kHintViewOrientationBottom];
}


-(IBAction) hint1
{
    __unsafe_unretained DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    //hintView.title = @"Welcome to the Demo!";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"Page 1" text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
    
    [hintView addPageWithTitle:@"Page 2" text:@"This is some demo text. Swipe this message to see the next hint!"];
    [hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    [hintView addPageWithTitle:@"Page 4" text:@"Text B"];
    [hintView addPageWithTitle:@"Page 5" text:@"Text C"];
    
    [hintView showInView:self.view orientation:kHintViewOrientationBottom];
}


-(IBAction) hint2
{
    DemoHintView* hintView = [DemoHintView  infoHintView];
    
    // Overwrites the pages titles
    //hintView.title = @"Welcome to the Demo!";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithTitle:@"Page 1" image:[UIImage imageNamed:@"touchbee_small.png"]];
    
    [hintView showInView:self.view orientation:kHintViewOrientationTop presentation:kHintViewPresentationSlide];
}


-(IBAction) hint3
{
    __unsafe_unretained DemoHintView* hintView = [DemoHintView  warningHintView];
    
    // Overwrites the pages titles
    hintView.title = @"Welcome to the Demo!";
    
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithtitle:@"Page 1" text:@"We'll show you these little helpers throughout the app. However, you can certainly turn them off if you like." buttonText:@"Turn off hints" buttonAction:^{
        
        [DemoHintView enableHints:NO];
        
        [hintView dismiss];
    }];
    
    [hintView addPageWithTitle:@"Page 2" text:@"This is some demo text. Swipe this message to see the next hint!"];
    [hintView addPageWithTitle:@"Page 3" image:[UIImage imageNamed:@"touchbee_small.png"]];
    [hintView addPageWithTitle:@"Page 4" text:@"Text B"];
    [hintView addPageWithTitle:@"Page 5" text:@"Text C"];
    
    [hintView showInView:self.view orientation:kHintViewOrientationBottom presentation:kHintViewPresentationBounce];
}


-(IBAction) hint4
{
    DemoHintView* hintView = [DemoHintView  warningHintView];
    
    // Overwrites the pages titles
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithTitle:@"Single Page" text:@"Some more text..."];
    
    [hintView showInView:self.view orientation:kHintViewOrientationBottom presentation:kHintViewPresentationDrop];
}


-(IBAction) hint5
{
    DemoHintView* hintView = [DemoHintView  otherHintView];
    
    // Overwrites the pages titles
    hintView.hintID = kHintID_Home;
    
    [hintView addPageWithTitle:@"Single Page" text:@"Some more text..."];
    
    [hintView showInView:self.view orientation:kHintViewOrientationTop duration:3.0];

}

@end
