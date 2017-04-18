# Block-break
#import "ViewController.h"
@interface ViewController ()
{
    //小球的速度
    CGPoint _ballVelocity;
    //挡板速度
    CGPoint _baffleVelocity;
}
@end

@implementation ViewController
#pragma mark 视图的加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //为了进行坐标运算和重新初始化，对小球和挡板进行初始位置赋值
    _BallImageView.frame =CGRectMake(170, 528, 55, 50);
    _BaffleImageView.frame = CGRectMake(90, 575, 220, 35);
    //让游戏结束后的“再来一次”和“退出游戏”隐藏
    [_Restart setHidden:YES];
    [_Exit setHidden:YES];
    //将分数初始化为0
    _Grade.text = @"分数：0";
}
#pragma mark 进行小球与边界的碰撞判定
- (void)boundaryCollision
{
    //与上方的碰撞判定
    if(CGRectGetMinX(_BallImageView.frame) <= 0){
        _ballVelocity.y = -_ballVelocity.y;
    }
    //与左端的碰撞判定
    if(CGRectGetMinY(_BallImageView.frame) <= 0){
        _ballVelocity.x = -_ballVelocity.x;
    }
    //与右端的碰撞判定
    if(CGRectGetMaxX(_BallImageView.frame) <=0){
        _ballVelocity.x = -_ballVelocity.x;
    }
    //与下方，掉落下方即游戏结束
    if(CGRectGetMaxY(_BallImageView.frame) <= 0){
        //编写结束界面
        //展示得分
        
        //屏幕变暗
        [self.view setAlpha:0.1];
        //出现“再来一次”和“退出游戏”选项
        [_Restart setHidden:NO];
        [_Exit setHidden:NO];
    }
}
#pragma mark 进行小球与砖块的碰撞判定
- (void)baffleCollision
{
    
}
#pragma mark 退出游戏，返回主界面
- (IBAction)End:(UIButton *)sender {
    exit(1);
}
#pragma mark 重新开始游戏
- (void)Restartgame
{
    //重新加载视图
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
