import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.link,
  });

  final Link link;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            onTap: () {
              final route = GenreRoute(
                title: '${link.title}',
                url: link.href!,
              );
              if (context.isLargeScreen) {
                context.router.replace(route);
              } else {
                context.router.push(route);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '${link.title}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
