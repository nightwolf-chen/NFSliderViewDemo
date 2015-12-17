//
//  JDSlider.m
//  NFSliderViewDemo
//
//  Created by ChenJidong on 15/12/17.
//  Copyright © 2015年 nirvawolf. All rights reserved.
//


#import "JDSlider.h"

/**
 SliderCell的实现
 */
@implementation JDSliderCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = NO;
        _tapRecognizer = [[UITapGestureRecognizer alloc] init];
        _swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] init];
        _swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        _swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] init];
        _swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLabel.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addGestureRecognizer:_tapRecognizer];
        [self addGestureRecognizer:_swipeLeftRecognizer];
        [self addGestureRecognizer:_swipeRightRecognizer];
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (id)initWithSlider:(JDSlider *)slider
{
    return [self initWithFrame:slider.bounds];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end


/**
 Slider 实现
 */

@interface JDSlider ()
@property (nonatomic,strong) NSMutableArray *reuableCells;
@property (nonatomic,weak) JDSliderCell *showingCell;
@property (nonatomic,assign) CGRect showingFrame;
@property (nonatomic,assign) CGRect preFrame;
@property (nonatomic,assign) CGRect nextFrame;
@end

@implementation JDSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _showingFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _nextFrame = CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height);
        _preFrame = CGRectMake(-frame.size.width, 0, frame.size.width, frame.size.height);
        _reuableCells = [NSMutableArray array];
    }
    
    return self;
}

- (void)reloadData
{
    [self setIndex:0];
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    [self p_showCellAtIndex:index];
}


- (JDSliderCell *)dequeReuableCell
{
    if (_reuableCells.count <=0) {
        JDSliderCell *cell = [[JDSliderCell alloc] initWithSlider:self];
        [_reuableCells addObject:cell];
    }
    
    JDSliderCell *cell = _reuableCells.firstObject;
    [_reuableCells removeObject:cell];
    return cell;
}

- (void)p_showCellAtIndex:(NSUInteger)idx
{
    NSAssert(_datasource, @"Must have a datasour!");
    
    NSUInteger count = [_datasource jd_numberOfCells];
    
    NSAssert(idx < count, @"index out of bounds!");
    
    [_showingCell removeFromSuperview];
    
    JDSliderCell *showingcell = [self getCellAtIndex:idx];
    _showingCell = showingcell;
    
    [self addSubview:showingcell];
}

- (JDSliderCell *)getCellAtIndex:(NSUInteger)idx
{
    JDSliderCell *showingcell = [_datasource jd_cellForSlider:self atIndex:idx];
    [showingcell.tapRecognizer addTarget:self action:@selector(p_didTapCell:)];
    [showingcell.swipeLeftRecognizer addTarget:self action:@selector(p_didSliderCell:)];
    [showingcell.swipeRightRecognizer addTarget:self action:@selector(p_didSliderCell:)];
    
    return showingcell;
}

- (void)p_didTapCell:(UITapGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(jd_slider:didSelectCellAtIndex:)]) {
        [_delegate jd_slider:self didSelectCellAtIndex:_index];
    }
}

- (void)p_didSliderCell:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self p_showNext];
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self p_showPre];
    }
}

- (void)p_showNext
{
    int idx = -1;
    
    if (_playInCircle) {
        if (_index  + 1 >= [_datasource jd_numberOfCells]) {
            idx = 0;
        }else{
            idx = (int)_index + 1;
        }
    }else{
        if (_index + 1 < [_datasource jd_numberOfCells]) {
            idx = (int)_index + 1;
        }
    }
    
    if (idx >= 0) {
        
        _index = idx;
        
        JDSliderCell *nextCell = [self getCellAtIndex:_index];
        nextCell.frame = _nextFrame;
        [self addSubview:nextCell];
        [UIView animateWithDuration:1
                         animations:^{
                             
                             nextCell.frame = _showingFrame;
                             _showingCell.frame = _preFrame;
                             
                         }
                         completion:^(BOOL finish){
                             
                             [_reuableCells addObject:_showingCell];
                             [_showingCell removeFromSuperview];
                             _showingCell = nextCell;
                             
                         }];
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(jd_slider:didShowCellAtIndex:)]) {
        [_delegate jd_slider:self didShowCellAtIndex:idx];
    }
        
    
}

- (void)p_showPre
{
    int idx = -1;
    
    if (_playInCircle) {
        if ((int)_index  - 1 < 0) {
            idx =  (int)[_datasource jd_numberOfCells] - 1;
        }else{
            idx = (int)_index - 1;
        }
    }else{
        if ((int)_index  - 1 >= 0) {
            idx = (int)_index - 1;
        }
    }
    
    if (idx >= 0) {
        
        _index = idx;
        
        JDSliderCell *preCell = [self getCellAtIndex:_index];
        preCell.frame = _preFrame;
        [self addSubview:preCell];
        
        [UIView animateWithDuration:1
                         animations:^{
                             
                             preCell.frame = _showingFrame;
                             _showingCell.frame = _nextFrame;
                             
                         }
                         completion:^(BOOL finish){
                             
                             [_reuableCells addObject:_showingCell];
                             [_showingCell removeFromSuperview];
                             _showingCell = preCell;
                             
                         }];
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(jd_slider:didShowCellAtIndex:)]) {
        [_delegate jd_slider:self didShowCellAtIndex:idx];
    }
}

@end
