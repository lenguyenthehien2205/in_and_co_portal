import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';

class TrendingController extends GetxController{
  var trendingData = <Map<String, String>>[].obs;
  PostService postService = PostService();

  @override
  void onInit() {
    super.onInit();
    fetchTrendingData();
  }

  void fetchTrendingData() async {
    var fetchedData = await postService.getTopLabelsWithImage();
    trendingData.assignAll(fetchedData); // Gán danh sách dữ liệu
  }
}