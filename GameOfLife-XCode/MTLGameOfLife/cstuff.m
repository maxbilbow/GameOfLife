//
//  cstuff.m
//  GameOfLife
//
//  Created by Max Bilbow on 07/08/2015.
//  Copyright © 2015 Max Bilbow. All rights reserved.
//


#import <GLKit/GLKMatrix4.h>

const void * GLKMatrix4UnsafePointer(GLKMatrix4 * mat) {
    void * ptr = mat->m;
    return ptr;
}
