//
//  ViewController.h
//  eecs397_ios_demo
//
//  Created by Nick Barendt on 3/7/17.
//  Copyright © 2017 Nick Barendt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *label;

-(IBAction)onSliderChanged:(UISlider*)sender;

@end

