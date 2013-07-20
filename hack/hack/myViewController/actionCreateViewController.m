//
//  actionCreateViewController.m
//  hack
//
//  Created by 靳晓童 on 13-7-20.
//  Copyright (c) 2013年 ZhaoyangSu. All rights reserved.
//

#import "actionCreateViewController.h"
#import "IHAction.h"

typedef enum
{
    EEditSectionAdd,
    EEditSectionImage,
    EEditSectionVideo,
    EEditSectionDelete,
    EEditSectionCount,
}
EditSection;


@interface actionCreateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isFullScreen;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IHAction *oldAction;
@property (nonatomic, strong) IHAction *commitAction;
@end

@implementation actionCreateViewController
@synthesize imageBtn;


- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (id)initWithAction:(IHAction *)action
{
    if (self = [super init])
    {
        self.oldAction = action;
        self.commitAction = [action copy];
    }
    return self;
}

- (BOOL)isCareate
{
    if (self.oldAction.itemId == 0)
    {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.imageBtn addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    isFullScreen = NO;
    [self.imageBtn setImage:savedImage forState:UIControlStateNormal];
    
    self.imageBtn.tag = 100;
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isFullScreen = !isFullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint imagePoint = self.imageBtn.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageBtn.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageBtn.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (isFullScreen) {
            // 放大尺寸
            
            self.imageBtn.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.imageBtn.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
        
    }
    
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}


#pragma mark -
#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EEditSectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AddCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isCareate] && indexPath.row == EEditSectionAdd)
    {
        return 44.0;
    }
    else if([self isCareate] && indexPath.row == EEditSectionAdd)
    {
        return 0.0;
    }
}
@end
