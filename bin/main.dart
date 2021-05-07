


import 'dart:io';

import 'option.dart';
import 'plaipher.dart';

class FlagProvider {
  final List<String> args;
  FlagProvider(List<String> args): args = args;
  Option<String> stringFlag(String name) {
    for(var i = 0; i < args.length - 1; i++) {
      if (args[i] == name) {
        return Option.some(args[i + 1]);
      }
    }
    return Option.none();
  }
  bool boolFlag(String name) => args.contains(name);
  Option<int> charFlag(String name) => stringFlag(name)
      .map<int>((v) => v.codeUnitAt(0));
}



void main(List<String> arguments) {
  void help() {
    print('Options:');
    print('\t  --data   [data that will be encrypted]');
    print('\t  --key    [encryption key]');
    print('\t  --except [except character]');
    print('\t  --filler [filler character]');
  };

  final flagProvider = FlagProvider(arguments);

  final data = flagProvider.stringFlag('--data');
  final key = flagProvider.stringFlag('--key');
  final except = flagProvider.charFlag('--except');
  final filler = flagProvider.charFlag('--filler');
  final verbose = flagProvider.boolFlag('--verbose');

  if (data.isEmpty) {
    print('Error: Data must not be empty');
    help();
    exit(-2);
  }
  if (key.isEmpty) {
    print('Error: Key must not be empty');
    help();
    exit(-2);
  }
  if (except.isEmpty) {
    print('Error: Except character must not be empty');
    help();
    exit(-2);
  }
  if (filler.isEmpty) {
  print('Error: Filler character must not be empty');
  help();
  exit(-2);
  }

  if(data.isDefined && key.isDefined) {
    print('input data: ${data.value}');
    print('key data: ${key.value}');
    print('except character: ${except.value}');
    print('filler character: ${filler.value}');
    print('result: ${Plaipher.crypt(data.value, key.value, except.value, filler.value, verbose: verbose)}');
  }
}

