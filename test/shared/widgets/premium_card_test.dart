import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_musica/shared/widgets/premium_card.dart';
import 'package:app_musica/core/theme/app_theme.dart';

void main() {
  group('PremiumCard Widget Tests', () {
    testWidgets('renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies custom width and height', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              width: 200,
              height: 100,
              child: Text('Sized Card'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(container.constraints?.maxWidth, equals(200));
      expect(container.constraints?.maxHeight, equals(100));
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Tappable Card'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('PremiumButton Widget Tests', () {
    testWidgets('displays text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              text: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              text: 'Press Me',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Press Me'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              text: 'With Icon',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('does not call onPressed when isLoading',
        (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumButton(
              text: 'Loading Button',
              isLoading: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PremiumButton));
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });
  });

  group('PremiumOutlinedButton Widget Tests', () {
    testWidgets('displays text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumOutlinedButton(
              text: 'Outlined',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumOutlinedButton(
              text: 'With Icon',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumOutlinedButton(
              text: 'Press',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Press'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });

  group('PremiumChip Widget Tests', () {
    testWidgets('displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumChip(label: 'Chip Label'),
          ),
        ),
      );

      expect(find.text('Chip Label'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumChip(
              label: 'Chip',
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows selected state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PremiumChip(
                  label: 'Selected',
                  selected: true,
                ),
                PremiumChip(
                  label: 'Not Selected',
                  selected: false,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('Not Selected'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumChip(
              label: 'Tappable',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('PremiumBadge Widget Tests', () {
    testWidgets('displays text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumBadge(text: 'NEW'),
          ),
        ),
      );

      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('applies custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumBadge(
              text: 'PRO',
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      expect(find.text('PRO'), findsOneWidget);
    });
  });

  group('EmptyState Widget Tests', () {
    testWidgets('displays icon, title and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No Items',
              subtitle: 'Add some items to get started',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('Add some items to get started'), findsOneWidget);
    });

    testWidgets('displays action button when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.add,
              title: 'Empty',
              actionText: 'Add Item',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      expect(find.byType(PremiumButton), findsOneWidget);
    });

    testWidgets('calls onAction when button is tapped',
        (WidgetTester tester) async {
      var actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.add,
              title: 'Empty',
              actionText: 'Add',
              onAction: () {
                actionCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(actionCalled, isTrue);
    });

    testWidgets('does not display action button without actionText',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'Empty',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.byType(PremiumButton), findsNothing);
    });
  });

  group('GradientCard Widget Tests', () {
    testWidgets('renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientCard(
              gradientColors: [Colors.blue, Colors.purple],
              child: Text('Gradient Content'),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Content'), findsOneWidget);
    });

    testWidgets('applies custom dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientCard(
              gradientColors: [Colors.blue, Colors.purple],
              width: 150,
              height: 200,
              child: Text('Sized'),
            ),
          ),
        ),
      );

      expect(find.text('Sized'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientCard(
              gradientColors: const [Colors.blue, Colors.purple],
              onTap: () {
                tapped = true;
              },
              child: const Text('Tappable'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tappable'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
