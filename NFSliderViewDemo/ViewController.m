//
//  ViewController.m
//  NFSliderViewDemo
//
//  Created by ChenJidong on 15/12/17.
//  Copyright © 2015年 nirvawolf. All rights reserved.
//

#import "ViewController.h"
#import "JDSlider.h"

@interface ViewController ()<JDSliderDatasource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JDSlider *slider = [[JDSlider alloc] initWithFrame:self.view.bounds];
    slider.datasource = self;
    
    
    //控制是否需要循环播放
    slider.playInCircle = YES;
    
    [self.view addSubview:slider];
    
    [slider reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JDSliderCell *)jd_cellForSlider:(JDSlider *)slider atIndex:(NSUInteger)idx
{
    JDSliderCell *cell = [slider dequeReuableCell];
    
    if (!cell) {
        cell = [[JDSliderCell alloc] initWithSlider:slider];
    }
    
    //在这里设置图片
    cell.imageView.image = nil;
    cell.titleLabel.text = [@(idx) stringValue];
    if (idx % 2 == 0) {
        cell.imageView.backgroundColor = [UIColor greenColor];
    }else{
        cell.imageView.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

- (NSUInteger)jd_numberOfCells
{
    return 6;
}

@end
