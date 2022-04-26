import 'package:chapturn/domain/entities/entities.dart';
import 'package:chapturn/domain/repositories/category_repository.dart';
import 'package:chapturn/domain/repositories/novel_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/failure.dart';

class ChangeNovelCategories {
  ChangeNovelCategories(
      {required this.categoryRepository, required this.novelLocalRepository});

  final CategoryRepository categoryRepository;
  final NovelLocalRepository novelLocalRepository;

  Future<Either<Failure, bool>> execute(
    NovelEntity novel,
    Map<CategoryEntity, bool> categories,
  ) async {
    await categoryRepository.changeNovelCategories(novel, categories);

    final favourite = categories.values.firstWhere(
      (selected) => selected,
      orElse: () => false,
    );

    await novelLocalRepository.setFavourite(novel.id, favourite);

    return Right(favourite);
  }
}
