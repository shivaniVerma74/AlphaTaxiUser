import 'package:cabira/utils/Session.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Locale/locale.dart';
import 'package:cabira/Locale/strings_enum.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? text;
  final Color? color;
  final textColor;
  final BorderRadius? borderRadius;
  final IconData? icon;

  CustomButton({
    this.onTap,
    this.text,
    this.color,
    this.textColor,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return icon != null
        ? TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
                side: BorderSide.none,
              ),
              backgroundColor: color ?? theme.primaryColor,
            ),
            onPressed: onTap as void Function()? ?? () {},
            icon: Icon(
              icon,
              color: textColor ?? theme.scaffoldBackgroundColor,
            ),
            label: Text(
              text != null
                  ? text!.toUpperCase()
                  : getTranslated(context, "CONTINUE")!.toUpperCase(),
              style: theme.textTheme.button!
                  .copyWith(color: textColor ?? theme.scaffoldBackgroundColor),
            ),
          )
        : TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
                side: BorderSide.none,
              ),
              backgroundColor: color ?? theme.primaryColor,
            ),
            onPressed: onTap as void Function()? ?? () {},
            child: Text(
              text != null
                  ? text!.toUpperCase()
                  : getTranslated(context, "CONTINUE")!.toUpperCase(),
              style: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 18.0), //?? theme.scaffoldBackgroundColor
            ),
          );
  }
}
