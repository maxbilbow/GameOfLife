//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <GLKit/GLKMatrix4.h>

//@interface CStuff
//+ (void *) Matrix4UnsafePointer:(GLKMatrix4 *)m;
//@end


const void * GLKMatrix4UnsafePointer(GLKMatrix4 * mat);