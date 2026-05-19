 import 'package:get_it/get_it.dart';
  
import '../services/documents/cubit/document_cubit.dart';
 
 

final getIt = GetIt.instance;

Future<void> setUp() async {
  // getIt.registerLazySingleton(() => RootCubit());


  getIt.registerLazySingleton(() => DocumentCubit());
 
}
