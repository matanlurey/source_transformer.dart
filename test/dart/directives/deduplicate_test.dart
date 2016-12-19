import 'package:source_span/source_span.dart';
import 'package:source_transformer/src/dart/directives.dart';
import 'package:test/test.dart';

void main() {
  test('should deduplicate directives', () async {
    final file = new SourceFile(r'''
      import 'package:bar/bar.dart';
      import 'package:bar/bar.dart';
      import 'package:bar/bar.dart' as bar;
      import 'package:bar/bar.dart' as bar;
      import 'package:bar/bar.dart' show bar;
      import 'package:bar/bar.dart' show bar;
      import 'package:bar/bar.dart' hide bar;
      import 'package:bar/bar.dart' hide bar;
      export 'package:bar/bar.dart';
      export 'package:bar/bar.dart';
      export 'package:bar/bar.dart' show bar;
      export 'package:bar/bar.dart' show bar;
      export 'package:bar/bar.dart' hide bar;
      export 'package:bar/bar.dart' hide bar;
    ''');
    final result = await const DeduplicateDirectives().transform(file);
    expect(
      result.getText(0),
      equalsIgnoringWhitespace(r'''
        import 'package:bar/bar.dart';
        import 'package:bar/bar.dart' as bar;
        import 'package:bar/bar.dart' as bar;
        import 'package:bar/bar.dart' show bar;
        import 'package:bar/bar.dart' show bar;
        import 'package:bar/bar.dart' hide bar;
        import 'package:bar/bar.dart' hide bar;
        export 'package:bar/bar.dart';
        export 'package:bar/bar.dart' show bar;
        export 'package:bar/bar.dart' show bar;
        export 'package:bar/bar.dart' hide bar;
        export 'package:bar/bar.dart' hide bar;
      '''),
    );
  });
}
