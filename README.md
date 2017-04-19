# QLTurntableDemo
###一个简单的转盘抽奖demo，结构封装，用法简单。

##效果图
 ![image](https://github.com/QiuFairy/QLTurntableDemo/raw/master/QLTurntableDemo.png)

##使用方法

```objc
/*!
 ImageArr:图片的数组
 PrizeArr:奖励的数组
 NumberArr:概率的数组
 */
-(instancetype)initWithFrame:(CGRect)frame ImageArr:(NSArray *)imageArr PrizeArr:(NSArray *)prizeArr NumberArr:(NSArray *)numberArr;
```
```objc
/*!
 Index:抽中的数据下标
 BtnClickNum:剩下的抽奖次数
 */
- (void)TurnTableViewDidFinishWithIndex:(NSInteger)index BtnClickNum:(NSInteger)btnClickNum;
```
##Note
```objc
在上述初始化概率数组中的数据均为百分制数据，不过可以选择设置概率的分制：TurntableProbabilityModel(可选：百分制，万分制)
```

# BY QiuFairy 
