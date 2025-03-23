import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';

class TextFieldCustom extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final BorderRadius? borderRadius;
  final Alignment? alignment;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final Color? fillColor;
  final Color? borderColor;
  final BorderSide? border;
  final bool? useUnderlineBorder;
  final TextStyle? hintstyle;
  final TextStyle? labelstyle;
  final Widget? prefix;
  final Widget? prefixIcon;
  final bool? isOtpField;
  final Widget? suffix;
  final Widget? suffixIcon;
  final VoidCallback? onSubmit;
  final bool? obscureText;
  final TextEditingController? controller;
  final TextAlignVertical? textAlignVertical;
  final double? borderWidth;
  final double? cphorizontal;
  final List<BoxShadow>? boxShadow;
  final int? maxLines;
  final bool? expands;
  final EdgeInsetsGeometry? containerPadding;
  final TextInputAction? textInputAction;

  const TextFieldCustom({
    super.key,
    this.hintText,
    this.labelText,
    this.icon,
    this.prefix,
    this.prefixIcon,
    this.onChanged,
    this.width,
    this.height,
    this.marginLeft = 0,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    this.borderRadius,
    this.alignment,
    this.keyboardType,
    this.textAlign,
    this.isOtpField,
    this.fillColor,
    this.borderColor,
    this.border,
    this.useUnderlineBorder,
    this.hintstyle,
    this.labelstyle,
    this.suffix,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.onSubmit,
    this.textAlignVertical,
    this.borderWidth,
    this.cphorizontal,
    this.boxShadow,
    this.maxLines,
    this.expands,
    this.containerPadding,
    this.textInputAction,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIconWidget;
    if (widget.obscureText == true) {
      suffixIconWidget = IconButton(
        onPressed: () {
          setState(() {
            isObscured = !isObscured;
          });
        },
        icon: Icon(
          isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      );
    } else {
      suffixIconWidget = widget.suffixIcon;
    }

    InputBorder getBorder() {
      if (widget.useUnderlineBorder == true) {
        return UnderlineInputBorder(
          borderSide: widget.border ??
              BorderSide(color: widget.borderColor ?? Colors.black),
        );
      } else {
        return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10.r),
          borderSide: widget.border ??
              BorderSide(
                  color: widget.borderColor ?? Colors.transparent,
                  width: widget.borderWidth ?? 1.w),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: widget.boxShadow,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10.r),
        color: widget.fillColor ?? whiteColor,
      ),
      padding: widget.containerPadding,
      width: widget.width,
      height: widget.height ?? 54.h,
      margin: EdgeInsets.only(
        top: widget.marginTop,
        left: widget.marginLeft,
        right: widget.marginRight,
        bottom: widget.marginBottom,
      ),
      alignment: widget.alignment ?? Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: widget.width ?? 310.w,
          minHeight: widget.height ?? 41.h,
        ),
        child: TextField(
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          controller: widget.controller,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          obscureText: isObscured,
          onSubmitted: (_) {
            if (widget.onSubmit != null) {
              widget.onSubmit!();
            }
          },
          expands: isObscured == true ? false : widget.expands ?? true,
          maxLines: isObscured == true ? 1 : widget.maxLines,
          minLines: null,
          inputFormatters:
              widget.isOtpField != null && widget.isOtpField == true
                  ? [
                      LengthLimitingTextInputFormatter(1),
                    ]
                  : null,
          textAlign: widget.textAlign ?? TextAlign.left,
          textAlignVertical:
              widget.textAlignVertical ?? TextAlignVertical.center,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintstyle ??
                TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
            labelText: widget.labelText,
            labelStyle: widget.labelstyle ??
                TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff999999),
                ),
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            suffix: widget.suffix,
            suffixIcon: suffixIconWidget,
            //  widget.obscureText == true
            //     ? IconButton(
            //         onPressed: () {
            //           setState(() {
            //             isobscutured = !isobscutured;
            //           });
            //         },
            //         icon: Icon(
            //           isobscutured == true
            //               ? Icons.visibility_off_outlined
            //               : Icons.visibility_outlined,
            //         ),
            //       )
            //     : widget.suffixIcon,
            contentPadding: EdgeInsets.symmetric(
                vertical: 2.h, horizontal: widget.cphorizontal ?? 16.w),
            enabledBorder: getBorder(),
            //     OutlineInputBorder(
            //   borderSide: border ??
            //       BorderSide(
            //         color: borderColor ?? Colors.black,
            //       ),
            // ),
            border: getBorder(),
            //     OutlineInputBorder(
            //   borderRadius: borderRadius ?? BorderRadius.circular(10.h),
            //   borderSide: const BorderSide(
            //     color: Colors.grey, // replace with your unfocused border color
            //   ),
            // ),
            focusedBorder: getBorder(),
            //     OutlineInputBorder(
            //   borderRadius: borderRadius ?? BorderRadius.circular(10.h),
            //   borderSide: const BorderSide(
            //     color: Colors.black, // replace with your focused border color
            //   ),
            // ),
            fillColor: Colors.transparent,
            filled: widget.fillColor != null ? true : false,
          ),
          keyboardType: widget.keyboardType,
        ),
      ),
    );
  }
}
