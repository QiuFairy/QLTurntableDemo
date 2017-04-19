//
//  QLTurntableView.h
//  QLTurntableDemo
//
//  Created by qiu on 2017/4/18.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>


/*!
 @enum
 @abstract 百分制即为最小的概率为整数即0,or,1;万分制即最小的概率为万分之1,最小也为整数;
 */
typedef NS_ENUM(NSInteger, TurntableProbabilityModel) {
    TurntableProbabilityPercentage   = 100,    // 百分制
    TurntableProbabilityExtremely    = 10000,    // 万分制
};

@protocol TurntableViewDelegate <NSObject>

- (void)TurnTableViewDidFinishWithIndex:(NSInteger)index BtnClickNum:(NSInteger)btnClickNum;

@end

@interface QLTurntableView : UIView
/*!
 @property
 @abstract 表示概率为几分制，默认为TurntableProbabilityPercentage
 */
@property (nonatomic, assign) TurntableProbabilityModel probabilityModel;

@property (nonatomic, assign) NSInteger btnClickNum;


//代理
@property(nonatomic,weak) id<TurntableViewDelegate>delegate;

/*!
 ImageArr:图片的数组
 PrizeArr:奖励的数组
 NumberArr:概率的数组
 */
-(instancetype)initWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr PrizeArr:(NSArray *)prizeArr NumberArr:(NSArray *)numberArr;

@end
