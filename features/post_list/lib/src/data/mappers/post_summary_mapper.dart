import 'package:post_list/src/domain/entities/post_summary.dart';

class PostSummaryMapper {
  static List<PostSummary> fromJsonList(List<dynamic>? jsonList) {
    return jsonList == null ? [] : jsonList.map(fromJson).toList();
  }

  static PostSummary fromJson(dynamic json) => PostSummary(
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );
}
