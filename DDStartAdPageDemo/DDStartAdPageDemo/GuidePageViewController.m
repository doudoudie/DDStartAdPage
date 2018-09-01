//
//  GuidePageViewController.m
//  DCStartPageAdDemo
//
//  Created by 黄登登 on 2018/8/28.
//  Copyright © 2018年 黄登登. All rights reserved.
//

#import "GuidePageViewController.h"

@interface GuidePageViewController ()
- (IBAction)startAction:(id)sender;
@end

@implementation GuidePageViewController

+ (instancetype)instanceFromXib {
    id instance = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)startAction:(id)sender {
    
    if(self.StartAppBlock){
        self.StartAppBlock(@{});
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
