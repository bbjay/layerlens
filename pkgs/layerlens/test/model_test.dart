import 'package:layerlens/src/analyzer.dart';
import 'package:test/test.dart';

void main() {
  test('Correct relative paths', () async {
    final nodes = Analyzer({
      'a/aa': {},
      'a/ab': {},
      'a/sub/asa': {},
      'b/bb': {},
    }).nodes;
    expect(nodes['a']!.relativePathTo(nodes['a']!), equals(['a']));
    expect(nodes['a']!.relativePathTo(nodes['a/ab']!), equals(['ab']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/aa']!), equals(['aa']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/ab']!), equals(['ab']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/sub/asa']!), equals(['sub', 'asa']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['a/aa']!), equals(['..', 'aa']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['b/bb']!), equals(['..', '..', 'b', 'bb']));
    expect(nodes['a/aa']!.relativePathTo(nodes['b/bb']!), equals(['..', 'b', 'bb']));
    expect(nodes['b/bb']!.relativePathTo(nodes['a/sub/asa']!), equals(['..', 'a', 'sub', 'asa']));
  });
}
