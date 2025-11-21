import 'package:flutter_test/flutter_test.dart';
import 'package:onlinemandi/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    expect(find.text('Home Page'), findsOneWidget);
  });
}

