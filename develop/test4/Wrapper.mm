//
//  Wrapper.m
//  test4
//
//  Created by Judith on 24.05.23.
//

#import "Wrapper.h"
#import <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <vector>
#include <opencv2/imgproc.hpp>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include <cmath>


using namespace cv;
using namespace std;

@implementation ArrayTuple
@end

@implementation MainResult
@end

@implementation Wrapper : NSObject


// HSV color ranges for color detection
//green printed line:
Scalar LOWER_LINE = Scalar(45, 50,50);
Scalar UPPER_LINE = Scalar(75, 255, 255);

// Red seam:
Scalar LOWER_SEAM = Scalar(105,50,50);     
Scalar UPPER_SEAM = Scalar(135,255,255);

// RGB colors depicted on the output image after matching
Vec3b LINE_COLOR = {0,100,0};
Vec3b SEAM_COLOR = {255,0,0};

// Pixel count in one row
int PIXEL_COUNT = 1;

// Pixel range size of array to check similarity during coarse registration
double PIXEL_RANGE = 15; //50

// Length of the given printed pattern
double PATTERN_LENGTH_MM = 280;

// Overlapping threshold, pixel tolerance
int OVERLAPPING_THRESHOLD = 8;


// Returns passed UIImage
// To call from StartView
+ (UIImage *)getImage:(UIImage *)image{
    return image;
}

// get array of colored line with at most PIXEL_COUNT colored pixel of each row
+ (NSMutableArray*)getArray:(Mat)mat{
    
    vector<CGPoint> vector;
    
    //add first colored pixel in row to array
    //add first PIXEL_COUNT pixels to one row then break
    int counter = 0;
    for (int r = 0; r<mat.rows; ++r){
        for (int c = 0; c<mat.cols; ++c){
            if (mat.at<uchar>(r,c) == 255){
                vector.push_back(CGPointMake(r, c));
                counter++;
                if (counter > PIXEL_COUNT){
                    break;
                }
            }
        }
    }
    if (vector.empty()){
        cout << "Vector returned by getArray is empty, no colored pixels found. Check color detection" << endl;
    }
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:vector.size()];
    
    for (int i = 0; i<vector.size(); ++i){
        [res addObject:[NSValue valueWithCGPoint:vector[i]]];
    }
    
    return res;
}

// Return full array of colored line
+ (NSMutableArray *)getFullArray:(Mat)mat{
    vector<CGPoint> vector;
    
    //int counter = 0;
    for (int r = 0; r<mat.rows; ++r){
        for (int c = 0; c<mat.cols; ++c){
            if (mat.at<uchar>(r,c) != 0){
                vector.push_back(CGPointMake(r, c));
            }
        }
    }
    if (vector.empty()){
        cout << "Vector returned by getFullArray is empty, no colored pixels found. Check color detection" << endl;
    }
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:vector.size()];
    
    for (int i = 0; i<vector.size(); ++i){
        [res addObject:[NSValue valueWithCGPoint:vector[i]]];
    }
    return res;
}


// Return height in pixels of an array of pixels
+ (int)getHeight:(NSMutableArray*)lineArray{

    if (lineArray.count == 0){
        cout << "Passed array in getHeight is empty." << endl;
        return 0;
    }
    
    vector<CGPoint> vector;
    for (NSValue *value in lineArray) {
        vector.push_back([value CGPointValue]);
    }
   
    int yTop = std::numeric_limits<int>::max();
    int yBottom = 0;
    for (int i = 0; i < vector.size(); ++i){
        if (vector[i].y < yTop){
            yTop = vector[i].y;
        }
        if (vector[i].y > yBottom){
            yBottom = vector[i].y;
        }
    }
    int height = yBottom-yTop +1;

    return height;
}

// Return difference of highest and lowest y coordinate in an array of pixels
+ (int)getHeightNaive:(NSMutableArray*)lineArray{
    
    vector<CGPoint> vector;
    for (NSValue *value in lineArray) {
        vector.push_back([value CGPointValue]);
    }
    
    int height = abs(vector[vector.size()-1].y - vector[0].y)+1;
    
    return height;
}

