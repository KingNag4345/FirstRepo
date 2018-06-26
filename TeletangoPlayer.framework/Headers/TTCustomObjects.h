//
//  CustomObjects.h
//  Demo
//
//  Created by Nagaraju on 14/04/16.
//  Copyright © 2016 Apptarix. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    TFTextEditingBegin,
    TFTextEditingEnd,
    TFTextEditingReturn
}TFStatus;
typedef void (^ButtonActionBlock)(UIButton *);


#define kCCBackgroundColor  @"BackgroundColor"     //UIColor
#define kCCTintColor        @"TintColor"           //UIcolor
#define kCCTextColor        @"TextColor"           //UIColor
#define kCCTextAlignment    @"TextAlignment"       //NSNumber With int Value
#define kCCTextFont         @"TextFont"            //UIFont
#define kCCCornerRadius     @"CornerRadius"        //NSNumber With float Value
#define kCCBorderColor      @"BorderColor"         //UIColor
#define kCCBorderWidth      @"BorderWidth"         //NSNumber With float Value
#define kCCImage            @"Image"               //UIImage
#define kCCTag              @"Tag"                 //NSNumber With int Value
#define kCCContentMode      @"ContentMode"         //NSNumber With int Value
#define kCCAlpha            @"Alpha"               //NSNumber With float Value
#define kCCText             @"Text"                //NSString
#define kCCPlaceHolderText  @"PlaceHolder"         //NSString
#define kCCPlaceHolderColor @"PlaceHolderColor"    //UIColor
#define kCCLeftView         @"LeftView"            //UIView
#define kCCRightView        @"RightView"           //UIView
#define kCCSeparatorColor   @"SeparatorColor"      //UIColor
#define kCCSecureEntery     @"SecureEntery"        //NSNumber With int Value(0,1)
#define kCCReturnKey        @"ReturnKey"           //NSNumber With int Value
#define kCCKeyboardType     @"KeyboardType"        //NSNumber With int Value
#define kCCBarTintColor     @"BarTintColor"        //UIcolor

#import <Foundation/Foundation.h>

@interface TTCustomObjects : NSObject

+ (TTCustomObjects *)singleton;

- (UILabel *)labelWithAttributes:(NSDictionary *)attributes frame:(CGRect)frame;
- (UIImageView *)imageViewWithAttributes:(NSDictionary *)attributes frame:(CGRect)frame;
- (UIButton *)buttonWithAttributes:(NSDictionary *)attributes frame:(CGRect)frame completion:(void(^)(UIButton *))completion;
- (UITextField *)textFieldWithAttributes:(NSDictionary *)attributes frame:(CGRect)frame target:(id)target;
- (UITableView *)tableViewWithAttributes:(NSDictionary *)attributes frame:(CGRect)frame target:(id)target;
- (UIButton *)createButtonWithFrame:(CGRect)frame selector:(SEL)selector bgColor:(UIColor *)bgColor isRounded:(BOOL)isRounded title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(NSString *)font size:(CGFloat)size image:(UIImage *)image cornerRadius:(float)radius target:(id)target;
-(NSString*)urlEscape:(NSString *)unencodedString;
-(NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params;
-(BOOL)isReachable;
-(int)feedTimeStamp:(NSString *)dateString withFormat:(NSString *)dateFormat;
-(NSString *)replaceHTMLEntitiesInString:(NSString *)htmlString;
-(NSMutableDictionary *)getRequestParams;
- (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label;
- (BOOL)checkVisibilityOfCell:(UICollectionViewCell *)cell inScrollView:(UIScrollView *)aScrollView;
- (UIColor *)colorFromHexString:(NSString *)hexString;
-(NSString *)convertStartAndEndTimeWithDotValueIntoString:(NSString *)startTime;

@end
TTCustomObjects *ObjectManager(void);
