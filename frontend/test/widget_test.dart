import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:latihan_rpl2/register.dart';

void main() {
  testWidgets('RegisterPage loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