// Return CGPoint of the middle element in an array
+ (CGPoint)getCenterPoint:(NSMutableArray *)lineArray{
    
    vector<CGPoint> vector;
    for (NSValue *value in lineArray) {
        vector.push_back([value CGPointValue]);
    }
    
    CGPoint centerPoint = vector[round(vector.size()/2)];
    
    return centerPoint;
}

// Return index of the middle element in an array
+ (int)getCenterIndex:(NSMutableArray *)lineArray{
    
    int centerIndex = round(lineArray.count/2);
    
    return centerIndex;
}


// Moves array by its pivotB onto pivotA, returns moved array
+ (NSMutableArray *)move:(NSMutableArray*)sewnLineArray PivotA:(CGPoint)printedLinePivot PivotB:(CGPoint)sewnLinePivot{
    
    vector<CGPoint> sewnLine;
  
    for (NSValue *value in sewnLineArray) {
        sewnLine.push_back([value CGPointValue]);
    }
    
    CGFloat dx = printedLinePivot.x - sewnLinePivot.x;
    CGFloat dy = printedLinePivot.y - sewnLinePivot.y;
    
    for (int i = 0; i<sewnLine.size(); ++i){
        sewnLine[i].x = sewnLine[i].x + dx;
        sewnLine[i].y = sewnLine[i].y + dy;
    }
    
    NSMutableArray *movedLine = [NSMutableArray arrayWithCapacity:sewnLine.size()];
    for (int i = 0; i< sewnLine.size(); ++i){
        [movedLine addObject:[NSValue valueWithCGPoint:sewnLine[i]]];
    }
    
    return movedLine;
}

// Computes the euclidean distance between two coordinates
+ (double)euclidDistance:(CGPoint)point1 Point2:(CGPoint)point2{
    
    double dist = sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
    
    return dist;
}

// Computes the Chamfer distance between two arrays of coordinates
+ (double)chamferDistance:(NSMutableArray*)lineArray SeamArray:(NSMutableArray*)seamArray{

    if ( lineArray.count == 0 || seamArray.count == 0 ){
        cout << "Passed array in chamferDistance is empty." << endl;
    }
    
    vector<CGPoint> line, seam;
    
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    for (NSValue *value in seamArray) {
        seam.push_back([value CGPointValue]);
    }

    CGPoint closestPoint = seam[0];
    double closestDistance;
    int closestIndex;
    vector<double> closestDistances;
    double distance;

    // From all points in printed line, look for closest point in seam and return averaged sum of all distances
    for (int i = 0; i < line.size(); i++) {
        closestDistance = std::numeric_limits<double>::max();
    
        for (int j = 0; j < seam.size(); j++) {
            
            distance = [self euclidDistance:seam[j] Point2:line[i]];
            
            if (distance < closestDistance) {
                closestDistance = distance;
            }
        }
        closestDistances.push_back(closestDistance);
    }

    double sumDistancesA = 0;
    
    for (int i = 0; i<closestDistances.size(); ++i){
        sumDistancesA = sumDistancesA + closestDistances[i];
    }
    
    return sumDistancesA;
}

