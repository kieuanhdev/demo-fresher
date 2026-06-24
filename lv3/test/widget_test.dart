// Basic smoke test: the app builds and renders the splash screen.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:lv3/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await GetStorage.init();
    await tester.pumpWidget(const SdsApp());
    expect(find.byType(SdsApp), findsOneWidget);
  });
}
