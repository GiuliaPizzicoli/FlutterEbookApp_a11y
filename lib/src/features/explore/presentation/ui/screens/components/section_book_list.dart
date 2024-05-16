import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/explore/presentation/ui/screens/components/section_header.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionBookList extends ConsumerStatefulWidget {
  final Link link;

  const SectionBookList({required this.link});

  @override
  ConsumerState<SectionBookList> createState() => SectionBookListState();
}

class SectionBookListState extends ConsumerState<SectionBookList>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bookCount = ValueNotifier<int>(0);

  void _fetch() {
    ref.read(genreFeedNotifierProvider(widget.link.href!).notifier).fetch();
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
            return SectionHeader(
              link: widget.link,
              hideSeeAll: bookCount < 10,
            );
          },
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 200,
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
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final Entry entry = books[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 10.0,
                          ),
                          child:
                              BookCard(img: entry.link![1].href!, entry: entry),
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
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