// return array of closest distances and the indices of the corresponding coordinates between two arrays of coordinates
+ (ArrayTuple *)getDistancesAndIndices:(NSMutableArray*)lineArray SeamArray:(NSMutableArray*)seamArray{

    if ( lineArray.count == 0 ){
        cout << "Passed printedlinearray in getDistancesAndIndices is empty." << endl;
    }
    if (seamArray.count == 0){
        cout << "passed sewnlinearray in getDistancesAndIndices is empty." << endl;
    }
    
    vector<CGPoint> line, seam;
    
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    for (NSValue *value in seamArray) {
        seam.push_back([value CGPointValue]);
    }

    CGPoint closestPoint = seam[0];
    double closestDistance;
    int closestIndex;
    
    vector<CGPoint> closestPoints;
    vector<double> closestDistances;
    vector<int> closestIndices;
      
    double distance;

    // Computes Chamfer distance between both arrays
    for (int i = 0; i < line.size(); i++) {
        closestDistance = std::numeric_limits<double>::max();
    
        for (int j = 0; j < seam.size(); j++) {
            
            distance = sqrt(pow(seam[j].x - line[i].x, 2) + pow(seam[j].y - line[i].y, 2));
            
            if (distance < closestDistance) {
                closestDistance = distance;
                closestPoint = seam[j];
                closestIndex = j;
            }
        }
        closestPoints.push_back(closestPoint);
        closestDistances.push_back(closestDistance);
        closestIndices.push_back(closestIndex);
    }

    ArrayTuple *result = [[ArrayTuple alloc] init];
    
    NSMutableArray *distancesArray = [NSMutableArray arrayWithCapacity:closestDistances.size()];
    for (int i = 0; i<closestDistances.size(); ++i){
        [distancesArray addObject:[NSNumber numberWithDouble:closestDistances[i]]];
    }
    result.distances = distancesArray;
    
    NSMutableArray *indicesArray = [NSMutableArray arrayWithCapacity:closestIndices.size()];
    for (int i = 0; i< closestIndices.size(); ++i){
        [indicesArray addObject:[NSNumber numberWithInt:closestIndices[i]]];
    }
    result.indices =  indicesArray;
    
    return result;
    
}

// Returns array of matched seam
+ (NSMutableArray *)match:(NSMutableArray *)lineArray SeamArray:(NSMutableArray *)seamArray  LineCenter:(CGPoint)lineCenter{

    if (lineArray.count == 0 || seamArray.count == 0){
        cout << "passed array in match is empty" << endl;
    }
    
    // do not move initial sewn line position but return found position
    NSMutableArray *curSeamArray = seamArray;
    
    vector<CGPoint> seam;
    for (NSValue *value in seamArray) {
        seam.push_back([value CGPointValue]);
    }
        
    // COARSE REGISTRATION to align a and b by minimizing chamfer distance
    int centerPrinted = [self getCenterIndex:lineArray];
    int rangeStartIndex = [self getCenterIndex:lineArray] - round(PIXEL_RANGE/2);
    int rangeEndIndex = rangeStartIndex + PIXEL_RANGE;
    CGPoint pivotA = [self getCenterPoint:lineArray];
    
    int index = rangeStartIndex;
 
    // Set to initial distance before matching
    double minDist = [self chamferDistance:lineArray SeamArray:seamArray];
    
    double curDist;
    NSMutableArray *matchedSeamArray;
    
    // Check range in printed line with center point of seam
    NSMutableArray *movedSeam;
    while (index < rangeEndIndex ){
        movedSeam = [self move:curSeamArray PivotA:pivotA PivotB:seam[index]];
        CGPoint first;
        NSValue *v = [movedSeam firstObject];
        first = [v CGPointValue];
        
        curDist = [self chamferDistance:lineArray SeamArray:movedSeam];
        if (curDist < minDist){
            minDist = curDist;
            matchedSeamArray = movedSeam;
        }
        index += 1;
    }
        
    if (matchedSeamArray.count == 0){
        cout << "matchedSewnLineArray empty" << endl;
    }
    
    return matchedSeamArray;
}

// Computes the percentage of 0 distances with tolerance of OVERLAPPING_THRESHOLD of array with distances
+ (double)replicationAccuracy:(NSMutableArray *)distancesAfterMatching{
    
    double overlappingPoints = 0;
    vector<double> distances;

    for (NSNumber *value in distancesAfterMatching) {
        distances.push_back([value doubleValue]);
    }

    //Counts how many distances are less than OVERLAPPING_THRESHOLD
    for (int i = 0; i< distances.size(); i++){
        if (distances[i] < OVERLAPPING_THRESHOLD){
            overlappingPoints++;
        }
    }
  
    double ratio = overlappingPoints/distances.size();

    double replicationAccuracy = ratio * 100;

    return replicationAccuracy;
}

