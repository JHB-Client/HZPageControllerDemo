//
//  ViewController.m
//  HZPageViewControllerDemo
//
//  Created by 季怀斌 on 2018/6/28.
//  Copyright © 2018年 huazhuo. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#define kScreenW UIScreen.mainScreen.bounds.size.width
@implementation UIColor (Extensions)


+ (instancetype)randomColor {
    
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    return [self colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIView *indexLine;
@property (nonatomic, weak) UIButton *lastBtn;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSMutableArray *btnArr;
@property (nonatomic, weak) UIView *indexLineBgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.title
    [self setUpTitleBgView];

    //2.content
    [self setUpContentView];
}


- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (void)setUpTitleBgView {
    UIScrollView *titleScrollView = [UIScrollView new];
    titleScrollView.contentSize = CGSizeMake(1000, 50);
    titleScrollView.backgroundColor = [UIColor lightGrayColor];
//    titleScrollView.pagingEnabled = true;
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(50);
        make.left.right.mas_offset(0);
    }];
    
    UIView *titleBgView = [UIView new];
    //    titleBgView.backgroundColor = [UIColor whiteColor];
    [self.titleScrollView addSubview:titleBgView];
    
    //
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.titleScrollView).multipliedBy(0.95);
        make.width.mas_equalTo(self.titleScrollView.contentSize.width);
    }];
    
    
    self.titleArr = @[@"新闻", @"体育场", @"今日头条", @"互联网科技", @"图片", @"视频", @"医疗咨询", @"个性推荐", @"房产", @"淘宝"];
    
    UIButton *preBtn = nil;
    float a = 1.0 / 10;
    for (NSInteger i = 0; i < 10; i++) {
        UIButton *btn = [UIButton new];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBgView addSubview:btn];
        
        //
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.width.mas_equalTo(titleBgView.mas_width).multipliedBy(a);
            //            make.width.mas_equalTo(100);
            if (preBtn) {
                make.left.mas_equalTo(preBtn.mas_right);
            } else {
                make.left.mas_equalTo(0);
            }
        }];
        
        preBtn = btn;
        
        [self.btnArr addObject:btn];
    }
    
    UIView *indexLineBgView = [UIView new];
    //    indexLineBgView.backgroundColor = [UIColor whiteColor];
    [self.titleScrollView addSubview:indexLineBgView];
    self.indexLineBgView = indexLineBgView;
    //
    [self.indexLineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(titleBgView.mas_bottom);
        make.height.mas_equalTo(self.titleScrollView).multipliedBy(0.05);
        make.width.mas_equalTo(self.titleScrollView.contentSize.width);
    }];
    
    
    UIView *indexLine = [UIView new];
    indexLine.backgroundColor = [UIColor redColor];
    [self.indexLineBgView addSubview:indexLine];
    self.indexLine = indexLine;
    
    self.lastBtn = [self.btnArr objectAtIndex:0];
    [self btnClick:self.lastBtn];
}


- (void)setUpContentView {
    UIScrollView *contentScrollView = [UIScrollView new];
    contentScrollView.contentSize = CGSizeMake(10 * 375, 500);
    contentScrollView.backgroundColor = [UIColor greenColor];
    contentScrollView.pagingEnabled = true;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleScrollView.mas_bottom);
        make.height.mas_equalTo(500);
        make.left.right.mas_offset(0);
    }];
    
    //
    UIView *preView = nil;
    for (NSString *titleStr in self.titleArr) {
        UIViewController *VCtr = [UIViewController new];
        VCtr.title = titleStr;
        VCtr.view.backgroundColor = [UIColor randomColor];
        [self.contentScrollView addSubview:VCtr.view];
        [self addChildViewController:VCtr];
        
        //
        [VCtr.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(self.contentScrollView);
            if (preView) {
                make.left.mas_equalTo(preView.mas_right);
            } else {
                make.left.mas_equalTo(0);
            }
        }];
        
        preView = VCtr.view;
    }

}

- (void)btnClick:(UIButton *)btn {
    
    NSInteger index = [self.btnArr indexOfObject:btn];
    CGFloat offSetX = index * 100 - (self.titleScrollView.bounds.size.width * 0.5 - 50);
    CGFloat offSetMax = self.titleScrollView.contentSize.width - self.titleScrollView.bounds.size.width;
    CGFloat offSetMin = 0;
    if (offSetX >= offSetMax) {
        [self.titleScrollView setContentOffset:CGPointMake(offSetMax, 0) animated:true];
    } else if (offSetX <= offSetMin) {
        [self.titleScrollView setContentOffset:CGPointMake(offSetMin, 0) animated:true];
    } else {
        [self.titleScrollView setContentOffset:CGPointMake(offSetX, 0) animated:true];
    }
    
    
    //
    CGFloat indexLineWidth = btn.titleLabel.bounds.size.width;
    CGFloat indexLeft = index * 100 + (100 * 0.5 - indexLineWidth * 0.5);
    [self.indexLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.indexLineBgView);
        make.left.mas_equalTo(indexLeft);
        make.width.mas_equalTo(indexLineWidth);
    }];
    
    //
    if (self.lastBtn != btn) {
        self.lastBtn.selected = false;
        btn.selected = true;
        self.lastBtn = btn;
    } else {
        self.lastBtn.selected = true;
        btn.selected = true;
    }
    
//    [self.contentScrollView setContentOffset:CGPointMake(index * 375, 0) animated:true];
}


#pragma mark ----------------- UIScrollViewDelegate ------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger titleIndex = scrollView.contentOffset.x / 375;
    CGFloat titleProgress = scrollView.contentOffset.x / 375.0;
    NSLog(@"-----ssss----%lf", titleProgress);
    
    //
    [self btnClick:[self.btnArr objectAtIndex:titleIndex]];
    
    //
    
}

@end
