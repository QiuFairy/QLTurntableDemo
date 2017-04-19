//
//  QLTurntableView.m
//  QLTurntableDemo
//
//  Created by qiu on 2017/4/18.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//


#import "QLTurntableView.h"

#define turnScale_W self.bounds.size.width/300
#define turnScale_H self.bounds.size.height/300


@interface QLTurntableView ()<CAAnimationDelegate>
@property (nonatomic,assign) NSInteger numberIndex; //抽中的奖励

@property (nonatomic,strong) UIButton * playButton;      // 抽奖按钮
@property (nonatomic,strong) UIImageView * rotateWheel;  // 转盘背景

@property (nonatomic, retain) NSArray *numberArr; //概率数组

@property (nonatomic, assign) NSInteger turnTableNum;//奖品的个数
@property (nonatomic, assign) CGFloat turnTableAngle;//倾斜角度

@end

@implementation QLTurntableView

-(instancetype)initWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr PrizeArr:(NSArray *)prizeArr NumberArr:(NSArray *)numberArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.probabilityModel = TurntableProbabilityPercentage;
        self.btnClickNum = NSIntegerMax;
        [self initUIWithImageArr:imageArr PrizeArr:prizeArr NumberArr:numberArr];
    }
    return self;
}

-(void)initUIWithImageArr:(NSArray *)imageArr PrizeArr:(NSArray *)prizeArr NumberArr:(NSArray *)numberArr{
    _numberArr = numberArr;
    _turnTableNum = prizeArr.count;
    _turnTableAngle = 360/_turnTableNum;
    
    // 转盘
    self.rotateWheel = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.rotateWheel];
    self.rotateWheel.image = [UIImage imageNamed:@"qiandao_0008_yy"];
    
    // 抽奖按钮
    self.playButton = [[UIButton alloc]initWithFrame:
                       CGRectMake(0,0,CGRectGetWidth(self.bounds)/3,CGRectGetHeight(self.bounds)/3)];
    self.playButton.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetWidth(self.bounds)/2);
    self.playButton.layer.cornerRadius = CGRectGetWidth(self.bounds)/3/2;
    [self.playButton addTarget:self action:@selector(startAnimaition) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    
    // 外围装饰背景图
    UIImageView * backImageView = [UIImageView new];
    backImageView.image = [UIImage imageNamed:@"2_0000_up"];
    [self addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, 330*turnScale_W, 365*turnScale_H);
    backImageView.center = CGPointMake(self.rotateWheel.center.x-1*turnScale_W, self.rotateWheel.center.y-10*turnScale_H);
    
    //Masonry约束
    
//        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.rotateWheel.mas_centerX).with.offset(-1*turnScale_W);
//            make.centerY.mas_equalTo(self.rotateWheel.mas_centerY).with.offset(-13*turnScale_H);
//            make.size.mas_equalTo(CGSizeMake(330*turnScale_W, 345*turnScale_H));
//        }];
    
    // 在转盘上添加图片和文字
    
    for (int i = 0; i < _turnTableNum; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,M_PI * CGRectGetHeight(self.bounds)/_turnTableNum,               CGRectGetHeight(self.bounds)/2)];
        label.layer.anchorPoint = CGPointMake(0.5, 1);
        label.center = CGPointMake(CGRectGetHeight(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        label.text = [NSString stringWithFormat:@"%@", prizeArr[i]];
        CGFloat angle = M_PI * 2 / prizeArr.count * i;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.transform = CGAffineTransformMakeRotation(angle);
        [self.rotateWheel addSubview:label];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35*turnScale_W, 12, M_PI * CGRectGetHeight(self.bounds)/_turnTableNum - 65*turnScale_W, _turnTableAngle*turnScale_H)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [label addSubview:imageView];
    }
}

-(void)startAnimaition{
    if (self.btnClickNum ==0) {
        if ([self.delegate respondsToSelector:@selector(TurnTableViewDidFinishWithIndex:BtnClickNum:)]) {
            [self.delegate TurnTableViewDidFinishWithIndex:0 BtnClickNum:0];
        }
        return;
    }else if(self.btnClickNum != NSIntegerMax){
        self.btnClickNum -- ;
    }
    // 禁止用户交互
    self.playButton.userInteractionEnabled = NO;
    NSInteger turnAngle = 0;
    NSInteger randomNum = arc4random()%self.probabilityModel;//控制概率
    NSInteger turnsNum = arc4random()%5;
    turnsNum = turnsNum > 3?turnsNum:3;//控制圈数
    
    //变换数组，变成所有和的数组，来进行下一步的判断
    NSArray *arr = [self changeArrWithArr:_numberArr];
    for (int i=0; i<arr.count-1; i++) {
        if(randomNum >=[arr[i] floatValue] && randomNum <[arr[i+1] floatValue]){
            turnAngle = _turnTableAngle*i;
            _numberIndex = i;
        }
    }
    
    //设置默认奖品，防止溢出
    if (randomNum >=[arr[arr.count-1] floatValue]) {
        turnAngle = 0;
        _numberIndex = 0;
    }
    
    //调整逆时针计算为顺时针
    turnAngle = 360-turnAngle;
    
    CGFloat perAngle = M_PI/180.0;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:turnAngle * perAngle + 360 * perAngle * turnsNum];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    rotationAnimation.delegate = self;
    
    //由快变慢
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.rotateWheel.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.playButton.userInteractionEnabled = YES;
    
    if ([self.delegate respondsToSelector:@selector(TurnTableViewDidFinishWithIndex:BtnClickNum:)]) {
        [self.delegate TurnTableViewDidFinishWithIndex:_numberIndex BtnClickNum:self.btnClickNum];
    }
}

-(NSArray *)changeArrWithArr:(NSArray *)numArr{
    NSArray *newNumArr = [self changeArrToIntArrWithOldArr:numArr];
    //最后总和相加必须为100，so最后一个数据的判断，绝不会超过100，随机数为0-99(百分制)
    NSMutableArray *changeArr = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<=newNumArr.count; i++) {
        NSArray *topNumArr =[newNumArr subarrayWithRange:NSMakeRange(0, i)];
        CGFloat sum = [[topNumArr valueForKeyPath:@"@sum.floatValue"] floatValue];
        [changeArr addObject:@(sum)];
    }
    
    return changeArr;
}

-(NSArray *)changeArrToIntArrWithOldArr:(NSArray *)oldArr{
    //先进行转化为整数
    NSInteger probabilityNum = 1;
    switch (self.probabilityModel) {
        case TurntableProbabilityPercentage:
            probabilityNum =1;
            break;
        case TurntableProbabilityExtremely:
            probabilityNum =100;
            break;
        default:
            probabilityNum =1;
            break;
    }
    
    NSMutableArray *changeArr = [NSMutableArray arrayWithCapacity:10];
    for (id num in oldArr) {
        NSInteger changeNum = [num floatValue]*probabilityNum;
        [changeArr addObject:@(changeNum)];
    }
    return changeArr;
}


@end
