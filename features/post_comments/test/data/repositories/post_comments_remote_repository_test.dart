import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:core/core.dart';
import 'package:post_comments/src/data/repositories/post_comments_repository.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_input.dart';

@GenerateMocks([BaseUrl, HttpManager])
import 'post_comments_remote_repository_test.mocks.dart';

void main() {
  group('PostCommentsRemoteRepository Tests', () {
    late MockBaseUrl mockBaseUrl;
    late MockHttpManager mockHttpManager;
    late PostCommentsRemoteRepository repository;

    const baseUrlValue = 'https://fakeapi.com';
    const postId = 1;
    final pagination = Pagination(pageNumber: 0, pageSize: 10, isFinal: false);
    final input = GetAllCommentsInput(postId: postId, pagination: pagination);
    final comment = {'id': 1, 'postId': postId, 'name': 'Post 1', 'email': '', 'body': ''};
    final successfulRespponseWithComments = HttpResponse(data: [comment], statusCode: 200);
    final successfulRespponseWithPoutComments = HttpResponse(data: [], statusCode: 200);
    final errorRespponse = HttpResponse(data: null, statusCode: 400, error: 'Bad Request');
    final unknownErrorRespponse = HttpResponse(data: null, statusCode: 500);

    setUp(() {
      mockBaseUrl = MockBaseUrl();
      mockHttpManager = MockHttpManager();
      repository = PostCommentsRemoteRepository(baseUrl: mockBaseUrl, httpManager: mockHttpManager);
      when(mockBaseUrl.value).thenReturn(baseUrlValue);
    });

    test('getAll should return posts when the API call is successful and return posts', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => successfulRespponseWithComments);

      final result = await repository.getAll(input);

      expect(result.data, isA<List<PostComment>>());
      expect(result.data[0].id, comment['id']);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/comments?postId=${input.postId}&_start=0&_limit=10')).called(1);
    });

    test('getAll should return error when the API call fails', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => errorRespponse);

      final result = await repository.getAll(input);

      expect(result.error, errorRespponse.error);
      expect(result.data, []);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/comments?postId=${input.postId}&_start=0&_limit=10')).called(1);
    });

    test('getAll should return unknown error when API call fails without specific error', () async {
      when(mockHttpManager.get(any)).thenAnswer((_) async => unknownErrorRespponse);

      final result = await repository.getAll(input);

      expect(result.error, 'Unknown error');
      expect(result.data, []);

      verify(mockBaseUrl.value).called(1);
      verify(mockHttpManager.get('$baseUrlValue/comments?postId=${input.postId}&_start=0&_limit=10')).called(1);
    });

    test('getAll should use correct pagination parameters', () async {
      final paginationWithOffset = Pagination(pageNumber: 2, pageSize: 15, isFinal: false);
      final inputWithOffset = GetAllCommentsInput(postId: postId, pagination: paginationWithOffset);

      when(mockHttpManager.get(any)).thenAnswer((_) async => successfulRespponseWithPoutComments);

      await repository.getAll(inputWithOffset);

      verify(mockHttpManager.get('$baseUrlValue/comments?postId=${input.postId}&_start=30&_limit=15')).called(1);
    });
  });
}
