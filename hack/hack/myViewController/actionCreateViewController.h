//
//  actionCreateViewController.h
//  hack
//
//  Created by 靳晓童 on 13-7-20.
//  Copyright (c) 2013年 ZhaoyangSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IHAction;
@interface actionCreateViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}

@property (nonatomic,retain) IBOutlet UIButton *imageBtn;

- (id)initWithAction:(IHAction *)action;

@end
