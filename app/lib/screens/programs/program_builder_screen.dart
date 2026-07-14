import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/exercise.dart';
import '../../models/program.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/exercise_thumbnail.dart';
import '../../widgets/search_field.dart';

class ProgramBuilderScreen extends StatefulWidget {
  final String programId;

  const ProgramBuilderScreen({super.key, required this.programId});

  @override
  State<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends State<ProgramBuilderScreen> {
  late Program _program;
  late List<_MutableBlock> _blocks;

  @override
  void initState() {
    super.initState();
    _program = MockData.programs.firstWhere(
      (p) => p.id == widget.programId,
      orElse: () => MockData.programs.first,
    );
    _blocks = _program.blocks
        .map((b) => _MutableBlock(b.label, b.items.toList()))
        .toList();
  }

  void _addToBlock(int blockIndex, Exercise exercise) {
    setState(() {
      _blocks[blockIndex].items.add(
            ProgramExerciseItem(
              exerciseName: exercise.name,
              sets: exercise.sets == 0 ? 3 : exercise.sets,
              reps: exercise.reps,
              rest: exercise.rest.isEmpty ? '60"' : exercise.rest,
            ),
          );
    });
  }

  Future<void> _pickExerciseForBlock(int blockIndex) async {
    final picked = await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _ExercisePickerSheet(),
    );
    if (picked != null) _addToBlock(blockIndex, picked);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(_program.name),
                ),
          body: SafeArea(
            top: !isDesktop,
            child: isDesktop ? _buildDesktop() : _buildMobile(),
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_program.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          Text('Settimana ${_program.currentWeek} di ${_program.durationWeeks}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('Salva template')),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      for (var i = 0; i < _blocks.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _BlockCard(
                            block: _blocks[i],
                            onAccept: (ex) => _addToBlock(i, ex),
                            onAddTap: () => _pickExerciseForBlock(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 300,
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
          child: const _LibrarySidebar(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _blocks.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BlockCard(
                block: _blocks[i],
                onAccept: (ex) => _addToBlock(i, ex),
                onAddTap: () => _pickExerciseForBlock(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _MutableBlock {
  final String label;
  final List<ProgramExerciseItem> items;

  _MutableBlock(this.label, this.items);
}

class _BlockCard extends StatelessWidget {
  final _MutableBlock block;
  final ValueChanged<Exercise> onAccept;
  final VoidCallback onAddTap;

  const _BlockCard({required this.block, required this.onAccept, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return DragTarget<Exercise>(
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final highlighted = candidateData.isNotEmpty;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: highlighted ? AppColors.accent : AppColors.border, width: highlighted ? 1.5 : 1),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(block.label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              for (final item in block.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.drag_indicator, size: 16, color: AppColors.textTertiary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(item.exerciseName, style: const TextStyle(fontSize: 13)),
                        ),
                        Text(item.label,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              InkWell(
                onTap: onAddTap,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('+ aggiungi esercizio',
                      style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LibrarySidebar extends StatefulWidget {
  const _LibrarySidebar();

  @override
  State<_LibrarySidebar> createState() => _LibrarySidebarState();
}

class _LibrarySidebarState extends State<_LibrarySidebar> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = MockData.exercises
        .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Libreria — trascina qui →',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        AppSearchField(hint: 'Cerca…', onChanged: (v) => setState(() => _query = v)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final ex = results[i];
              return Draggable<Exercise>(
                data: ex,
                feedback: Material(
                  color: Colors.transparent,
                  child: _LibraryChip(exercise: ex, dragging: true),
                ),
                childWhenDragging: Opacity(opacity: 0.4, child: _LibraryChip(exercise: ex)),
                child: _LibraryChip(exercise: ex),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LibraryChip extends StatelessWidget {
  final Exercise exercise;
  final bool dragging;

  const _LibraryChip({required this.exercise, this.dragging = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dragging ? 240 : null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        boxShadow: dragging
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8)]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExerciseThumbnail(category: exercise.category, width: 26, height: 26, borderRadius: BorderRadius.circular(5)),
          const SizedBox(width: 10),
          Flexible(child: Text(exercise.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

class _ExercisePickerSheet extends StatefulWidget {
  const _ExercisePickerSheet();

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = MockData.exercises
        .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Aggiungi esercizio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              AppSearchField(hint: 'Cerca esercizio…', onChanged: (v) => setState(() => _query = v)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final ex = results[i];
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(ex),
                      contentPadding: EdgeInsets.zero,
                      leading: ExerciseThumbnail(category: ex.category, width: 44, height: 44),
                      title: Text(ex.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(ex.category, style: const TextStyle(fontSize: 11)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
