//
//  ViewController.m
//  HBK_Record
//
//  Created by 黄冰珂 on 2018/7/10.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "ViewController.h"
#import "HBK_ RecordManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)start:(id)sender {
    [[HBK__RecordManager shareManager] startRecord];
    
}
- (IBAction)stop:(id)sender {
    [[HBK__RecordManager shareManager] stopRecord];
    
}
- (IBAction)play:(id)sender {
    [[HBK__RecordManager shareManager] playRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
