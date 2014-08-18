//
//  AddPhotoViewController.m
//  PeggSite
//
//  Created by Jennifer Duffey on 7/10/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "PhotoContentView.h"
#import "AssetManager.h"
#import "PhotoViewCell.h"
#import "GalleryThumbnailView.h"
#import <AVFoundation/AVFoundation.h>

@interface AddPhotoViewController ()
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, assign) NSInteger selectedPhotoIndex;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *visibleScreens;
@property (nonatomic, assign) PhotoScreen currentPhotoScreen;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *imageToPost;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;
@property (nonatomic, strong) UIImageView *focusView;

- (IBAction)showGallery:(id)sender;
- (IBAction)choose:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)toggleFlash:(id)sender;
- (IBAction)flipCamera:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)post:(id)sender;

@end

@implementation AddPhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register observer
    AVCaptureDevice *camDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([camDevice isFocusPointOfInterestSupported])
    {
        NSInteger flags = NSKeyValueObservingOptionNew;
        [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister observer
    AVCaptureDevice *camDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([camDevice isFocusPointOfInterestSupported])
    {
        [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];
    
    self.visibleScreens = [[NSMutableArray alloc] init];
    
    // Creat the focus retangle
    self.focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    self.focusView.alpha = 0.0f;
    self.focusView.animationImages = @[[UIImage imageNamed:@"focus_reticle_1"], [UIImage imageNamed:@"focus_reticle_2"]];
    self.focusView.animationDuration = 0.28f;
    [self.view addSubview:self.focusView];
    
    [self getPhotos];
}

- (void)getPhotos
{
    [self.photos removeAllObjects];
    
    [[AssetManager sharedInstance] loadAssetsWithCompletionBlock:^(NSArray *assets, NSError *error)
     {
         [self.photos addObjectsFromArray:assets];
         
         [self showCamera];
     }];
}

- (void)showCamera
{
    if(!self.imagePicker)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera Unavailable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            [self setCurrentPhotoScreen:PhotoScreenLibrary];
            return;
        }
        
        PhotoContentView *cameraOverlayView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenOverlay];
        [cameraOverlayView setHidden:NO];
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //self.imagePicker.allowsEditing = YES;
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.cameraOverlayView = cameraOverlayView;
        
        PhotoContentView *photoView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenCamera];
        [photoView addSubview:self.imagePicker.view];
    }
    
    [self setCurrentPhotoScreen:PhotoScreenCamera];
    
    //[self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)setCurrentPhotoScreen:(PhotoScreen)currentPhotoScreen
{
    [self.activeTextField resignFirstResponder];
    [self.activeTextView resignFirstResponder];
    
    if(currentPhotoScreen == _currentPhotoScreen)
        return;
    
    if(currentPhotoScreen == PhotoScreenNone)
    {
        [self.navController popViewController];
        return;
    }
    
    PhotoContentView *oldView = (PhotoContentView *)[self.view viewWithTag:_currentPhotoScreen];
    PhotoContentView *newView = (PhotoContentView *)[self.view viewWithTag:currentPhotoScreen];
    
    if(_currentPhotoScreen == PhotoScreenNone)
        oldView = nil;
    
    if(currentPhotoScreen < _currentPhotoScreen)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [oldView setLeft:APP_WIDTH];
             [newView setLeft:0];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             [oldView setRight:0];
             [newView setLeft:0];
         }];
        
        [self.visibleScreens addObject:@(currentPhotoScreen)];
    }
    
    if(currentPhotoScreen == PhotoScreenLibrary)
    {
        ALAsset *asset = self.photos[0];
        self.imageToPost = [Utils getFullImageFromAssetRepresentation:asset];
        newView.photoImageView.image = self.imageToPost;
        [self.photoCollectionView reloadData];
    }
    else if(currentPhotoScreen == PhotoScreenCamera)
    {
        PhotoContentView *cameraOverlayView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenOverlay];
        [cameraOverlayView setHidden:NO];
        
        ALAsset *asset = self.photos[0];
        cameraOverlayView.galleryThumbnailView.thumbnailImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
    else if(currentPhotoScreen == PhotoScreenCaption && _currentPhotoScreen == PhotoScreenLibrary)
    {
        newView.photoImageView.image = oldView.photoImageView.image;
    }
    
    _currentPhotoScreen = currentPhotoScreen;
}

- (IBAction)cancel:(id)sender
{
    [Region setCurrentRegion:nil];
    
    [self.visibleScreens removeLastObject];
    [self setCurrentPhotoScreen:[[self.visibleScreens lastObject] intValue]];
}

- (IBAction)post:(id)sender
{
    [[DataManager sharedInstance] uploadImage:self.imageToPost toRegionNumber:[Region currentRegion].regionNumber delegate:self];
}

- (IBAction)showGallery:(id)sender
{
    [self setCurrentPhotoScreen:PhotoScreenLibrary];
}

- (IBAction)takePicture:(id)sender
{
    [self.imagePicker takePicture];
}

- (IBAction)choose:(id)sender
{
    [self setCurrentPhotoScreen:PhotoScreenCaption];
}

