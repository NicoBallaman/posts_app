import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:core/core.dart';
import 'package:post_list/src/data/repositories/post_remote_repository.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_input.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';

@GenerateMocks([BaseUrl, HttpManager])
import 'post_remote_repository_test.mocks.dart';

void main() {
  group('PostRemoteRepository Tests', () {
    late MockBaseUrl mockBaseUrl;
    late MockHttpManager mockHttpManager;
    late PostRemoteRepository repository;

    const baseUrlValue = 'https://fakeapi.com';
    final pagination = Pagination(pageNumber: 0, pageSize: 10, isFinal: false);
    final input = GetAllPostsInput(pagination: pagination);
    final post = {'id': 1, 'title': 'Post 1', 'body': ''};
    final successfulRespponseWithPosts = HttpResponse(data: [post], statusCode: 200);
    final successfulRespponseWithPoutosts = HttpResponse(data: [], statusCode: 200);
    final errorRespponse = HttpResponse(data: null, statusCode: 400, error: 'Bad Request');
    final unknownErrorRespponse = HttpResponse(data: null, statusCode: 500);

    setUp(() {
      mockBaseUrl = MockBaseUrl();
      mockHttpManager = MockHttpManager();
      repository = PostRemoteRepository(baseUrl: mockBaseUrl, httpManager: mockHttpManager);
      when(mockBaseUrl.value).thenReturn(baseUrlValue);
    });

    test('getAll should return posts when the API call is successful and return posts', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => successfulRespponseWithPosts);

      final result = await repository.getAll(input);

      expect(result.data, isA<List<PostSummary>>());
      expect(result.data[0].id, post['id']);
      expect(result.data[0].title, post['title']);
      expect(result.data[0].title, post['title']);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/posts?_start=0&_limit=10')).called(1);
    });

    test('getAll should return error when the API call fails', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => errorRespponse);

      final result = await repository.getAll(input);

      expect(result.error, errorRespponse.error);
      expect(result.data, []);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/posts?_start=0&_limit=10')).called(1);
    });

    test('getAll should return unknown error when API call fails without specific error', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => unknownErrorRespponse);

      final result = await repository.getAll(input);

      expect(result.error, 'Unknown error');
      expect(result.data, []);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/posts?_start=0&_limit=10')).called(1);
    });

    test('getAll should use correct pagination parameters', () async {
      final paginationWithOffset = Pagination(pageNumber: 2, pageSize: 15, isFinal: false);
      final inputWithOffset = GetAllPostsInput(pagination: paginationWithOffset);

      when(mockHttpManager.get(any)).thenAnswer((_) async => successfulRespponseWithPoutosts);

      await repository.getAll(inputWithOffset);

      verify(mockHttpManager.get('$baseUrlValue/posts?_start=30&_limit=15')).called(1);
    });
  });
}
