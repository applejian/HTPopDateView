//
//  HTPopDateView.m
//  HTPopDateViewDemo
//
//  Created by Horae.tech on 16/1/28.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTPopDateView.h"

#define VIEW_WIDTH         300
#define VIEW_HEIGHT        200

@interface ArrowLayer : CAShapeLayer
@end

@implementation ArrowLayer

-(id) initWithColor:(UIColor *)color {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.bounds = CGRectMake(0, 0, 7, 12);
    self.position = CGPointMake(0,0);
    self.anchorPoint = CGPointMake(0,0);
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    const CGFloat kArrowSize =20;
    const CGFloat arrowXM = 50;
    const CGFloat arrowX0 = arrowXM - kArrowSize;
    const CGFloat arrowX1 = arrowXM + kArrowSize;
    const CGFloat arrowY0 = 0;
    const CGFloat arrowY1 = 0 + kArrowSize + 3;
    
    [trianglePath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
    [trianglePath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
    [trianglePath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
    [trianglePath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
    
    self.path = trianglePath.CGPath;
    self.fillColor = color.CGColor;
    
    return self;
}
@end

@implementation HTPopDateView{
    UIColor      *_menuColor;
    UIView       *_backGroundView;
    UIView       *_workspaceView;
    UIDatePicker *_datePicker;
    UIButton     *_cancelButton;
    UIButton     *_confirmButton;
    CATextLayer  *_titleLayer;
    ArrowLayer   *_arrowLayer;
    bool _show;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configViewWithDate:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configViewWithDate:nil];
        
    }
    return self;
}

- (void)configViewWithDate:(NSDate *)date{
    if (!date) {
        date = [NSDate date];
    }
    
    _menuColor = [UIColor colorWithRed:86/255.0 green:167/255.0 blue:36/255.0 alpha:1.0];
    CGFloat textLayerInterval = 80;
    CGPoint position = CGPointMake(textLayerInterval, self.frame.size.height / 2);
    _titleLayer = [self creatTextLayerWithNSString:[self dateToString:date] withColor:_menuColor andPosition:position];
    [self.layer addSublayer:_titleLayer];
    
    CAShapeLayer *indicator = [self creatIndicatorWithColor:_menuColor andPosition:CGPointMake(position.x + _titleLayer.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
    [self.layer addSublayer:indicator];
    
    [self initWorkSpaceView:date];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopView:)];
    [self addGestureRecognizer:tapGesture];
    // backgroud
    _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    _backGroundView.opaque = NO;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
    [_backGroundView addGestureRecognizer:gesture];
    
}

- (void )initWorkSpaceView:(NSDate *)date{
    
    _workspaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, VIEW_WIDTH, VIEW_HEIGHT)];
    
    _arrowLayer = [[ArrowLayer alloc] initWithColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    CGRect arrowFrame = _arrowLayer.frame;
    arrowFrame.origin.x = 50;
    arrowFrame.origin.y = 0;
    _arrowLayer.frame = arrowFrame;
    [_workspaceView.layer addSublayer:_arrowLayer];
    
    // DatePicker
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    _datePicker.date = [NSDate date];
    if (date) {
        _datePicker.date = date;
    }
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] CGColor];
    _datePicker.layer.borderWidth = 1;
    _datePicker.layer.masksToBounds = YES;
    _datePicker.layer.cornerRadius = 5.0f;
    _datePicker.frame = CGRectMake(10, 10, VIEW_WIDTH-20, VIEW_HEIGHT-20);
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_workspaceView addSubview:_datePicker];
    
}

- (void)dateChanged:(id)sender{
    _title = [self dateToString:_datePicker.date];
    
    _titleLayer.string = _title;
    
}

- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < self.frame.size.width- 25) ? size.width : self.frame.size.width - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 16.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = [[UIColor blackColor]CGColor];
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}


- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 16.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - tapPopView
- (void)tapPopView:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_backGroundView view:_workspaceView forward:YES complecte:^{
        _show = YES;
    }];
    
}

- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_backGroundView view:_workspaceView forward:NO complecte:^{
        _show = NO;
    }];
    
}

- (void)animateIdicator:(UIView *)background view:(UIView *)view forward:(BOOL)forward complecte:(void(^)())complete{
    
    
    [self animateBackGroundView:background show:forward complete:^{
        [self animateWorkspaceView:view show:forward complete:^{
        }];
    }];
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    
    if (show) {
        
        [_backgroudView addSubview:view];
        //        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
    complete();
    
}

- (void)animateWorkspaceView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    CGFloat x = self.superview.frame.origin.x + self.frame.origin.x;
    CGFloat y = self.superview.frame.origin.y + self.frame.origin.y + self.frame.size.height+20;
    
    if (show) {
        view.frame = CGRectMake(x, y, VIEW_WIDTH, 0);
        [_backgroudView addSubview:view];
        
        
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(x, y-5, VIEW_WIDTH, VIEW_HEIGHT);
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = CGRectMake(x, y-5, VIEW_WIDTH, 0);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
        
    }
    complete();
    
}

- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy年MM月dd日"];
    return[formatter stringFromDate:date];
}



@end

