//
//  ViewController.m
//  HTPopDateViewDemo
//
//  Created by Horae.tech on 16/1/28.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HTPopDateView *selectDateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.selectDateView.backgroundColor = COLOR_GRAY_MEMO_BK;
    self.selectDateView.layer.masksToBounds = YES;
    self.selectDateView.layer.cornerRadius = 5.0f;
    self.selectDateView.backgroudView = self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
