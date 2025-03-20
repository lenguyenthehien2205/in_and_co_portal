import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class CompanyPostItem extends StatelessWidget{
  final Post post;
  const CompanyPostItem({
    super.key, 
    required this.post
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              post.images[0]['url']??'',
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 130,
                  height: 130,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: 130,
                height: 130,
                alignment: Alignment.center,
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey[600]),
              ),
            )
          ),
          Text(
            post.title,
            style: AppText.subtitle(context),
            maxLines: 2, // Giới hạn số dòng để tránh quá dài
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}