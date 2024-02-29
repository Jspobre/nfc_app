import 'package:flutter/material.dart';

//this button can take 4 parameters, btnText & onClick is required
// example1:   StyleButton(btnText: "Test", onClick: (){})
// example2:   StyleButton(btnText: "Test", onClick: (){}, btnIcon: Icon(Icons.login), btnWidth: 250)
// 250 is the default width

class StyledButton extends StatelessWidget {
  final String btnText;
  final Function()? onClick;
  final dynamic btnIcon;
  final double? btnWidth;
  final double? btnHeight;
  final dynamic btnColor;
  final dynamic textColor;
  final bool? noShadow;
  final String? secondText;
  final dynamic borderRadius;
  final bool? iconOnRight;
  final double? textSize;
  final bool? isBorder;
  final EdgeInsetsGeometry? padding;

  const StyledButton(
      {super.key,
      required this.btnText,
      required this.onClick,
      this.btnIcon,
      this.btnWidth,
      this.btnHeight,
      this.btnColor,
      this.noShadow,
      this.secondText,
      this.borderRadius,
      this.textColor,
      this.iconOnRight,
      this.textSize,
      this.isBorder,
      this.padding});

  @override
  Widget build(BuildContext context) {
    // BUTTON WITH ICON
    if (btnIcon != null && iconOnRight == null && iconOnRight != true) {
      return SizedBox(
        height: btnHeight ?? 45,
        width: btnWidth,
        child: ElevatedButton.icon(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            padding: padding != null ? padding : null,

            // fixedSize: const Size(250, 32),
            elevation: noShadow == true ? 0 : 2,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8)),
            backgroundColor: btnColor ?? const Color(0xff16A637),
            foregroundColor: textColor ?? Colors.white,
            textStyle: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
                fontSize: textSize ?? 19,
                fontFamily: "Roboto"),
          ),
          icon: btnIcon,
          label: secondText != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      btnText,
                    ),
                    Text(
                      secondText!,
                    )
                  ],
                )
              : Text(btnText),
        ),
      );
    } else if (btnIcon != null && iconOnRight != null && iconOnRight == true) {
      return SizedBox(
        height: btnHeight ?? 45,
        width: btnWidth,
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
              padding: padding != null ? padding : null,
              // fixedSize: const Size(250, 32),
              elevation: noShadow == true ? 0 : 2,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8)),
              backgroundColor: btnColor ?? Color(0xff16A637),
              foregroundColor: textColor ?? Colors.white,
              textStyle: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                  fontSize: textSize ?? 19,
                  fontFamily: "Roboto"),
              side: isBorder != null
                  ? BorderSide(
                      color: Color(0xff16A637),
                    )
                  : null),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                btnText,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 8,
              ),
              btnIcon
            ],
          ),
        ),
      );
    } else {
      // BUTTON WITHOUT ICON
      return SizedBox(
        height: btnHeight ?? 45,
        width: btnWidth,
        child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            padding: padding != null ? padding : null,
            side: isBorder != null
                ? BorderSide(
                    color: Color(0xff16A637),
                  )
                : null,

            // fixedSize: const Size(250, 32),
            elevation: noShadow == true ? 0 : 2,

            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8)),
            backgroundColor: btnColor ?? Color(0xff16A637),
            foregroundColor: textColor ?? Colors.white,
            textStyle: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
                fontSize: textSize ?? 19,
                fontFamily: "Roboto"),
          ),
          child: Text(
            btnText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }
}
