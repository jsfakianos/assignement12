//
//  ViewController.m
//  eecs397_ios_demo
//
//  Created by Nick Barendt on 3/7/17.
//  Copyright © 2017 Nick Barendt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"slider: %@ \n label: %@", self.slider, self.label);
}


-(IBAction)onSliderChanged:(UISlider*)sender {
    self.label.text = [NSString stringWithFormat:@"%f", self.slider.value];
}


@end