// Returns the initial distances between two arrays of coordinates by the closest indices of moved array
+ (NSMutableArray *)getInitialDistances:(NSMutableArray *)lineArray SeamArray:(NSMutableArray *)seamArray indicesForLine:(NSMutableArray *)indicesAfterMatching{
    
    vector<CGPoint> line, seam;
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    for (NSValue *value in seamArray) {
        seam.push_back([value CGPointValue]);
    }
    vector<int> indices;
    for (NSNumber *value in indicesAfterMatching) {
        indices.push_back([value intValue]);
    }
    
    // Test, should be same size:
    if (indices.size() != line.size()){
        cout << "indices array and printed are not same size. Check getDistancesAndIndices()" << endl;
    }
    
    vector<double> distances;
    double dist;
    for (int i = 0; i<indices.size(); ++i){
        // Compute distance between printedline i and matching point from sewnline
        dist = [self euclidDistance:line[i] Point2:seam[indices[i]]];
        distances.push_back(dist);
    }
    
    NSMutableArray *initialDistances = [NSMutableArray arrayWithCapacity:distances.size()];
    for (int i = 0; i<distances.size(); ++i){
        [initialDistances addObject:[NSNumber numberWithDouble:distances[i]]];
    }
    
    return initialDistances;
}

// Computes the standard deviation of an array of distances
+ (double)distanceConsistency:(NSMutableArray *)lineArray InitialDistances:(NSMutableArray *)initialDistances{
    
    vector<CGPoint> line;
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    
    vector<double> initialDist;
    for (NSNumber *i in initialDistances) {
        initialDist.push_back([i doubleValue]);
    }
    
    // Standard deviation
    double sum = 0;
    double sumOfSquares = 0;
    int count = initialDist.size();
        
    for (int i =0; i< initialDist.size(); ++i) {
        double value = initialDist[i];
        sum += value;
    }
        
    double mean = sum/count;
    double difSquareSum = 0.0;
    for (int i = 0; i<initialDist.size(); i++){
        double value = initialDist[i];
        double dif = value-mean;
        double difSquare = dif*dif;
        difSquareSum += difSquare;
    }
    
    double variance = difSquareSum/count;
    double squareVariance = sqrt(variance);
    
    // Convert to mm
    double pixelLength = [self getHeightNaive:lineArray];
    double mmPerPixel = PATTERN_LENGTH_MM/pixelLength;
        
    double distConsistency = mmPerPixel * squareVariance;

    return abs(distConsistency);
}

// Returns UIImage of blank canvas with drawn lines from arrays
+ (UIImage *)getReturnImage:(Mat)inputImageMat LineArray:(NSMutableArray *)lineArray MatchedSeamArray:(NSMutableArray *)matchedSeam{
   
    vector<CGPoint> line, seam;
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    for (NSValue *value in matchedSeam) {
        seam.push_back([value CGPointValue]);
    }
    
        Mat mat(inputImageMat.size(), CV_8UC3, Scalar(255, 255, 255));
    
    // Colors for drawn lines
    Vec3b colorPrinted = LINE_COLOR;
    Vec3b colorSewn = SEAM_COLOR;
    
    for (int i =0; i<line.size(); ++i){
        mat.at<Vec3b>(line[i].x, line[i].y) = colorPrinted;
    }
    for (int i =0; i<seam.size(); ++i){
        mat.at<Vec3b>(seam[i].x, seam[i].y) = colorSewn;
    }
    
    return MatToUIImage(mat);
}

// Return coordinates of array of which y coordinates are closest to passed y coordinate of centerFirst
+ (CGPoint)getCenterBasedOnYCoord:(NSMutableArray *)lineArray FirstFoundCenter:(CGPoint)centerFirst{
    
    vector<CGPoint> line;
    for (NSValue *value in lineArray) {
        line.push_back([value CGPointValue]);
    }
    CGPoint centerSecond = line[0];

    
    int minDif = abs(centerSecond.y - centerFirst.y);
    for (int i = 0; i<line.size(); ++i){
        if (abs(line[i].y - centerFirst.y) < minDif){
            centerSecond = line[i];
            minDif = abs(line[i].y - centerFirst.y);
        }
    }

    return centerSecond;
}

