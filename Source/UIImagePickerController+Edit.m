//
//  UIImagePickerController+Edit.m
//  DZNPhotoPickerController
//  https://github.com/dzenbot/DZNPhotoPickerController
//
//  Created by Ignacio Romero Zurbuchen on 1/2/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIImagePickerController+Edit.h"
#import "DZNPhotoPickerController.h"

static DZNPhotoEditViewControllerCropMode _editingMode;

@implementation UIImagePickerController (Edit)

- (void)setEditingMode:(DZNPhotoEditViewControllerCropMode)mode
{
    _editingMode = mode;
    
    switch (mode) {
        case DZNPhotoEditViewControllerCropModeSquare:
            self.allowsEditing = YES;
            break;
            
        case DZNPhotoEditViewControllerCropModeCircular:
            self.allowsEditing = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPickImage:) name:kDZNPhotoPickerDidFinishPickingNotification object:nil];
            break;
            
        case DZNPhotoEditViewControllerCropModeNone:
            self.allowsEditing = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kDZNPhotoPickerDidFinishPickingNotification object:nil];
            break;
    }
}

- (DZNPhotoEditViewControllerCropMode)editingMode
{
    return _editingMode;
}

- (void)didPickImage:(NSNotification *)notification
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"self.delegate : %@", self.delegate);
    NSLog(@"respondsToSelector didFinishPickingMediaWithInfo : %@", [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)] ? @"Y" : @"NO");

    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]){
        
        if ([[notification.userInfo  allKeys] containsObject:UIImagePickerControllerEditedImage]) {
            self.editingMode = DZNPhotoEditViewControllerCropModeNone;
        }
        else {
            NSLog(@"No edited photo found!");
        }
        
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:notification.userInfo];
    }
}

@end
