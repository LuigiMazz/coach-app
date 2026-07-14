import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/exercise.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/exercise_thumbnail.dart';
import '../../widgets/search_field.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _query = '';
  String _category = 'Tutti';
  bool _favoritesOnly = false;

  List<Exercise> get _filtered {
    return MockData.exercises.where((e) {
      final matchesQuery = _query.isEmpty ||
          e.name.toLowerCase().contains(_query.toLowerCase()) ||
          e.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()));
      final matchesCategory = _category == 'Tutti' || e.category == _category;
      final matchesFavorite = !_favoritesOnly || e.isFavorite;
      return matchesQuery && matchesCategory && matchesFavorite;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return SafeArea(
          top: !isDesktop,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 18,
                  isDesktop ? 28 : 14,
                  isDesktop ? 32 : 18,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Libreria Esercizi',
                              style: TextStyle(
                                  fontSize: isDesktop ? 20 : 18, fontWeight: FontWeight.w700)),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/exercises/new'),
                          child: Text(isDesktop ? '+ Nuovo esercizio' : '+ Nuovo',
                              style: TextStyle(fontSize: isDesktop ? 13 : 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isDesktop)
                      Row(
                        children: [
                          Expanded(child: AppSearchField(hint: 'Cerca esercizio…', onChanged: (v) => setState(() => _query = v))),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.tune, size: 16),
                            label: const Text('Filtri'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
                            icon: Icon(_favoritesOnly ? Icons.star : Icons.star_border, size: 16),
                            label: const Text('Preferiti'),
                          ),
                        ],
                      )
                    else
                      AppSearchField(hint: 'Cerca…', onChanged: (v) => setState(() => _query = v)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 32,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final c in ['Tutti', ...exerciseCategories])
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: CategoryChip(
                                label: c,
                                selected: _category == c,
                                onTap: () => setState(() => _category = c),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 32 : 18,
                    0,
                    isDesktop ? 32 : 18,
                    isDesktop ? 32 : 12,
                  ),
                  child: isDesktop ? _buildGrid() : _buildList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      itemCount: _filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, i) => _ExerciseCard(exercise: _filtered[i]),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final ex = _filtered[i];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ExerciseThumbnail(category: ex.category, width: 56, height: 56),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ex.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(ex.category,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ExerciseThumbnail(
              category: exercise.category,
              width: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(exercise.name,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Icon(
                      exercise.isFavorite ? Icons.star : Icons.star_border,
                      size: 16,
                      color: exercise.isFavorite ? AppColors.accent : AppColors.textTertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(exercise.category,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                if (exercise.tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, runSpacing: 6, children: [for (final t in exercise.tags) AppTag(label: t)]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
