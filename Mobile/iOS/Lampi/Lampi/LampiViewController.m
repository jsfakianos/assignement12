#import "LampiViewController.h"
#import "GradientSlider.h"


@interface LampiViewController()

@property (nonatomic, weak) IBOutlet GradientSlider *hueSlider;
@property (nonatomic, weak) IBOutlet GradientSlider *saturationSlider;
@property (nonatomic, weak) IBOutlet GradientSlider *brightnessSlider;
@property (nonatomic, weak) IBOutlet UIView *topColorBox;
@property (nonatomic, weak) IBOutlet UIView *bottomColorBox;
@property (nonatomic, weak) IBOutlet UIButton *powerButton;


@end

@implementation LampiViewController

-(void)viewDidLoad {
    [self updateColors];
}

-(IBAction)onHueChanged:(id)sender {
    [self updateColors];
}

-(IBAction)onSaturationChanged:(id)sender {
    [self updateColors];
}

-(IBAction)onBrightnessChanged:(id)sender {
    [self updateColors];
}

-(void)updateColors {
    UIColor *hueColor = [UIColor colorWithHue:self.hueSlider.value saturation:1.0 brightness:1.0 alpha:1.0];
    UIColor *newColor = [UIColor colorWithHue:self.hueSlider.value saturation:self.saturationSlider.value brightness:1.0 alpha:1.0];
    UIColor *brightnessColor = [UIColor colorWithWhite:self.brightnessSlider.value alpha:1.0];
     
    self.hueSlider.thumbColor = hueColor;
    self.saturationSlider.maxColor = hueColor;
    self.topColorBox.backgroundColor = newColor;
    self.bottomColorBox.backgroundColor = newColor;
    self.saturationSlider.thumbColor = newColor;
    self.brightnessSlider.thumbColor = brightnessColor;
    
    self.powerButton.tintColor = newColor;
    
}

@end
