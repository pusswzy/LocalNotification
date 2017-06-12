//
//  ViewController.m
//  本地推送下载的图片
//
//  Created by 李昊泽 on 16/9/20.
//  Copyright © 2016年 李昊泽. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()<UNUserNotificationCenterDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册推送通知
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"%d--%@", granted, error);
    }];;
}

- (IBAction)click:(id)sender {

    //1.初始化通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @1;
    content.title = @"通知的标题";
    content.body = @"推送下载图片";   //如果没有body则不会弹出通知
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    //推送本地图片
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"];
    //    NSURL *url = [NSURL fileURLWithPath:imagePath];
    //    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:url options:nil error:nil];
    //    content.attachments = @[attachment];
    
    //2.下载图片
    //2.1获取图片
    NSString * imageUrlString = @"https://img1.doubanio.com/img/musician/large/22817.jpg";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
    
    //2.2图片保存到沙盒
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *localPath = [documentPath stringByAppendingPathComponent:@"haha.jpg"];
    [imageData writeToFile:localPath atomically:YES];
    
    
//    //下载图片,放到本地
//    UIImage * imageFromUrl = [self getImageFromURL:attchUrl];
//    
//    //获取documents目录
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
//    NSString * documentsDirectoryPath = [paths objectAtIndex:0];
//    NSString * localPath = [self saveImage:imageFromUrl withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    //3.触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];

    //4.推送
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"pusswzy" content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
    //设置代理 iOS10
    center.delegate = self;
    
   
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    //dataWithContentsOfURL方法需要https连接
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    self.topImage.contentMode = UIViewContentModeScaleAspectFit;
    self.topImage.image = result;
    return result;
}

-(NSString *) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSString *urlStr = @"";
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
        [UIImagePNGRepresentation(image) writeToFile:urlStr options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] ||
               [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:urlStr options:NSAtomicWrite error:nil];
    } else
    {
        NSLog(@"extension error");
    }
    return urlStr;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    // 展示
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
    
    //    // 不展示
    //    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSLog(@"%@---%@", response, completionHandler);
}
@end
