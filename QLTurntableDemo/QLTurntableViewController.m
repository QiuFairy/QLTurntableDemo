//
//  QLTurntableViewController.m
//  QLTurntableDemo
//
//  Created by qiu on 2017/4/18.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#import "QLTurntableViewController.h"

#import "QLTurntableView.h"

#define screenW self.view.bounds.size.width

@interface QLTurntableViewController ()<TurntableViewDelegate>

@property (nonatomic,strong) QLTurntableView * turntable;
@property (nonatomic,strong) UILabel * label;//展示

@property (nonatomic, retain) NSArray *imageArray;//图片数组
@property (nonatomic, retain) NSArray *prizeArray;//奖励数组
@property (nonatomic, retain) NSArray *numberArray;//概率数组--百分制
@end

@implementation QLTurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageArray = @[@"qiandao_0000_000",@"qiandao_0001_001",@"qiandao_0002_003",@"qiandao_0003_01",@"qiandao_0004_02",@"qiandao_0000_000",@"2000",@"qiandao_0003_01",@"2000",@"qiandao_0003_01"];
    _prizeArray = @[@"500",@"2000",@"5000",@"一束鲜花",@"20000",@"500",@"2000",@"谢谢"];
    
    //此处数组数据为百分制数据，即概率为整数10%，1%等等，即最小为1%OR0,则不会为其他
    _numberArray = @[@10.f,@20.f,@15.f,@20.f,@0.f,@20.f,@5.f,@10.f];
    
    // 转盘View
    self.turntable = [[QLTurntableView alloc] initWithFrame:CGRectMake(0, 0, screenW-50, screenW-50) ImageArr:_imageArray PrizeArr:_prizeArray NumberArr:_numberArray];
    self.turntable.center = self.view.center;
    self.turntable.delegate = self;
    //可修改几分制概率，但上面的概率数组一律为百分制数据，具体的分制转换已封装
//    self.turntable.probabilityModel = TurntableProbabilityExtremely;
//    self.turntable.btnClickNum = 5;
    [self.view addSubview:self.turntable];
    
    //显示奖励的label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.turntable.frame)+50, screenW-100, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.label];
}
- (void)TurnTableViewDidFinishWithIndex:(NSInteger)index BtnClickNum:(NSInteger)btnClickNum{
    if (btnClickNum == 0) {
        // 点击后的次数显示
        self.label.text = [NSString stringWithFormat:@"您的次数已用尽"];
    }else{
        // 转盘结束后调用，显示获得的对应奖励
        self.label.text = [NSString stringWithFormat:@"恭喜您抽中%@",_prizeArray[index]];
    }

   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
