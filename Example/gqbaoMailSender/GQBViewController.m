//
//  GQBViewController.m
//  gqbaoMailSender
//
//  Created by shuyangxiaobao on 02/28/2018.
//  Copyright (c) 2018 shuyangxiaobao. All rights reserved.
//

#import "GQBViewController.h"
#import <MessageUI/MessageUI.h>
#import "EasyMailSender.h"
#import "EasyMailAlertSender.h"


@interface GQBViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation GQBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *iOSDevTip = [UIButton buttonWithType:UIButtonTypeCustom];
    iOSDevTip.frame = CGRectMake(20, 80, 100, 50);
    [iOSDevTip setBackgroundColor:[UIColor orangeColor]];
    [iOSDevTip setTitle:@"send msg" forState:UIControlStateNormal];
    [iOSDevTip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:iOSDevTip];
    [iOSDevTip addTarget:self action:@selector(actioniOSDevTipClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)actioniOSDevTipClick:(id)sender
{
    //方法一
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://13888888888"]];
    
    //    [self showMessageView:[NSArray arrayWithObjects:@"13888888888",@"13999999999", nil] title:@"test" body:@"你是土豪么，么么哒"];
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"选择功能" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"发短信" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self showMessageView:[NSArray arrayWithObjects:@"13888888888",@"13999999999", nil] title:@"test" body:@"你是土豪么，么么哒"];
    }];
    [vc addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"发邮件" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        
        if( [MFMailComposeViewController canSendMail] )
        {
            //            MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
            //            [controller setToRecipients:@[@"825065886@qq.com",@"1379343323@qq.com"]];
            //            [controller setMessageBody:@"message body" isHTML:YES];
            //            controller.mailComposeDelegate = self;
            //            [self presentViewController:controller animated:YES completion:nil];
            
            
            
            NSString *attachedText = @"text2132";
            EasyMailAlertSender *mailSender = [EasyMailAlertSender easyMail:^(MFMailComposeViewController *controller) {
                // Setup
                
                //设置收件人
                [controller setToRecipients:@[@"0000000@qq.com",@"111111111@qq.com"]];
                
                //设置主题
                [controller setSubject:@"我的主题"];
                
                //设置抄送人
                [controller setCcRecipients:@[@"22222222@qq.com",@"333333@qq.com"]];
                
                //设置密送人
                [controller setBccRecipients:@[@"44444444@qq.com",@"555555@qq.com"]];
                
                //设置邮件内容
                [controller setMessageBody:@"message body" isHTML:YES];
                
                //                [controller setPreferredSendingEmailAddress:@"1379343323@qq.com"];
                
                [controller addAttachmentData:[attachedText dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"plain/text" fileName:@"test.doc"];
            } complete:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
                // When Sent/Cancel - MFMailComposeViewControllerDelegate action
                [controller dismissViewControllerAnimated:YES completion:nil];
            }];
            [mailSender showFromViewController:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"该设备不支持邮件功能"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    [vc addAction:action2];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [vc addAction:cancel];
    
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    
    
}






#pragma mark 发短信
/**
 发短信
 */
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - MFMessageComposeViewController

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
            case MessageComposeResultSent:
            //信息传送成功
            NSLog(@"信息传送成功");
            break;
            case MessageComposeResultFailed:
            //信息传送失败
            NSLog(@"信息传送失败");
            break;
            case MessageComposeResultCancelled:
            //信息被用户取消传送
            NSLog(@"信息被用户取消传送");
            break;
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    NSLog(@"%ld",result);
    NSLog(@"%@",error);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

