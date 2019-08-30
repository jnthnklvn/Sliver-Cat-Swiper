import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:silver_app_bar/src/cats/cats_module.dart';
import 'package:silver_app_bar/src/models/cat_model.dart';

import 'cats_repository.dart';

class CatsBloc extends BlocBase {
  final _repo = CatsModule.to.getDependency<CatsRepository>();
  final _catsController = BehaviorSubject<List<CatModel>>.seeded([]);
  final _errorsController = BehaviorSubject<String>();

  var _cats = List<CatModel>();

  Stream<List<CatModel>> get outCats => _catsController.stream;
  Stream<String> get outErrors => _errorsController.stream;

  Future<bool> getCats(int quantidade) async {
    try {
      _cats += await _repo.fetchImages(quantidade);
    } catch (e) {
      _errorsController.sink.add(e.message);
      return false;
    }
    _catsController.sink.add(_cats);
    return true;
  }

  @override
  void dispose() {
    _errorsController.close();
    _catsController.close();
    super.dispose();
  }
}
