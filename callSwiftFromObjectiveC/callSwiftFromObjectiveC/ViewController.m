//
//  ViewController.m
//  callSwiftFromObjectiveC
//
//  Created by 🦁️ on 15/12/23.
//  Copyright © 2015年 exialym. All rights reserved.
//

#import "ViewController.h"
#import "callSwiftFromObjectiveC-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SwiftClass *swift = [[SwiftClass alloc] init];
    [swift sayHello];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
