import 'dart:io';

void main() {
  final dir = Directory('.');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart') || f.path.endsWith('pubspec.yaml') || f.path.endsWith('vercel.json') || f.path.endsWith('.html') || f.path.endsWith('.json') || f.path.endsWith('.md') || f.path.endsWith('.cc') || f.path.endsWith('.cmake'));

  for (final file in files) {
    if (file.path.contains('.git')) continue;
    
    String content = file.readAsStringSync();
    if (content.contains('<<<<<<< HEAD')) {
      print('Fixing ${file.path}');
      
      final lines = content.split('\n');
      final newLines = <String>[];
      
      bool inConflict = false;
      bool keep = true;
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.startsWith('<<<<<<< HEAD')) {
          inConflict = true;
          keep = true;
          continue;
        }
        if (line.startsWith('=======')) {
          if (inConflict) {
            keep = false;
            continue;
          }
        }
        if (line.startsWith('>>>>>>> ')) {
          if (inConflict) {
            inConflict = false;
            keep = true;
            continue;
          }
        }
        
        if (keep) {
          newLines.add(line);
        }
      }
      
      file.writeAsStringSync(newLines.join('\n'));
    }
  }
}
