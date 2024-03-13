//
//  Wrapper.h
//  test4
//
//  Created by Judith on 24.05.23.
//

#ifndef Wrapper_h
#define Wrapper_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ArrayTuple : NSObject
@property (nonatomic, strong) NSMutableArray *distances;
@property (nonatomic, strong) NSMutableArray *indices;
@end

@interface MainResult : NSObject
@property (nonatomic) UIImage* inputImage;
@property (nonatomic) UIImage* outputImage;
@property (nonatomic) double replicationAccuracy;
@property (nonatomic) double distanceConsistency;
@end

@interface Wrapper: NSObject

+ (UIImage *)getImage:(UIImage *)image;
+ (MainResult *)main:(UIImage *)image;

@end

#endif /* Wrapper_h */
