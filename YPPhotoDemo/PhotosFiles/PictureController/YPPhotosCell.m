//
//  YPPhotosCell.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotosCell.h"

/// @brief cell的选中状态
NS_OPTIONS(NSUInteger, YPPhotosCellType)
{
    CellTypeDeseleted = 0,/**<未选中 */
    CellTypeSelected = 1, /**<选中 */
};

@interface YPPhotosCell ()

@property (nonatomic, assign)enum YPPhotosCellType cellType;

@property (weak, nonatomic)YPPhotosCell * weakSelf;

@end

@implementation YPPhotosCell

-(void)prepareForReuse
{
    //重置所有数据
    self.imageView.image = nil;
    self.chooseImageView.hidden = false;
    self.messageView.hidden = true;
    self.messageImageView.image = nil;
    self.messageLabel.text = @"";
    [self.chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    self.cellType = CellTypeDeseleted;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self photosCellWillLoad];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self photosCellWillLoad];

}


- (void)photosCellWillLoad
{
    _weakSelf = self;
    self.backgroundColor = [UIColor cyanColor];
    
    //add subviews
    [self addSubImageView];
    [self addSubChooseImageView];
    [self addSubMessageView];
    [self addSubMessageImageView];
    [self addSubMessageLabel];


}


/** 选择按钮被点击 */
- (IBAction)chooseButtonDidTap:(id)sender
{
    switch (_cellType)
    {
        case CellTypeDeseleted:
            [self buttonShouldSelect];break;
            
        case CellTypeSelected:
            [self buttonShouldDeselect];break;
    }
}


- (void)buttonShouldSelect
{
    __weak typeof(self)copy_self = self;
    [self cellDidSelect];
    [self startAnimation];
    if (self.imageSelectedBlock) self.imageSelectedBlock(copy_self);
}



- (void)startAnimation
{
    //anmiation
    [UIView animateWithDuration:0.2 animations:^{
        
        //放大
        _chooseImageView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {//变回
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _chooseImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
        }];
        
    }];
}


- (void)buttonShouldDeselect
{
    __weak typeof(self)copy_self = self;
    [self cellDidDeselect];
    if (self.imageDeselectedBlock) self.imageDeselectedBlock(copy_self);
}


-(void)cellDidSelect
{
    _cellType = CellTypeSelected;
    [_chooseImageView setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
}


-(void)cellDidDeselect
{
    _cellType = CellTypeDeseleted;
    [self.chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}


#pragma mark - CreateSubviews

- (void)addSubImageView
{
    //添加imageView
    _imageView = [[UIImageView alloc]init];
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    _imageView.clipsToBounds = true;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = [UIColor redColor];
    
    
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(_weakSelf.contentView);
        
    }];
    
    //等价
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}


- (void)addSubMessageView
{
    _messageView = [[UIView alloc]init];
    _messageView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.contentView addSubview:_messageView];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.and.bottom.equalTo(_weakSelf.contentView);
        make.height.equalTo(@(20));
        
    }];
    
    //等价
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_messageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageView(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageView)]];
    
    
    _messageView.backgroundColor = [UIColor blackColor];
    _messageView.hidden = true;
}


- (void)addSubMessageImageView
{
    _messageImageView = [[UIImageView alloc]init];
    _messageImageView.translatesAutoresizingMaskIntoConstraints = false;
    
    [_messageView addSubview:_messageImageView];
    
    [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(5));
        make.bottom.equalTo(_weakSelf.messageView);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];

//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_messageImageView(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView)]];
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageImageView(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView)]];

}


- (void)addSubMessageLabel
{
    _messageLabel = [[UILabel alloc]init];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [_messageView addSubview:_messageLabel];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_weakSelf.messageImageView.mas_right);
        make.right.equalTo(_weakSelf.messageView).offset(-3);
        make.bottom.equalTo(_weakSelf.messageView);
        make.height.mas_equalTo(20);
        
    }];
    
//    
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_messageImageView]-0-[_messageLabel]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageImageView,_messageLabel)]];
//    [_messageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_messageLabel(20)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLabel)]];
    
    
    _messageLabel.font = [UIFont systemFontOfSize:11];
    _messageLabel.textAlignment = NSTextAlignmentRight;
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.text = @"00:25";
}


- (void)addSubChooseImageView
{
    _chooseImageView = [[UIButton alloc]init];
    _chooseImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_chooseImageView];
    
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.and.bottom.mas_equalTo(-3);
        
    }];
    
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_chooseImageView(25)]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_chooseImageView(25)]-3-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_chooseImageView)]];
    
    _chooseImageView.layer.cornerRadius = 25 / 2.0f;
    _chooseImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_chooseImageView setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [_chooseImageView addTarget:self action:@selector(chooseButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}


@end
