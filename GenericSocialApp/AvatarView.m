//
//  AvatarView.m
//  PeggSite
//
//  Created by Jennifer Duffey on 3/30/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self insertSubview:self.avatarImageView atIndex:0];
    }
    
    return self;
}

- (id)initWithAvatarURL:(NSString *)avatarURL
{
    self = [super initWithFrame:CGRectMake(0, 0, AVATAR_SIZE, AVATAR_SIZE)];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, avatarURL]];
        
        __weak AvatarView *weakSelf = self;
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self insertSubview:self.avatarImageView atIndex:0];
        
        [self.avatarImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
        {
            if(!image)
                weakSelf.avatarImageView.image = [UIImage imageNamed:IMAGE_GENERIC_AVATAR];
            
            [weakSelf setNeedsLayout];
        }];
    }
    
    return self;
}

- (void)setAvatarURL:(NSString *)avatarURL
{
    if(avatarURL)
    {
        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PEGGSITE_IMAGE_URL, avatarURL]];
        
        __weak AvatarView *weakSelf = self;
        
        [self.avatarImageView setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             //NSLog(@"Image downloaded: %f, %f", image.size.width, image.size.height);
             
             if(!image)
                 weakSelf.avatarImageView.image = [UIImage imageNamed:IMAGE_GENERIC_AVATAR];
             
             [weakSelf setNeedsLayout];
         }];
    }
    else
    {
        self.avatarImageView.image = [UIImage imageNamed:IMAGE_GENERIC_AVATAR];
    }
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    
    if(editable)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
}

- (void)setPhotoMode:(BOOL)photoMode
{
    _photoMode = photoMode;
    
    [self setNeedsDisplay];
}

- (void)avatarTapped:(UIGestureRecognizer *)recognizer
{
    [self.delegate avatarViewWasSelected:self];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    [super drawLayer:layer inContext:ctx];
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 6;
    self.avatarImageView.layer.borderColor = [UIColor colorWithHexString:COLOR_AVATAR_BORDER].CGColor;
    
    if(self.photoMode)
    {
        self.avatarImageView.layer.borderWidth = 2.0;
    }
    else
    {
        self.avatarImageView.layer.borderWidth = 0.0;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
