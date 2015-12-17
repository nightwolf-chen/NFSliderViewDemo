//
//  JDSlider.h
//  NFSliderViewDemo
//
//  Created by ChenJidong on 15/12/17.
//  Copyright © 2015年 nirvawolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDSlider;
@class JDSliderCell;


/**
 *  类似UITableViewDatasource
 */
@protocol JDSliderDatasource <NSObject>
@required
- (JDSliderCell *)jd_cellForSlider:(JDSlider *)slider atIndex:(NSUInteger)idx;
- (NSUInteger)jd_numberOfCells;
@end

/**
 *  类似于UITableView的delegate
 */
@protocol JDSliderDelegate <NSObject>
@optional
- (void)jd_slider:(JDSlider *)slider didShowCellAtIndex:(NSUInteger)idx;
- (void)jd_slider:(JDSlider *)slider didSelectCellAtIndex:(NSUInteger)idx;
@end


/**
 *  类似于UITableViewCell
 */
@interface JDSliderCell : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeRightRecognizer;

- (id)initWithSlider:(JDSlider *)slider;

@end



/**
 *  无限轮播控件
 */
@interface JDSlider : UIView
@property (nonatomic,weak) id<JDSliderDatasource> datasource;
@property (nonatomic,weak) id<JDSliderDelegate> delegate;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,assign) BOOL playInCircle;

- (instancetype)initWithFrame:(CGRect)frame;

- (JDSliderCell *)dequeReuableCell;

- (void)reloadData;

@end
