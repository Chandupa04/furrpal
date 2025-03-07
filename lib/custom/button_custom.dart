import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:platform_text/platform_text.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.text,
    required this.callback,
    this.btnHeight,
    this.btnWidth,
    this.btnColor,
    this.borderRadius,
    this.dontApplyMargin,
    this.isDisabled,
    this.borderSide = BorderSide.none,
    this.textStyle,
    this.margin,
    this.inProgress,
    this.padding,
    this.splashColor,
    this.isPositive,
    this.child,
    this.textColor,
    this.elevation,
    this.gradient,
    this.mainAxisAlignment,
    this.disabledColor,
    this.ischildPositionRight = false,
    // required bool isLoading,
  });

  final double? btnHeight;
  final double? btnWidth;
  final String text;
  final TextStyle? textStyle;
  final Color? btnColor;
  final VoidCallback? callback;
  final BorderRadius? borderRadius;
  final bool? dontApplyMargin;
  final bool? isDisabled;
  final BorderSide borderSide;
  final EdgeInsets? margin;
  final bool? inProgress;
  final EdgeInsetsGeometry? padding;
  final Color? splashColor;
  final bool? isPositive;
  final Widget? child;
  final Color? textColor;
  final double? elevation;
  final Gradient? gradient;
  final MainAxisAlignment? mainAxisAlignment;
  final Color? disabledColor;
  final bool? ischildPositionRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: gradient,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(20.h),
        ),
        color: (callback == null || isDisabled == true)
            ? disabledColor ?? Colors.grey
            : null,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: (callback == null || isDisabled == true)
        //       ? [Colors.grey, Colors.grey]
        //       : [const Color(0xFF87CEEB), const Color(0xFF1B7A9F)],
        // ),
      ),
      margin: margin ??
          EdgeInsets.symmetric(horizontal: dontApplyMargin == true ? 0 : 35),
      height: btnHeight ?? 52.h,
      width: btnWidth,
      // alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          elevation: elevation,
          backgroundColor: btnColor ?? primaryColor,
          foregroundColor: splashColor ?? Colors.white24,
          padding: padding ?? const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(20.h),
            side: borderSide,
          ),
          disabledBackgroundColor: disabledColor ?? Colors.grey,
        ),
        onPressed: (callback == null || isDisabled == true)
            ? null
            : () {
                callback!();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(),
          child: Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
            children: [
              if (child != null && ischildPositionRight == false)
                Row(
                  children: [
                    child!,
                    SizedBox(width: 8.w),
                  ],
                ),
              Container(
                alignment: Alignment.center,
                child: (inProgress == true)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : PlatformText(
                        text,
                        style: textStyle ??
                            TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor ?? Colors.white,
                            ),
                      ),
              ),
              if (ischildPositionRight == true)
                Row(
                  children: [
                    SizedBox(width: 8.w),
                    child!,
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