- (IBAction)toggleFlash:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    
    NSLog(@"Flash mode: %ld", (long)self.imagePicker.cameraFlashMode);
    
    if(btn.selected)
    {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else
    {
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

- (IBAction)flipCamera:(id)sender
{
    if(self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self.flashButton setHidden:YES];
    }
    else
    {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self.flashButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureDevice Observe Methods
// Detect when camera focus is adjusting
//
// @link http://stackoverflow.com/a/9110038/158651
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"adjustingFocus"])
    {
        // Are we still on the photo screen?
        if (self.currentPhotoScreen ==  PhotoScreenCamera)
        {
            AVCaptureDevice *camDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            BOOL isAdjustingFocus = [change[NSKeyValueChangeNewKey] isEqualToNumber:@1];
            
            if(isAdjustingFocus)
            {
                // Convert the focusPoint.x/y into a view point
                float focusX = self.imagePicker.view.frame.size.width * (1.0f - camDevice.focusPointOfInterest.y);
                float focusY = (self.imagePicker.view.frame.size.width * 4/3) * camDevice.focusPointOfInterest.x;
                
                // Position the focus rectangle
                self.focusView.left = focusX - self.focusView.width / 2;
                self.focusView.top = focusY - self.focusView.height / 2;
                
                // Show the focus reticle
                [self.focusView startAnimating];
                self.focusView.alpha = 1.0f;
            }
            else
            {
                // Hide the focus reticle
                self.focusView.alpha = 0.0f;
                [self.focusView stopAnimating];
            }
        }
        else
        {
            // User is no longer on the photo screen, hide the focus reticle
            if (self.focusView.isAnimating)
            {
                self.focusView.alpha = 0.0f;
                [self.focusView stopAnimating];
            }
        }
    }
}

#pragma mark - UICollectionView Datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)cv
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView*)cv numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    PhotoViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    
    ALAsset *asset = self.photos[indexPath.row];
    [cell setAsset:asset];
    [cell setSelected:(indexPath.row == self.selectedPhotoIndex)];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoContentView *currentView = (PhotoContentView *)[self.view viewWithTag:self.currentPhotoScreen];
    ALAsset *asset = self.photos[indexPath.row];
    
    UIImage *rotatedImage = [Utils getFullImageFromAssetRepresentation:asset];
    
    self.imageToPost = rotatedImage;
    currentView.photoImageView.image = self.imageToPost;
    self.selectedPhotoIndex = indexPath.row;
    [self.photoCollectionView reloadData];
}

#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    PhotoContentView *captionView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenCaption];
    
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    captionView.photoImageView.image = image;
    captionView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self setCurrentPhotoScreen:PhotoScreenCaption];
    
    [self.imagePicker.cameraOverlayView setHidden:YES];
    
    self.imageToPost = image;
    
    // [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navController popViewController];
}

#pragma mark - UITextViewDelegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length > TEXT_MAX_LENGTH)
        return NO;
    
    return YES;
}

#pragma mark - DataManagerDelegate
- (void)dataManager:(DataManager *)dataManager didReturnData:(id)data
{
    switch (dataManager.requestType)
    {
        case RequestTypeUpload:
        {
            PhotoContentView *captionView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenCaption];
            
            NSDictionary *dict = (NSDictionary *)data;
            Article *article = [[Article alloc] initWithDictionary:dict];
            article.caption = captionView.captionTextView.text;
            
            [[DataManager sharedInstance] updateArticle:article delegate:self];
           /* PhotoContentView *captionView = (PhotoContentView *)[self.view viewWithTag:PhotoScreenCaption];
            
            [DataManager sharedInstance] updateArticle:<#(Article *)#> delegate:<#(id)#>
            [[DataManager sharedInstance] createArticleWithExternalMediaID:nil articleType:ArticleTypeImage regionNumber:[Region currentRegion].regionNumber text:@"" caption:captionView.captionTextView.text delegate:self];*/
            
           // UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_POSTED_PREFIX customMessage:nil showOther:NO andDelegate:self];
           // [alert show];
        }
            break;
            
        case RequestTypeCreateArticle:
        {
            [[DataManager sharedInstance] uploadImage:self.imageToPost toRegionNumber:[Region currentRegion].regionNumber delegate:self];
            
            //UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_POSTED_PREFIX customMessage:nil showOther:NO andDelegate:self];
            //[alert show];
        }
            break;
            
        case RequestTypeUpdateArticle:
        {
            UIAlertView *alert = [Utils createAlertWithPrefix:STRING_CONTENT_UPDATED_PREFIX customMessage:nil showOther:NO andDelegate:self];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Nav Bar Visibility
- (BOOL)showNav
{
    return NO;
}

#pragma mark - Tab Bar Visibility
- (BOOL)showTabs
{
    return NO;
}

#pragma mark - Spinner Type For View
- (SpinnerType)spinnerType
{
    return SpinnerTypeGray;
}

#pragma mark - Nav Bar Title
- (NSString *)title
{
    return nil;
}

@end
