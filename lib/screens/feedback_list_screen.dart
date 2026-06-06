import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/feedback_enums.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import '../providers/feedback_provider.dart';
import '../widgets/feedback_card.dart';
import '../widgets/stat_card.dart';

class FeedbackListScreen extends ConsumerWidget {
  const FeedbackListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final sourceStats = ref.watch(appSourceStatsProvider);
    final filtered = ref.watch(filteredFeedbackProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final selectedSource = ref.watch(selectedSourceFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Vyapari Admin'),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle theme',
            onPressed: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authNotifierProvider).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(feedbackStreamProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: stats.when(
                  data: (s) => Row(
                    children: [
                      for (var i = 0;
                          i < FeedbackStatus.values.length;
                          i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            label: FeedbackStatus.values[i].label,
                            count: s[FeedbackStatus.values[i]] ?? 0,
                            color: FeedbackStatus.values[i].color,
                          ),
                        ),
                      ],
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 72,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, st) => const SizedBox.shrink(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: sourceStats.when(
                  data: (s) => Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: AppSource.userApp.label,
                          count: s[AppSource.userApp] ?? 0,
                          color: AppSource.userApp.color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          label: AppSource.vendorApp.label,
                          count: s[AppSource.vendorApp] ?? 0,
                          color: AppSource.vendorApp.color,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (err, st) => const SizedBox.shrink(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <FeedbackType?>[null, ...FeedbackType.values]
                        .map((f) {
                      final isSelected = selectedFilter == f;
                      final onSurface = Theme.of(context).colorScheme.onSurface;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            f?.label ?? 'All',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : onSurface.withValues(alpha: 0.7),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) =>
                              ref.read(selectedFilterProvider.notifier).state = f,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <AppSource?>[null, AppSource.userApp, AppSource.vendorApp]
                        .map((src) {
                      final isSelected = selectedSource == src;
                      final onSurface = Theme.of(context).colorScheme.onSurface;
                      final primary = Theme.of(context).colorScheme.primary;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: src != null
                              ? Icon(src.icon,
                                  size: 14,
                                  color: isSelected ? Colors.white : src.color)
                              : null,
                          label: Text(
                            src?.label ?? 'All Apps',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : onSurface.withValues(alpha: 0.7),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: src?.color ?? primary,
                          onSelected: (_) =>
                              ref.read(selectedSourceFilterProvider.notifier).state = src,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            filtered.when(
              data: (items) {
                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No feedback found.',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: FeedbackCard(
                        item: items[i],
                        onTap: () => context.go(
                          '/detail/${items[i].id}',
                          extra: items[i],
                        ),
                      ),
                    ),
                    childCount: items.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: _FeedbackErrorMessage(error: e),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
          ],
        ),
      ),
    );
  }
}

class _FeedbackErrorMessage extends StatelessWidget {
  final Object error;

  const _FeedbackErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    final message = '$error'.contains('permission-denied')
        ? 'You are signed in, but this account does not have permission to read feedback.'
        : 'Could not load feedback.';
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, color: Colors.redAccent, size: 36),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurface, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: onSurface.withValues(alpha: 0.54), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
