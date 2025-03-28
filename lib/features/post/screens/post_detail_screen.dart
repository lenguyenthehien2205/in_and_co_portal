import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostDetailScreen extends StatelessWidget{
  PostDetailScreen({super.key});

  
  @override
  Widget build(context){
    final state = GoRouterState.of(context);
    final data = state.extra as Map<String, dynamic>?;
    return Text('Post Detail Screen ${data?['id'] ?? 'Unknown'} ${data?['authorId'] ?? 'Unknown'}');
  }
}