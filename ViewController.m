# Block-break
#import "ViewController.h"
@interface ViewController ()
{
    //小球的速度
    CGPoint _ballVelocity;
    //挡板速度
    CGPoint _baffleVelocity;
    //游戏时钟
    CADisplayLink *_GameTimer;
}
@end

@implementation ViewController
#pragma mark 退出游戏，返回主界面
- (IBAction)End:(UIButton *)sender {
    exit(0);
}
#pragma mark 视图的加载
- (void)viewDidLoad {
    [self SetupUI];
}
- (void)SetupUI
{
    //为了进行坐标运算和重新初始化，对小球和挡板进行初始位置赋值
    _BallImageView.frame =CGRectMake(170, 517, 55, 50);
    _BaffleImageView.frame = CGRectMake(90, 575, 220, 35);
    //给小球赋以初速度
    _ballVelocity = CGPointMake(0.0, -5.0);
    //打开游戏时钟
    _GameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(Renovate)];
    //将游戏时钟加入循环
    [_GameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //让游戏结束后的“再来一次”和“退出游戏”，以及分数显示隐藏
    _Restart.hidden = YES;
    _Exit.hidden = YES;
    _Message.hidden = YES;
    //将分数初始化为0
    _Grade.text = @"0";
    //将所有砖块显示,需要遍历所有方块
    for (UIImageView *block in _BlocksImageView) {
        [block setHidden:NO];
}
}
//# warning 进行了三个碰撞判定后，我们得让判定时刻进行，就是屏幕时刻刷新进行判定。而任意时刻小球的在view上的位置也应该时刻由速度和初始位置决定，所以我们需要引入 CADisplayLink 游戏时钟。
//CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器
#pragma mark 刷新时的方法执行
- (void)Renovate{
    //屏幕一次次刷新，进行已经写好的三个碰撞设定
    [self boundaryCollision];
    [self CollisionWithBlock];
    [self CollisionWithBaffle];
    //进行小球位置的更新
    //坐标用CGPoint表示
    [_BallImageView setCenter : CGPointMake(_BallImageView.center.x + _ballVelocity.x,
                                        _BallImageView.center.y + _ballVelocity.y)];
}
#pragma mark 进行小球与边界的碰撞判定
- (void)boundaryCollision
{
//与上方的碰撞判定

    if(CGRectGetMinY(_BallImageView.frame) <= 0){
        _ballVelocity.y = -(_ballVelocity.y);
    }
    //与左端的碰撞判定
    if(CGRectGetMinX(_BallImageView.frame) <= 0){
        _ballVelocity.x = -(_ballVelocity.x);
    }
    //与右端的碰撞判定
    if(CGRectGetMaxX(_BallImageView.frame) >=375){
        _ballVelocity.x = -(_ballVelocity.x);
    }
    //与下方，掉落下方即游戏结束
    if(CGRectGetMaxY(_BallImageView.frame) >=667){
        //编写结束界面
       [self performSelector:@selector(FailView) withObject:nil afterDelay:0.5];
        //关闭游戏时钟
        [_GameTimer invalidate];
    }
}
#pragma mark 进行小球与砖块的碰撞判定
- (void)CollisionWithBlock{
    //如果所有砖块都被隐藏了，说明游戏胜利。所以对所有砖块遍历
            BOOL win = YES;
    for (UIImageView *block in _BlocksImageView){
        if(![block isHidden])
        {
            BOOL win = NO;
            break;
        }
        if(win)
            [_Exit setHidden:NO];
            [_Restart setHidden:NO];
            [_Message setHidden:NO];
        //关闭游戏时钟
        [_GameTimer invalidate];
        _Message.text = @"恭喜你，你赢啦！";
    }
    //我们需要对所有砖块进行判定，所以起初要进行一次遍历
    //CGRectIntersectsRect 可以用来判断两个结构体是否有交错
    for (UIImageView *block in _BlocksImageView) {
        //需要小球和砖块接触并且此砖块没有隐藏
        if(CGRectIntersectsRect(block.frame, _BallImageView.frame) && ![block isHidden])
        {
            //将砖块隐藏
            [block setHidden:YES];
            //获取当前分数
            int Nowgrade = [_Grade.text intValue];
            //给当前分数加五百
            Nowgrade +=500;
            //重新赋给当前分数
            _Grade.text = [NSString stringWithFormat:@"%d",Nowgrade];
            //改变小球y方向上的速度以及略微改变x方向上的速度
            _ballVelocity.y = -(_ballVelocity.y);
            _ballVelocity.x+=0.5;
        }
                                                }
}
#pragma mark 进行小球与挡板的碰撞判定
- (void)CollisionWithBaffle{
    //同样的方法，如果小球和挡板碰撞
    if(CGRectIntersectsRect(_BaffleImageView.frame, _BallImageView.frame))
    {
        //让小球y轴上反方向弹回
        _ballVelocity.y = -(_ballVelocity.y);
        //轻微修改一下x轴上的速度
        _ballVelocity.x += 0.3;
    }
}
#pragma mark 游戏失败界面
- (void)FailView
{
    //启用退出游戏和重新开始选项并且显示分数
    [_Exit setHidden:NO];
    [_Restart setHidden:NO];
    [_Message setHidden:NO];
    //显示最后得分
    int lastgrade = [_Grade.text intValue];
    _Message.text = [NSString stringWithFormat:@"很遗憾，最后你的得分为%d",lastgrade];
}
#pragma mark 重新开始游戏
- (IBAction)Restartgame:(UIButton *)sender {
        //重新加载视图
        [self SetupUI];
}
@end
