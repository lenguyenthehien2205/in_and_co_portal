import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
class InfoRow extends StatelessWidget{
  final String title;
  final String? content;
  final List<Map<String, String>>? icons;
  const InfoRow({
    super.key,
    required this.title,
    this.content,
    this.icons,
  });

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Không thể mở URL: $url");
    }
  }

  @override
  Widget build(context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: AppText(text: title, style: AppText.normal(context)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide( 
                  width: 1.2,
                  color: const Color.fromARGB(255, 188, 188, 188)
                )
              ),
            ),
            width: 200,
            child: Row(
              children: [
                if (icons != null)
                ...icons!.map((iconData) => GestureDetector(
                  onTap: () => _launchURL(iconData['url']!),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Image.asset(
                      iconData['icon']!, 
                      width: 40, 
                      height: 40
                    ),
                  ),
                )),
                Expanded( 
                  child: Text(
                    content ?? '',
                    style: AppText.normal(context),
                    softWrap: true, 
                    maxLines: null,  
                    textAlign: TextAlign.justify, 
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}