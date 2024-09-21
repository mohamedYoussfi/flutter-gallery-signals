import 'dart:convert';
import 'package:signal_posts/model/image-data.model.dart';
import 'package:http/http.dart' as http;
import 'package:signals/signals.dart';

enum Status { loading, success, error, unknown }

class GalleryState {
  ImageData imageData;
  String query;
  int currentPage;
  int totalPages;
  int pageSize;
  Status status;
  String errorMessage;
  GalleryState(
      {required this.imageData,
      required this.query,
      required this.currentPage,
      required this.totalPages,
      required this.pageSize,
      required this.status,
      required this.errorMessage});
  GalleryState copyWith({
    imageData,
    query,
    currentPage,
    totalPages,
    pageSize,
    status,
    errorMessage,
  }) {
    return GalleryState(
        imageData: imageData ?? this.imageData,
        query: query ?? this.query,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        pageSize: pageSize ?? this.pageSize,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class InitialState extends GalleryState {
  InitialState()
      : super(
          currentPage: 1,
          pageSize: 10,
          query: "",
          imageData: ImageData.init(),
          errorMessage: "",
          status: Status.unknown,
          totalPages: 0,
        );
}

class Store {
  final state = signal<GalleryState>(InitialState());
  final String url = "https://pixabay.com/api?key=......";
  void searchImages(String query) async {
    state.value = state.value.copyWith(status: Status.loading);
    try {
      final response = await http.get(Uri.parse(url +
          "&q=${query}&page=${state.value.currentPage}&per_page=${state.value.pageSize}"));
      dynamic data = jsonDecode(response.body);
      final images = ImageData.fromJson(data);
      int pageCount = images.totalHits ~/ state.value.pageSize;
      print(images.totalHits);
      print(state.value.pageSize);
      print(pageCount);
      if (images.totalHits % state.value.pageSize != 0) {
        ++pageCount;
      }
      images.hits = [...state.value.imageData.hits, ...images.hits];
      state.value = state.value.copyWith(
          query: query,
          imageData: images,
          status: Status.success,
          totalPages: pageCount);
    } catch (e, st) {
      state.value = state.value
          .copyWith(status: Status.error, errorMessage: e.toString());
    }
  }

  void nexPage() {
    GalleryState currentState = state.value;
    if (state.value.currentPage < state.value.totalPages) {
      state.value =
          currentState.copyWith(currentPage: currentState.currentPage + 1);
      searchImages(currentState.query);
    }
  }

  void newSearch(String query) {
    state.value = InitialState();
    searchImages(query);
  }
}

final store = Store();
