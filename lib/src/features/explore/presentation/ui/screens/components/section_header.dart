import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

class SectionHeader extends StatelessWidget {
  final Link link;
  final bool hideSeeAll;

  const SectionHeader({required this.link, this.hideSeeAll = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                '${link.title}',
                semanticsLabel: 'Categoria: ${link.title}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!hideSeeAll)
              GestureDetector(
                onTap: () {
                  context.router.push(
                    GenreRoute(title: '${link.title}', url: link.href!),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
