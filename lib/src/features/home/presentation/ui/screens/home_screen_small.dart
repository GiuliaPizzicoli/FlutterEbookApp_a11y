import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/accessible_book_list_carousel.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/category_chip.dart';
import 'package:flutter_ebook_app/src/common/presentation/ui/widgets/section_title.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenSmall extends ConsumerStatefulWidget {
  const HomeScreenSmall({super.key});

  @override
  ConsumerState<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  void loadData() {
    ref.read(homeFeedNotifierProvider.notifier).fetch();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeFeedNotifierProvider).maybeWhen(
            orElse: () => loadData(),
            data: (_) => null,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    return Scaffold(
      appBar: context.isSmallScreen
          ? AppBar(
              centerTitle: true,
              title: const Text(
                appName,
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: homeDataState.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const LoadingWidget(),
          data: (feeds) {
            final popular = feeds.popularFeed;
            final recent = feeds.recentFeed;
            return RefreshIndicator(
              onRefresh: () async => loadData(),
              child: ListView(
                children: <Widget>[
                  if (!context.isSmallScreen) const SizedBox(height: 30.0),
                  const SizedBox(height: 20.0),
                  const SectionTitle(title: 'Popular'),
                  FeaturedSection(popular: popular),
                  const SizedBox(height: 20.0),
                  const SectionTitle(title: 'Categories'),
                  const SizedBox(height: 10.0),
                  _GenreSection(popular: popular),
                  const SizedBox(height: 20.0),
                  const SectionTitle(title: 'Recently Added'),
                  const SizedBox(height: 20.0),
                  _NewSection(recent: recent),
                ],
              ),
            );
          },
          error: (_, __) {
            return MyErrorWidget(
              refreshCallBack: () => loadData(),
            );
          },
        ),
      ),
    );
  }
}

class FeaturedSection extends StatelessWidget {
  final CategoryFeed popular;

  const FeaturedSection({super.key, required this.popular});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return mediaQueryData.accessibleNavigation
        ? AccessibleBookListCarousel(link: popular.feed!.link![0])
        : SizedBox(
            height: 240.0,
            child: Center(
              child: ListView.builder(
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                scrollDirection: Axis.horizontal,
                itemCount: popular.feed?.entry?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final Entry entry = popular.feed!.entry![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: BookCard(
                            img: entry.link![1].href!,
                            entry: entry,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}

class _GenreSection extends StatelessWidget {
  final CategoryFeed popular;

  const _GenreSection({required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Link link = popular.feed!.link![index];

            // We don't need the tags from 0-9 because
            // they are not categories
            if (index < 10) {
              return const SizedBox.shrink();
            }

            return CategoryChip(link: link);
          },
        ),
      ),
    );
  }
}

class _NewSection extends StatelessWidget {
  final CategoryFeed recent;

  const _NewSection({required this.recent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Entry entry = recent.feed!.entry![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(entry: entry),
        );
      },
    );
  }
}
