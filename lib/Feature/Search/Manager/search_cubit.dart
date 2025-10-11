// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:userbarber/Feature/Search/Manager/search_state.dart';
//
// import 'package:userbarber/Feature/Search/searchRepo.dart';
//
//
// class SearchCubit extends Cubit<SearchState> {
//   final SearchRepository repository;
//   Timer? _debounce;
//
//   SearchCubit(this.repository) : super(SearchInitial());
//
//   void search(String query) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () async {
//       if (query.isEmpty) {
//         emit(SearchInitial());
//         return;
//       }
//
//       emit(SearchLoading());
//       try {
//         final results = await repository.searchAll(query);
//         emit(SearchLoaded(results));
//       } catch (e) {
//         emit(SearchError(e.toString()));
//       }
//     });
//   }
// }
