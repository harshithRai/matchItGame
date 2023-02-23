/// ! CHANGES MAY NOT BE REQUIRED UNLESS CHANGE IN PACKAGE

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.config.dart';

final locator = GetIt.instance;

@injectableInit
void setupLocator() => $initGetIt(locator);
