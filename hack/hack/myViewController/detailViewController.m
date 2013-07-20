//
//  detailViewController.m
//  hack
//
//  Created by caoliang on 13-7-20.
//  Copyright (c) 2013年 ZhaoyangSu. All rights reserved.
//
#import "detailViewController.h"
#import "IHMovieImageBtn.h"

@interface detailViewController ()
@property(nonatomic,strong)IBOutlet UIScrollView *scrollView;

@end

@implementation detailViewController
@synthesize detailAction;

@synthesize actionName = _actionName;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize insertCount = _insertCount;

@synthesize photoesPage;
@synthesize audioesPage;
@synthesize videosPage;

@synthesize photoArr = _photoArr;
@synthesize audioArr = _audioArr;
@synthesize videoArr = _videoArr;
@synthesize scrollView = _scrollView;
 
#pragma mark - life circle
- (id)initWithAction:(IHAction *)aAction
{
    self = [super initWithNibName:@"detailViewController" bundle:nil];
    if (self) {
        self.detailAction = aAction;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年M月d日 H点m分"];
        
        _actionName.text = aAction.actionTip;
        _startTime.text = [formatter stringFromDate:aAction.startTime];
        _endTime.text = [formatter stringFromDate:aAction.endTime];
        _insertCount = [NSString stringWithFormat:@"%d",aAction.insterNum ];
        
        [videosPage setNumberOfPages:2];
        [videosPage setCurrentPage:0];
        [videosPage addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        _photoArr = aAction.photoes;
        _audioArr = aAction.audioes;
        _videoArr = aAction.videos;
       // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
<<<<<<< HEAD
    
=======
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
>>>>>>> 4529e3bb8a1a70f83ca6cd50cb7cf36953031499
}
- (void)layoutViews
{
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
