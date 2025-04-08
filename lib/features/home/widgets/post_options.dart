import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class PostOptions extends StatelessWidget{
  final VoidCallback? onDownload;

  const PostOptions({
    super.key,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => IntrinsicWidth( 
            child: IntrinsicHeight( 
              child: Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [
                  ListTile(
                    leading: Icon(Icons.download, color: Theme.of(context).colorScheme.onSurface), 
                    title: Text('Tải xuống ảnh này', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    onTap: () {
                      Navigator.pop(context); 
                      if (onDownload != null) { 
                        onDownload!();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          direction: PopoverDirection.bottom, 
          arrowHeight: 10,
          arrowWidth: 20,
        );
      },
      child: Icon(Icons.more_horiz),
    );
  }
}