@Tags(const ['aot'])
@TestOn('browser')
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

class AppPO {
  @ByTagName('h1')
  PageLoaderElement _title;

  @FirstByCss('div')
  PageLoaderElement _id; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement _heroName; // e.g. 'Mr Freeze details!'

  @ByTagName('input')
  PageLoaderElement _input;

  Future<String> get title => _title.visibleText;

  Future<int> get heroId async {
    final idAsString = (await _id.visibleText).split(' ')[1];
    return int.parse(idAsString, onError: (_) => -1);
  }

  Future<String> get heroName async {
    final text = await _heroName.visibleText;
    return text.substring(0, text.lastIndexOf(' '));
  }

  Future type(String s) => _input.type(s);
}

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });

  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });

  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
}