// Main function to call from View
// Detects two colored lines in an image, aligns them onto each other, computes similarity metrics
// Returns input image, image of matched lines, distance consistency, replication accuracy
+ (MainResult *)main:(UIImage *)image{
    NSDate *startTime = [NSDate date];
    
    Mat mat;
    UIImageToMat(image, mat);
    
    // Preprocess
    GaussianBlur(mat, mat, cv::Size(5,5),0);
    cvtColor(mat, mat, COLOR_BGR2HSV);
        
    // Detect printed line by color
    Mat printedLineExtracted;
    cv::inRange(mat, LOWER_LINE, UPPER_LINE, printedLineExtracted);
 
    // Detect seam by color
    Mat mask1, mask2, seamExtracted;
    cv::inRange(mat, LOWER_SEAM, UPPER_SEAM, seamExtracted);
    
    // Get arrays of detected lines with limited coordinates in each row
    NSMutableArray *lineArray = [self getArray:printedLineExtracted];
    NSMutableArray *seamArray = [self getArray:seamExtracted];
    
    // Get full arrays of detected lines
    NSMutableArray *lineFullArray = [self getFullArray:printedLineExtracted];
    NSMutableArray *seamFullArray = [self getFullArray:seamExtracted];
    
    // Get center points of lines
    CGPoint centerLine = [self getCenterPoint:lineArray];
    CGPoint centerSeam = [self getCenterPoint:seamArray];
    
    // Get center points based on y-coordinate
    CGPoint centerYLine = [self getCenterBasedOnYCoord:lineArray FirstFoundCenter:centerLine];
    CGPoint centerYSeam = [self getCenterBasedOnYCoord:seamArray FirstFoundCenter:centerSeam];
    
    // Correct center if difference between y-coordinates is higher than set pixel range to search for
    if (abs(centerYLine.y - centerYSeam.y) > PIXEL_RANGE){
        centerYSeam.y = centerYLine.y;
    }
    
    // Match seam onto printed line
    NSMutableArray *matchedSeam = [self match:lineArray SeamArray:seamArray LineCenter:centerYLine];
    
    // Position seamFullArray onto matchedSeam for resulting image
    CGPoint pivotSeamFull, pivotSeam;
    NSValue *a = [seamFullArray firstObject];
    NSValue *b = [matchedSeam firstObject];
    pivotSeamFull = [a CGPointValue];
    pivotSeam = [b CGPointValue];
    NSMutableArray *matchedSeamFullArray = [self move:seamFullArray PivotA:pivotSeam PivotB:pivotSeamFull];

    // Get tuple of current distances and indices between matched seam and printed line
    ArrayTuple *distAndIndices = [self getDistancesAndIndices:lineArray SeamArray:matchedSeam];
    
    NSMutableArray *distancesAfterMatching = distAndIndices.distances;
    NSMutableArray *indicesAfterMatching = distAndIndices.indices;
    
    // Get array of initial distances
    NSMutableArray *distancesPreMatching = [self getInitialDistances:lineArray SeamArray:seamArray indicesForLine:indicesAfterMatching];
    
    // Compute distance consistency
    double distanceConsistency = [self distanceConsistency:lineArray InitialDistances:distancesPreMatching];
    
    // try values for full matched seam = for every point in printed line look for closest point in seam
    ArrayTuple *distAndIndices3 = [self getDistancesAndIndices:lineArray SeamArray:matchedSeamFullArray];
    NSMutableArray *distancesAfterMatching3 = distAndIndices3.distances;
    double replicationAccuracy = [self replicationAccuracy:distancesAfterMatching3];
        
    MainResult *resValues = [[MainResult alloc] init];
    
    resValues.replicationAccuracy = replicationAccuracy;
    resValues.distanceConsistency = distanceConsistency;
    resValues.inputImage = image;
    resValues.outputImage = [self getReturnImage:mat LineArray:lineFullArray MatchedSeamArray:matchedSeamFullArray];
    
    NSDate *endTime = [NSDate date];
        NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:startTime];
        NSLog(@"Execution time: %f seconds", timeInterval);
    
    
    return resValues;
}


@end
