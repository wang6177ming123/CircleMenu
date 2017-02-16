//
//  ViewController.m
//  CircleMenu
//
//  Created by pactera on 17/2/16.
//  Copyright © 2017年 pactera. All rights reserved.
//
#define DIST(pointA,pointB) sqrtf((pointA.x-pointB.x)*(pointA.x-pointB.x)+(pointA.y-pointB.y)*(pointA.y-pointB.y))
#define MENURADIUS 0.5 * W
#define PROPORTION 0.45          //中心圆直径与菜单变长的比例

#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) NSMutableArray <UIView *> *viewArray;
@property (nonatomic, strong) UIImageView *circleView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSArray <NSString *> *imageTitleArray;


@end

CGPoint beginPoint;
CGPoint orgin;
CGFloat a;
CGFloat b;
CGFloat c;
@implementation ViewController
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, H- 100, W -40, 60)];
        _infoLabel.backgroundColor = [UIColor blueColor];
        _infoLabel.textColor  = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.infoLabel];
    NSArray <NSString *> *imageNameArray = @[ @"shareqq_zone",@"photo_delete",
                                              @"share_qq",@"share_sina",@"share_wxZone",@"shareqq_zone",
                                              @"share_qq",@"share_sina",];
    _imageTitleArray = @[@"呵呵",@"嘿嘿",@"哈哈",@"＝。＝",@"111",@"333",@"GoodGame",@"TSMTSM"];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImage.image = [UIImage imageNamed:@"main"];
    
    [self.view addSubview:bgImage];
    _content = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.17 * H, W, W)];
    _content.backgroundColor = [UIColor orangeColor];
    UIImage *cir = [UIImage imageNamed:@"circle"];
    _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5 * (1 - PROPORTION) * CGRectGetWidth(_content.frame) + 10, 0.5 * (1 - PROPORTION) * CGRectGetWidth(_content.frame) + 10, CGRectGetWidth(_content.frame) * PROPORTION - 20, CGRectGetWidth(_content.frame) * PROPORTION - 20)];
    _circleView.image = cir;
    [_content addSubview:_circleView];
    [self.view addSubview:_content];
    [self rotationCircleCenter:CGPointMake(MENURADIUS, MENURADIUS) ContentRadius:MENURADIUS ImageNameArray:imageNameArray ImageTitleArray:_imageTitleArray];
}

- (void)rotationCircleCenter:(CGPoint)contentOrgin ContentRadius:(CGFloat)contentRadius ImageNameArray:(NSArray <NSString *>*)imageNameArray ImageTitleArray:(NSArray <NSString *>*)imageTitleArray{
    _viewArray = [NSMutableArray array];
    for (int i = 0; i < imageNameArray.count; i++) {
        CGFloat x = contentRadius*sin(M_PI*2/imageNameArray.count*i);
        CGFloat y = contentRadius*cos(M_PI*2/imageNameArray.count*i);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(contentRadius + 0.5 * (1 + PROPORTION) * x - 0.5 * (1 - PROPORTION) * contentRadius, contentRadius - 0.5 * (1 + PROPORTION) * y - 0.5 * (1 - PROPORTION) * contentRadius, (1 - PROPORTION) * contentRadius, (1 - PROPORTION) * contentRadius)];
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(view.frame) - 20, CGRectGetWidth(view.frame) - 20)];
        //        imageView setImage = [UIImage imageNamed:imageNameArray[i]];
        [imageView setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        imageView.tag = 100 + i;
        [imageView addTarget:self action:@selector(UIbuttion:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetWidth(view.frame) - 20, CGRectGetWidth(view.frame), 20)];
        imageTitle.text = imageTitleArray[i];
        imageTitle.textAlignment = NSTextAlignmentCenter;
        imageTitle.font = [UIFont systemFontOfSize:13];
        [view addSubview:imageView];
        [view addSubview:imageTitle];
        view.userInteractionEnabled = YES;
        _content.userInteractionEnabled = YES;
        [_content addSubview:view];
        [_viewArray addObject:view];
    }
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point {
    CGFloat dist = DIST(point, center);
    
    return (dist <= radius);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //    NSLog(@"123456");
    beginPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    orgin = CGPointMake(0.5 * W, MENURADIUS + 0.17 * H);
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    if ([self touchPointInsideCircle:orgin radius:MENURADIUS targetPoint:currentPoint]) {
        b = DIST(beginPoint, orgin);
        c = DIST(currentPoint, orgin);
        a = DIST(beginPoint, currentPoint);
        CGFloat angleBegin = atan2(beginPoint.y-orgin.y, beginPoint.x-orgin.x);
        CGFloat angleAfter = atan2(currentPoint.y-orgin.y, currentPoint.x-orgin.x);
        CGFloat angle = angleAfter-angleBegin;
        _content.transform = CGAffineTransformRotate(_content.transform, angle);
        _circleView.transform = CGAffineTransformRotate(_circleView.transform, -angle);
        for (int i = 0; i < _viewArray.count; i++) {
            _viewArray[i].transform = CGAffineTransformRotate(_viewArray[i].transform, -angle);
        }
        beginPoint = currentPoint;
    }
}

- (void)UIbuttion:(UIButton *)sender{
    
    if (sender.tag == 101) {
        NSLog(@"11111");
    }else if (sender.tag == 102){
        NSLog(@"22222");
        
    }else{
        NSLog(@"123444");
    }
    _infoLabel.text = [NSString stringWithFormat:@"%@",_imageTitleArray[sender.tag-100]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
