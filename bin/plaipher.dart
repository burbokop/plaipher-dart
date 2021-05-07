
import 'dart:io';

import 'package:tuple/tuple.dart';

import 'option.dart';
import 'utils.dart';

class MatrixPoint {
  final int x;
  final int y;
  MatrixPoint(int x, int y): x = x, y = y;
  factory MatrixPoint.fromIndex(int index, int width) => MatrixPoint(index % width, index ~/ width);
  static int toIndex(MatrixPoint point, int width) => point.x + point.y * width;
}


class BiGram {
  final c0;
  final c1;
  BiGram(int c0, int c1): c0 = c0, c1 = c1;

  @override String toString() => String.fromCharCodes([c0, c1]);
  String toPrettyString() => 'BiGram { ${String.fromCharCodes([c0, c1])} }';


  static Tuple2<int, int> horizontalSwapIndices(int index0, int index1, int width) {
    final p0 = MatrixPoint.fromIndex(index0, width);
    final p1 = MatrixPoint.fromIndex(index1, width);
    return Tuple2<int, int>(
        MatrixPoint.toIndex(MatrixPoint(p1.x, p0.y), width),
        MatrixPoint.toIndex(MatrixPoint(p0.x, p1.y), width)
    );
  }

  Option<BiGram> horizontallySwapped(String matrix, int width) {
    final index0 = matrix.indexOf(String.fromCharCode(c0));
    final index1 = matrix.indexOf(String.fromCharCode(c1));
    if (index0 >= 0 && index1 >= 0) {
      final newIndices = horizontalSwapIndices(index0, index1, width);
      return Option.some(BiGram(matrix.codeUnitAt(newIndices.item1), matrix.codeUnitAt(newIndices.item2)));
    } else {
      return Option.none();
    }
  }

  factory BiGram.fromString(String string, int filler) =>
      BiGram(string.isNotEmpty ? string.codeUnitAt(0) : filler, string.length > 1 ? string.codeUnitAt(1) : filler);

  static List<BiGram> listFromString(String string, int filler) {
    String iterator(String data, {int acc = 0}) {
      if(acc + 1 < data.length) {
        if(data.codeUnitAt(acc) == data.codeUnitAt(acc + 1) && data.codeUnitAt(acc) != filler) {
          return iterator(
              data.substring(0, acc + 1) + String.fromCharCode(filler) + data.substring(acc + 1),
              acc: acc + 1
          );
        } else {
          return iterator(data, acc: acc + 1);
        }
      } else {
        return data;
      }
    }
    return groupedString(iterator(string), 2).map((s) => BiGram.fromString(s, filler)).toList();
  }

  static String listToString(List<BiGram> array) =>
      array
          .map((e) => e.toString())
          .join();
}

class Plaipher {
  static const matrixWidth = 5;
  static const alphabet = 'abcdefghijklmnopqrstuvwxyz';

  static String createMatrix(String key, int except) =>
      String.fromCharCodes(key.runes.toSet()) + String.fromCharCodes(alphabet
          .runes
          .where((element) => !key.runes.contains(element))
          .where((element) => element != except));


  static void printMatrix(String matrix, int width) {
    final groups = groupedString(matrix, 5);
    print('matrix:');
    for(final g in groups) {
      for(final c in g.runes) {
        stdout.write('${String.fromCharCode(c)} ');
      }
      print('');
    }
  }

  static String crypt(String data, String key, int except, int filler, {bool verbose = false}) {
    final matrix = createMatrix(key, except);
    if (verbose) printMatrix(matrix, matrixWidth);


    final swappedBiGrams = BiGram.listFromString(String.fromCharCodes(data.runes.where((v) => v != ' '.codeUnitAt(0))), filler)
        .map((bg) => bg
        .horizontallySwapped(matrix, matrixWidth)
        .getOrElse(BiGram.fromString('', filler))
    ).toList();
    print(swappedBiGrams);
    return String.fromCharCodes(BiGram.listToString(swappedBiGrams).runes.where((c) => c != filler));
  }
}