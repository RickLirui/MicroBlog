//
//  SendViewController.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "SendViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "NetworkManager.h"


#import "AFNetworking.h"


@interface SendViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,NetWorkManagerDelegate, UITextViewDelegate>


@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)UIActionSheet *myActionSheet;

@property (nonatomic, strong)UIImageView *picture;
@property (nonatomic, strong)UIButton *insertPicButton;
@property (nonatomic, strong)UIButton *deletePicButton;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, assign)BOOL hasPicture;

@end

@implementation SendViewController



- (void) loadView
{
    [super loadView];

    [self creatNavi];

    self.view.backgroundColor =[UIColor whiteColor];

    
    self.insertPicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.insertPicButton setTitle:NSLocalizedString(@"Insert", nil) forState:UIControlStateNormal];
    [self.insertPicButton.layer setCornerRadius:10];
    self.insertPicButton.backgroundColor = [UIColor cyanColor];
    self.insertPicButton.frame = CGRectMake(265, 294, 100, 30);
    [self.view addSubview:self.insertPicButton];
    
    
    self.deletePicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.deletePicButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [self.deletePicButton.layer setCornerRadius:10];
    self.deletePicButton.frame = CGRectMake(265, 374, 100, 30);
    self.deletePicButton.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.deletePicButton];
    
    self.picture = [[UIImageView alloc] init];
    self.picture.backgroundColor = [UIColor cyanColor];
    self.picture.frame = CGRectMake(10, 294, 120, 120);
    [self.view addSubview:self.picture];
    
    self.hasPicture = NO;
    

    self.textView = [[UITextView alloc] init];//初始化
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;//边框颜色
    self.textView.backgroundColor= [UIColor cyanColor];//背景颜色
    [self.textView.layer setCornerRadius:10];//圆角
    self.textView.layer.borderWidth = 1.f;//边框宽度
    self.textView.font = [UIFont fontWithName:@"Arial"size:18.0];//框内字体与颜色
    [self.textView becomeFirstResponder];//是其为第一目标
    self.textView.returnKeyType = UIReturnKeyGoogle;//设置键盘return键的默认值
    self.textView.keyboardType = UIKeyboardTypeDefault;//设置默认键盘
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//
    self.textView.frame = CGRectMake(10, 74, 355, 154);
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.insertPicButton addTarget:self action:@selector(clickInsert) forControlEvents:UIControlEventTouchDown];
    [self.deletePicButton addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchDown];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //TODO
    //显示字数变化——140
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) clickDelete
{
    [self.picture setImage:nil];
    self.hasPicture = NO;

}

- (void) clickInsert
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        self.myActionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    else
         self.myActionSheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"取消", nil];

    [self.myActionSheet showInView:self.view];
}




- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSRange range;
    range.location = 0;
    range.length = 0;
    self.textView.selectedRange = range;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self LocalPhoto];
            break;
        case 1:
            break;
    }
}
- (void) takePhoto
{
    
}

-(void)LocalPhoto
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    self.hasPicture = YES;
    [self.picture setImage:savedImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}


- (void)clickRightButton
{
    self.text = self.textView.text;
    if (self.hasPicture)
        [[NetworkManager sharedManager] postWeiboPic:self.text image:self.picture.image delegate:self];
    else
        [[NetworkManager sharedManager] postWeiboText:self.text delegate:self];
}

- (void) creatNavi
{
    self.title = @"New Weibo";
    
    UIView *leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *leftButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButtonImageView.image = [UIImage imageNamed:@"back.png"];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButtonImageView];
    [leftButtonView addSubview:leftButton];
    //创建home按钮
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    
    
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *rightButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButtonImageView.image = [UIImage imageNamed:@"send.png"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightButtonImageView];
    [rightButtonView addSubview:rightButton];
    //创建home按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
}


- (void)receivedResponseSuccess:(NSDictionary *) dic type:(SendRequestType) type
{
    switch (type)
    {
        case ESendRequestTypeSendPic:
        {
            self.textView.text = @"";
            NSString *message = [[NSString alloc]initWithFormat:@"Picture Send Success!"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        case ESendRequestTypeSendText:
        {
            NSString *message = [[NSString alloc]initWithFormat:@"Text Send Success!"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)receivedResponseFailed:(NSError *)error
{
    NSLog(@"%@",error);
}



@end
