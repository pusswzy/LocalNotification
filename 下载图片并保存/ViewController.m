//
//  ViewController.m
//  下载图片并保存
//
//  Created by 李昊泽 on 16/9/21.
//  Copyright © 2016年 李昊泽. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;

@end

@implementation ViewController
static     NSString * JayImageURL = @"https://img1.doubanio.com/img/musician/large/22817.jpg";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //URL -> image
    NSURL *imageUrl = [NSURL URLWithString:JayImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    self.centerImage.contentMode = UIViewContentModeScaleAspectFit;
    
    //存入沙盘
    NSString *documentStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imagePath = [documentStr stringByAppendingPathComponent:@"image.png"];
    [imageData writeToFile:imagePath atomically:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //读取图片
    NSString *documentStr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *imagePath = [documentStr stringByAppendingPathComponent:@"image.png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@", imagePath]];
    //前面不需要拼file
    self.centerImage.image = image;
    
}


@end
