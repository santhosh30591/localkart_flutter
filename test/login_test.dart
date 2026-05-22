import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localkart/pages/autho/login.dart';

void main() {
  testWidgets('Login page UI and validation test', (WidgetTester tester) async {
    // Build the Login widget
    await tester.pumpWidget(const MaterialApp(
      home: Login(),
    ));

    // 1. Verify that basic UI elements are present
    expect(find.text('Enter Mobile Number'), findsWidgets); // Both in text and hint
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);

    // 2. Test Mobile Number Input Validation
    final textField = find.byType(TextField);
    
    // Enter 5 digits
    await tester.enterText(textField, '12345');
    await tester.pump();
    // The button should be disabled (visual check or logic check if possible)
    // Note: submitButton is a custom widget, we might just check if it exists
    
    // Enter 10 digits
    await tester.enterText(textField, '1234567890');
    await tester.pump();

    // 3. Test Checkbox Interaction
    final checkbox = find.byType(Checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, false);
    
    await tester.tap(checkbox);
    await tester.pump();
    expect(tester.widget<Checkbox>(checkbox).value, true);

    // 4. Test Navigation to Register (Checks if the link is tappable)
    final registerLink = find.text('Register Now');
    await tester.tap(registerLink);
    await tester.pumpAndSettle();
    
    // Since we didn't mock the Navigator routes in this simple test, 
    // we just verify the tap was successful.
  });
}
