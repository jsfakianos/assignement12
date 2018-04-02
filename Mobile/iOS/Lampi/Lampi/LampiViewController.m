#import "LampiViewController.h"
#import "GradientSlider.h"
#import "BluetoothLampService.h"
#import <KeenClient/KeenClient.h>

@interface LampiViewController()

@property (nonatomic, weak) IBOutlet GradientSlider *hueSlider;
@property (nonatomic, weak) IBOutlet GradientSlider *saturationSlider;
@property (nonatomic, weak) IBOutlet GradientSlider *brightnessSlider;
@property (nonatomic, weak) IBOutlet UIView *topColorBox;
@property (nonatomic, weak) IBOutlet UIView *bottomColorBox;
@property (nonatomic, weak) IBOutlet UIButton *powerButton;

@property (nonatomic, strong) BluetoothLampService *lampService;

@property (nonatomic) BOOL propertiesChanged;

@property (nonatomic, weak) KeenClient *keen_client;
@property (nonatomic, weak) NSString *serialNumber;

@end

@implementation LampiViewController

NSString *const KEEN_PROJECT_ID = @"FILL IN";
NSString *const KEEN_WRITE_KEY = @"FILL IN";

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.propertiesChanged = NO;
        self.keen_client = nil;
        self.lampService = [[BluetoothLampService alloc] initWithDelegate:self];
    }
    return self;
}

-(void)viewDidLoad {
    [self updateColors];
    self.view.userInteractionEnabled = NO;
    self.view.alpha = 0.5;
    [self.lampService startScan];
}

-(IBAction)onHueChanged:(id)sender {
    [self updateColors];
    [self beginSendPropertiesToLamp];
    if(self.keen_client != nil){
        NSDictionary *event = @{@"element":
                                    @{
                                        @"id": @"hue-slider",
                                        @"value": [NSNumber numberWithDouble: self.hueSlider.value ],
                                        }
                                };
        
        [self.keen_client addEvent:event toEventCollection:@"ui" error:nil];
    }
}

-(IBAction)onSaturationChanged:(id)sender {
    [self updateColors];
    [self beginSendPropertiesToLamp];
    if(self.keen_client != nil){
        NSDictionary *event = @{@"element":
                                    @{
                                        @"id": @"saturation-slider",
                                        @"value": [NSNumber numberWithDouble: self.saturationSlider.value ],
                                        }
                                };
        
        [self.keen_client addEvent:event toEventCollection:@"ui" error:nil];
    }
}

-(IBAction)onBrightnessChanged:(id)sender {
    [self updateColors];
    [self beginSendPropertiesToLamp];
    if(self.keen_client != nil){
        NSDictionary *event = @{@"element":
                                    @{
                                        @"id": @"brightness-slider",
                                        @"value": [NSNumber numberWithDouble: self.brightnessSlider.value ],
                                        }
                                };
        
        [self.keen_client addEvent:event toEventCollection:@"ui" error:nil];
    }
}

-(IBAction)isOnOffToggled:(id)sender {
    self.powerButton.selected = !self.powerButton.selected;
    [self.lampService changeOnOff:self.powerButton.selected];
    [self updateColors];
    if(self.keen_client != nil){
        NSDictionary *event = @{@"element":
                                    @{
                                        @"id": @"power",
                                        @"value": [NSNumber numberWithBool: self.powerButton.selected ],
                                        }
                                };
        
        [self.keen_client addEvent:event toEventCollection:@"ui" error:nil];
    }
}

-(void)beginSendPropertiesToLamp {
    if(!self.propertiesChanged) {
        self.propertiesChanged = YES;
        __weak typeof(self) weakRef = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakRef.propertiesChanged = NO;
            [weakRef.lampService changeHue:weakRef.hueSlider.value andSaturation:weakRef.saturationSlider.value];
            [weakRef.lampService changeBrightness:weakRef.brightnessSlider.value];
        });
    }
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
    
    if(self.powerButton.selected) {
        self.powerButton.tintColor = newColor;
    } else {
        self.powerButton.tintColor = [UIColor grayColor];
    }
    
}

-(void)onLampConnected {
    NSLog(@"connected");
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1.0;
}

-(void)onLampDisconnected {
    NSLog(@"disconnected");
    self.view.userInteractionEnabled = NO;
    self.view.alpha = 0.5;
}

-(void)onError:(NSString*)error {
    NSLog(@"%@", error);
}

-(void)onLoading:(NSString*)loading {
    NSLog(@"%@", loading);
}

-(void)onUpdatedHue:(float)hue andSaturation:(float)saturation {
    self.hueSlider.value = hue;
    self.saturationSlider.value = saturation;
    [self updateColors];
}

-(void)onUpdatedBrightness:(float)brightness {
    self.brightnessSlider.value = brightness;
    [self updateColors];
}

-(void)onUpdatedOnOff:(BOOL)onOff {
    self.powerButton.selected = onOff;
    [self updateColors];
}

-(void)onUpdatedSerialNumber:(NSString*)serialNumber{
    self.serialNumber = serialNumber;
    // configure analytics now that we have our device's ID
    [KeenClient sharedClientWithProjectID:KEEN_PROJECT_ID andWriteKey:KEEN_WRITE_KEY andReadKey:nil];
    self.keen_client = [KeenClient sharedClient];
    self.keen_client.globalPropertiesDictionary = @{@"keen":
                                                        @{
                                                            @"addons":@[
                                                                    @{
                                                                        @"name":@"keen:ip_to_geo",
                                                                        @"input":@{
                                                                                @"ip":@"ip_address"
                                                                                },
                                                                        @"output":@"geo"
                                                                        }
                                                                    ]
                                                            },
                                                    @"ip_address": @"${keen.ip}",
                                                    @"lampi":
                                                        @{
                                                            @"device_id": self.serialNumber,
                                                            @"ui": @"ios",
                                                            }
                                                    };
}



@end
