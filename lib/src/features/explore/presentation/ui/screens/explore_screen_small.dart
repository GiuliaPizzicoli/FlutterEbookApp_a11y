import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/accessible_book_list_carousel.dart';
import 'package:flutter_ebook_app/src/features/explore/presentation/ui/screens/components/section_book_list.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ExploreScreenSmall extends ConsumerStatefulWidget {
  const ExploreScreenSmall({super.key});

  @override
  ConsumerState<ExploreScreenSmall> createState() => _ExploreScreenSmallState();
}

class _ExploreScreenSmallState extends ConsumerState<ExploreScreenSmall>
    with AutomaticKeepAliveClientMixin {
  void loadData() {
    ref.read(homeFeedNotifierProvider.notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    super.build(context);
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    return Scaffold(
      appBar: context.isSmallScreen
          ? AppBar(centerTitle: true, title: const Text('Explore'))
          : null,
      body: homeDataState.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        loading: () => const LoadingWidget(),
        data: (feeds) {
          final popular = feeds.popularFeed;
          return ListView.builder(
            itemCount: popular.feed?.link?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final Link link = popular.feed!.link![index];
              if (!context.isSmallScreen && index == 0) {
                return const SizedBox(height: 30.0);
              }
              // We don't need the tags from 0-9 because
              // they are not categories
              if (index < 10) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: mediaQueryData.accessibleNavigation
                    ? AccessibleBookListCarousel(
                        link: link,
                        hasHeader: true,
                      )
                    : SectionBookList(link: link),
              );
            },
          );
        },
        error: (_, __) {
          return MyErrorWidget(
            refreshCallBack: () => loadData(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.animateToPage(
                _currentPage - 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Container(
                color: Colors.red,
                child: const Center(
                  child: Text(
                    'Item 1',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Item 2',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'Item 3',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.orange,
                child: const Center(
                  child: Text(
                    'Item 4',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            if (_currentPage < 3) {
              _pageController.animateToPage(
                _currentPage + 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ],
    );
  }
}
