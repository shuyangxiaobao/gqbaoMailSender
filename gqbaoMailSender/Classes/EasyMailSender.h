//
//  EasyMailSender.h
//  Expecta
//
//  Created by 戈强宝 on 2017/2/28.
//

#import <Foundation/Foundation.h>

@class MFMailComposeViewController;


@interface EasyMailSender : NSObject <MFMailComposeViewControllerDelegate>
typedef void(^EasyMailBuilder)(MFMailComposeViewController *controller);

typedef void(^EasyMailComplete)(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error);

+ (instancetype)easyMail:(EasyMailBuilder) builder complete:(EasyMailComplete) complete;

- (void)showFromViewController:(UIViewController *) viewController;
- (void)showFromViewController:(UIViewController *) viewController competion:(void(^)(void))completion;

@end
