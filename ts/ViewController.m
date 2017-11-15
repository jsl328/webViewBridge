//
//  ViewController.m
//  ts
//
//  Created by JSL_ABC on 2017/10/12.
//  Copyright © 2017年 JSL_ABC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController
- (IBAction)btnOnclick:(id)sender {
    if ([sender isEqual:_btn]) {
        NSLog(@"----%@",_btn.titleLabel.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
