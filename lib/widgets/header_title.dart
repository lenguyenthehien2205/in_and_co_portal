import 'package:flutter/widgets.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class HeaderTitle extends StatelessWidget{
  final String content;
  const HeaderTitle({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 8),
      child: AppText(
        text: content,
        style: AppText.title(context),
      ),
    );
  }
}