import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'cats_bloc.dart';
import 'cats_page.dart';
import 'cats_repository.dart';

class CatsModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CatsBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => CatsRepository()),
      ];

  @override
  Widget get view => CatsPage();

  static Inject get to => Inject<CatsModule>.of();
}
