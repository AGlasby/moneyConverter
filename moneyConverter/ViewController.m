//
//  ViewController.m
//  moneyConverter
//
//  Created by Alan Glasby on 24/08/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"

@interface ViewController () <CRCurrencyRequestDelegate>

@property (nonatomic) CRCurrencyRequest *req;
@property (nonatomic) BOOL exchangeRatesReceived;
@property (weak, nonatomic) IBOutlet UITextField *inputCurrencyAmountTxtFld;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outputCurrencySelectSegCntrl;
@property (weak, nonatomic) IBOutlet UILabel *outputCurrencyLbl;
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.exchangeRatesReceived = NO;
    self.outputCurrencyLbl.text = @"Output currency is UK Pound Sterling";
}

- (IBAction)touchConvertBtn:(id)sender {
    self.convertBtn.enabled = NO;
    [self updateCurrencyExchangeRates];
}

- (IBAction)outputCurrencySelectSegCntrl:(id)sender {

    switch ([sender selectedSegmentIndex]) {
        case 0:
            if(self.exchangeRatesReceived) {
                [self updateCurrencyExchangeRates];
            } else {
                self.outputCurrencyLbl.text = @"Output currency is UK Pound Sterling";
            }
            break;
        case 1:
            if(self.exchangeRatesReceived) {
                [self updateCurrencyExchangeRates];
            } else {
                self.outputCurrencyLbl.text = @"Output currency is Danish Kronor";
            }
            break;
        case 2:
            if(self.exchangeRatesReceived) {
                [self updateCurrencyExchangeRates];
            } else {
                self.outputCurrencyLbl.text = @"Output currency is Swedish Kronor";
            }
            break;

        default:
            break;
    }
}

- (IBAction)inputCurrencyAmountChanged:(id)sender {
    if (!self.convertBtn.enabled) {
        self.convertBtn.enabled = YES;
    }
}


- (void)currencyRequest:(CRCurrencyRequest *)req
    retrievedCurrencies:(CRCurrencyResults *)currencies {

    self.exchangeRatesReceived = YES;

    double inputValue = [self.inputCurrencyAmountTxtFld.text floatValue];
    double valueGBP = inputValue * currencies.GBP;
    double valueDKK = inputValue * currencies.DKK;
    double valueSEK = inputValue * currencies.SEK;
    NSString *outputCurrency;

    switch (self.outputCurrencySelectSegCntrl.selectedSegmentIndex) {
        case 0:
            outputCurrency = @"GBP";
            [self updateOutputLbl:valueGBP inCurrency:outputCurrency];
            break;
        case 1:
            outputCurrency = @"DKK";
            [self updateOutputLbl:valueDKK inCurrency:outputCurrency];
            break;
        case 2:
            outputCurrency = @"SEK";
            [self updateOutputLbl:valueSEK inCurrency:outputCurrency];
            break;

        default:
            break;
    }
}

- (void)updateOutputLbl:(double)outputAmmount inCurrency:(NSString *)currency {
        NSString *outputValue;
    outputValue = [NSString stringWithFormat:@"%.2f %@", outputAmmount, currency];
        self.outputCurrencyLbl.text = outputValue;
}

- (void)updateCurrencyExchangeRates {
    self.req = [[CRCurrencyRequest alloc] init];
    self.req.delegate = self;
    [self.req start];
}

@end









