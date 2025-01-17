import 'dart:math' as math;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nacht/shared/shared.dart';
import 'package:nacht/core/core.dart';

import '../services/services.dart';

final categoriesPageProvider =
    StateNotifierProvider.autoDispose<CategoriesNotifier, List<CategoryData>>(
  (ref) {
    final categoriesNotifier = CategoriesNotifier(
      ref: ref,
      state: [],
      addCategory: ref.watch(addCategoryProvider),
      editCategory: ref.watch(editCategoryProvider),
      removeCategory: ref.watch(removeCategoryProvider),
      updateCategoriesIndex: ref.watch(updateCategoriesIndexProvider),
    );

    categoriesNotifier.reload();

    return categoriesNotifier;
  },
  name: 'CategoriesProvider',
);

class CategoriesNotifier extends StateNotifier<List<CategoryData>>
    with LoggerMixin {
  CategoriesNotifier({
    required List<CategoryData> state,
    required Ref ref,
    required AddCategory addCategory,
    required EditCategory editCategory,
    required RemoveCategory removeCategory,
    required UpdateCategoriesIndex updateCategoriesIndex,
  })  : _ref = ref,
        _addCategory = addCategory,
        _editCategory = editCategory,
        _removeCategory = removeCategory,
        _updateCategoriesIndex = updateCategoriesIndex,
        super(state);

  final Ref _ref;

  final AddCategory _addCategory;
  final EditCategory _editCategory;
  final RemoveCategory _removeCategory;
  final UpdateCategoriesIndex _updateCategoriesIndex;

  Future<void> reload() async {
    final data = _ref
        .read(categoriesProvider)
        .where((element) => !element.isDefault)
        .toList();

    state = _sort(data);
  }

  Future<void> add(String name) async {
    if (name.isEmpty) {
      _ref
          .read(messageServiceProvider)
          .showText('Category name cannot be empty.');
      return;
    }

    final result = await _addCategory.execute(_highestIndex() + 1, name);

    result.fold(
      (failure) {
        log.warning(failure);
      },
      (data) {
        state = _sort([...state, data]);
      },
    );
  }

  Future<void> edit(CategoryData category, String name) async {
    if (name.isEmpty) {
      _ref
          .read(messageServiceProvider)
          .showText('Category name cannot be empty.');
      return;
    } else if (category.name == name) {
      return;
    }

    final newCategory = category.copyWith(name: name);

    final result = await _editCategory.execute(newCategory);

    result.fold((failure) {
      log.warning(failure);
    }, (data) {
      state = [
        ...state.sublist(0, newCategory.index - 1),
        newCategory,
        ...state.sublist(newCategory.index),
      ];
    });
  }

  Future<void> remove(Set<int> ids) async {
    final oldState = state;
    state = [
      for (final category in state)
        if (!ids.contains(category.id)) category
    ];

    _ref.read(messageServiceProvider).showUndo(
      '${ids.length} categories removed',
      onUndo: () {
        log.fine('undid ${ids.length} category removes');
        state = oldState;
      },
      orElse: () async {
        log.fine('commited ${ids.length} category removes');
        final result = await _removeCategory.execute(ids);

        result.fold(
          (failure) {
            log.warning(failure);
            state = oldState;
          },
          (data) => {},
        );
      },
    );
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    assert(oldIndex != newIndex);

    final category = state[oldIndex];

    final newState = [
      ...state.sublist(0, oldIndex),
      ...state.sublist(oldIndex + 1, state.length),
    ];

    if (oldIndex > newIndex) {
      newState.insert(newIndex, category);
    } else {
      newState.insert(newIndex - 1, category);
    }

    final oldState = state;
    state = newState;

    final changed = <CategoryData>[];
    for (var i = 0; i < newState.length; i++) {
      final category = newState[i];
      if (category.index != i + 1) {
        newState[i] = category.copyWith(index: i + 1);
        changed.add(newState[i]);
      }
    }

    final failure = await _updateCategoriesIndex.execute(changed);
    if (failure != null) {
      log.warning(failure);
      state = oldState;
    }
  }

  int _highestIndex() {
    if (state.isEmpty) {
      return 0;
    }

    return state.map((e) => e.index).reduce(math.max);
  }

  List<CategoryData> _sort(List<CategoryData> data) {
    return data..sort((a, b) => a.index.compareTo(b.index));
  }
}
