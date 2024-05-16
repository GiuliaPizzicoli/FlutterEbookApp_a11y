import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/app.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/category_chip.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/section_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'material_test_app.dart';

void main() {
  /* testWidgets('Accessibility test for title headers', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const MaterialTestApp(
      children: [SectionTitle(title: 'Test')],
    ));

    expect(find.text('Test'), findsOneWidget);
    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  }); */

  testWidgets('Accessibility test for chips', (tester) async {
    final Link link = Link(href: 'Test', title: 'Test');
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialTestApp(
        children: CategoryChip(link: link),
      ),
    );

    /* expect(find.text('Test'), findsOneWidget);

    expect(find.bySemanticsLabel('Test'), findsOneWidget); */

    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    //change light accent to darker shade
    //await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
