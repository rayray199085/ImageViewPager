//
//  ViewController.m
//  ImageViewPager
//
//  Created by Stephen Cao on 7/2/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *mArray;
@property(weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic, strong) NSTimer *timer;
- (void)addImageView2ScrollView;
- (void)setNextPageWithPageIndex:(int)index;
- (NSTimer *)createATimerForScrollingImages;
@end

@implementation ViewController
- (NSMutableArray *)mArray {
  if (_mArray == nil) {
    _mArray = [NSMutableArray arrayWithCapacity:5];
    [_mArray addObject:@"ms_319rinka001.jpg"];
    [_mArray addObject:@"ms_671maya011.jpg"];
    [_mArray addObject:@"ms_kazuha017.jpg"];
    [_mArray addObject:@"pg_haruko002.jpg"];
    [_mArray addObject:@"pg_saeri002.jpg"];
  }
  return _mArray;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self addImageView2ScrollView];
  self.scrollView.contentSize =
      CGSizeMake(self.scrollView.frame.size.width * self.mArray.count, 0);
  self.scrollView.pagingEnabled = YES;
  self.scrollView.showsHorizontalScrollIndicator = NO;

  self.pageControl.numberOfPages = self.mArray.count;
  self.pageControl.currentPage = 0;
  [self.view bringSubviewToFront:self.pageControl];

  self.scrollView.delegate = self;
  self.timer = [self createATimerForScrollingImages];
  self.textView.contentSize = CGSizeMake(0, 551);
}

- (void)addImageView2ScrollView {
  for (int i = 0; i < 5; i++) {
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(i * self.scrollView.frame.size.width, 0,
                           self.scrollView.frame.size.width,
                           self.scrollView.frame.size.height);
    img.image = [UIImage imageNamed:self.mArray[i]];
    [self.scrollView addSubview:img];
  }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (_timer != nil) {
    [_timer invalidate];
  }
  self.timer = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int imageWidth = (int)self.scrollView.frame.size.width;
  self.pageControl.currentPage =
      (int)round(scrollView.contentOffset.x / imageWidth);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (_timer == nil) {
    _timer = [self createATimerForScrollingImages];
  }
}
- (void)setNextPageWithPageIndex:(int)index {
  [self.scrollView
      setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0)
              animated:YES];
}
- (NSTimer *)createATimerForScrollingImages {
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:1
                             repeats:YES
                               block:^(NSTimer *_Nonnull timer) {
                                 int currentIndex =
                                     (int)self.pageControl.currentPage;
                                 if (currentIndex++ < self.mArray.count - 1) {
                                   self.pageControl.currentPage = currentIndex;
                                 } else {
                                   currentIndex = 0;
                                   self.pageControl.currentPage = currentIndex;
                                 }
                                 [self setNextPageWithPageIndex:currentIndex];
                               }];
  //    Update the level of the thread of timer to be the same as the UI thread
  NSRunLoop *runloop = [NSRunLoop currentRunLoop];
  [runloop addTimer:timer forMode:NSRunLoopCommonModes];
  return timer;
}
@end
