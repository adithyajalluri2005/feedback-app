import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/feedback_provider.dart';
import '../widgets/feedback_card.dart';
import '../widgets/stat_card.dart';

class FeedbackListScreen extends ConsumerWidget {
  const FeedbackListScreen({super.key});

  static const _filters = ['all', 'bug', 'feature', 'general'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final filtered = ref.watch(filteredFeedbackProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Vyapari Admin'),
        actions: [
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
                      Expanded(
                        child: StatCard(
                          label: 'New',
                          count: s['new'] ?? 0,
                          color: const Color(0xFFE94560),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          label: 'Reviewed',
                          count: s['reviewed'] ?? 0,
                          color: const Color(0xFF533483),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          label: 'Resolved',
                          count: s['resolved'] ?? 0,
                          color: const Color(0xFF2ECC71),
                        ),
                      ),
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
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final isSelected = selectedFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            f == 'all' ? 'All' : _capitalize(f),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
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
            filtered.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No feedback found.',
                        style: TextStyle(color: Colors.white38),
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
                child: Center(
                  child: Text(
                    'Error: $e',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
