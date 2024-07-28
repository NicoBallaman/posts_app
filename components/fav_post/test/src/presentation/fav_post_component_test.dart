import 'package:fav_post/src/presentation/fav_post_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:core/core.dart';

@GenerateMocks([ServiceBus])
import 'fav_post_component_test.mocks.dart';

void main() {
  group('FavPostComponent Tests:', () {
    late MockServiceBus mockServiceBus;
    const int postId = 1;

    setUp(() {
      mockServiceBus = MockServiceBus();
    });

    testWidgets('Should toggle favorite icon when pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavPostComponent(
              postId: 1,
              serviceBus: mockServiceBus,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    });

    testWidgets('Should publish event when favorite status changes', (WidgetTester tester) async {
      when(mockServiceBus.publish(data: true, event: anyNamed('event'))).thenAnswer((_) => Future.value());
      when(mockServiceBus.publish(data: false, event: anyNamed('event'))).thenAnswer((_) => Future.value());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavPostComponent(
              postId: postId,
              serviceBus: mockServiceBus,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(mockServiceBus.publish(data: true, event: anyNamed('event'))).called(1);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(mockServiceBus.publish(data: false, event: anyNamed('event'))).called(1);
    });
  });
}
