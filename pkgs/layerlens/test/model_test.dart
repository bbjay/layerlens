import 'package:layerlens/src/analyzer.dart';
import 'package:test/test.dart';

void main() {
  test('SourceNode returns correct relative paths', () async {
    final nodes = Analyzer({
      'a/aa': {},
      'a/ab': {},
      'a/sub/asa': {},
      'b/bb': {},
    }).nodes;
    expect(nodes['a']!.relativePathTo(nodes['a']!), equals(['.']));
    expect(nodes['a']!.relativePathTo(nodes['b']!), equals(['..', 'b']));
    expect(nodes['a']!.relativePathTo(nodes['a/ab']!), equals(['ab']));
    expect(nodes['a']!.relativePathTo(nodes['a/sub/asa']!), equals(['sub', 'asa']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a']!), equals(['.']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/aa']!), equals(['aa']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/ab']!), equals(['ab']));
    expect(nodes['a/aa']!.relativePathTo(nodes['a/sub/asa']!), equals(['sub', 'asa']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['a/aa']!), equals(['..', 'aa']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['b']!), equals(['..', '..', 'b']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['a']!), equals(['..', '.']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['a/sub']!), equals(['.']));
    expect(nodes['a/sub/asa']!.relativePathTo(nodes['b/bb']!), equals(['..', '..', 'b', 'bb']));
    expect(nodes['a/aa']!.relativePathTo(nodes['b/bb']!), equals(['..', 'b', 'bb']));
    expect(nodes['b/bb']!.relativePathTo(nodes['a/sub/asa']!), equals(['..', 'a', 'sub', 'asa']));
  });

  test('SourceNode returns correct relative paths for the root folder', () async {
    // The root folder is not in `nodes`, and its path is '.', which is not a
    // folder to walk out of. Reached by `layerlens --package <name>`, where
    // bin and lib are siblings in the root.
    final analyzer = Analyzer({
      'bin/main': {'lib/main'},
      'lib/main': {},
    });
    final root = analyzer.root;
    final nodes = analyzer.nodes;

    expect(root.relativePathTo(root), equals(['.']));
    expect(root.relativePathTo(nodes['lib']!), equals(['lib']));
    expect(root.relativePathTo(nodes['lib/main']!), equals(['lib', 'main']));
    expect(nodes['lib']!.relativePathTo(root), equals(['..', '.']));
    expect(nodes['lib/main']!.relativePathTo(root), equals(['..', '.']));
    expect(nodes['bin/main']!.relativePathTo(nodes['lib/main']!), equals(['..', 'lib', 'main']));
  });
}
