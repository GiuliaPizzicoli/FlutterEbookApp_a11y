import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/presentation/helpers/semantics_helpers.dart';
import 'package:flutter_ebook_app/src/features/explore/presentation/ui/screens/components/section_header.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessibleBookListCarousel extends ConsumerStatefulWidget {
  final Link link;
  final bool? hasHeader;

  const AccessibleBookListCarousel({required this.link, this.hasHeader});

  @override
  ConsumerState<AccessibleBookListCarousel> createState() =>
      SAccessibleBookListCarouselState();
}

class SAccessibleBookListCarouselState
    extends ConsumerState<AccessibleBookListCarousel>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bookCount = ValueNotifier<int>(0);
  late PageController _pageController;
  late int currentPage;

  void _fetch() {
    ref.read(genreFeedNotifierProvider(widget.link.href!).notifier).fetch();
  }

  @override
  void initState() {
    _pageController = PageController();
    currentPage = 0;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _bookCount,
          builder: (context, bookCount, _) {
            if (widget.hasHeader == true) {
              return SectionHeader(
                link: widget.link,
                hideSeeAll: bookCount < 10,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Semantics(
              label: 'Precedente',
              child: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage == 0
                    ? null
                    : () {
                        _pageController.animateTo(
                          _pageController.offset - 200.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 220,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: ref
                      .watch(genreFeedNotifierProvider(widget.link.href!))
                      .maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        loading: () => const LoadingWidget(),
                        data: (data) {
                          final books = data.books;
                          if (_bookCount.value == 0) {
                            _bookCount.value = books.length;
                          }
                          return PageView.builder(
                            controller: _pageController,
                            itemCount: books.length,
                            onPageChanged: (i) {
                              SemanticsService.announce(
                                getSemanticLabel(books[i]),
                                TextDirection.ltr,
                              );
                              setState(() {
                                currentPage = i;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final Entry entry = books[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 10.0,
                                ),
                                child: MergeSemantics(
                                  child: Column(
                                    children: [
                                      BookCard(
                                        img: entry.link![1].href!,
                                        entry: entry,
                                      ),
                                      Text(entry.title?.t ?? ''),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (_, __) {
                          return MyErrorWidget(
                            refreshCallBack: () {
                              _fetch();
                            },
                          );
                        },
                      ),
                ),
              ),
            ),
            Semantics(
              label: 'Successivo',
              child: IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  _pageController.animateTo(
                    _pageController.offset + 200.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
