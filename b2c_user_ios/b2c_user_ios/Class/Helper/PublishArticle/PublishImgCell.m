//
//  PublishImgCell.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishImgCell.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>

@interface PublishImgCell ()


@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation PublishImgCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

       // self.contentView.backgroundColor = [UIColor orangeColor];
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        

        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}



- (void)setImage:(UIImage *)image {

    _image = image;
    
    _imgView.image = image;
}










@end
