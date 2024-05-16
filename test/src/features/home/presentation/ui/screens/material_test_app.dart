import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:google_fonts/google_fonts.dart';

class MaterialTestApp extends StatelessWidget {
  final Widget children;

  const MaterialTestApp({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    /* return MaterialApp(
      theme: themeData(lightTheme),
      home: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: 40,
          height: 40,
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  } */
    return MaterialApp(
      theme: themeData(lightTheme),
      home: Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: 40,
          height: 40,
          child: children,
        ),
      ),
    );
  }
}

ThemeData themeData(ThemeData theme) {
  return theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      secondary: lightAccent,
    ),
  );
}
