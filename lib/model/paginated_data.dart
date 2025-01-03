class PaginatedData<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;

  PaginatedData({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
  });

  factory PaginatedData.fromJson(Map<String, dynamic> json, Function convert) {
    List<T> data = List<T>.from(json['data'].map((item) => convert(item)));
    return PaginatedData(
      data: data,
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      nextPageUrl: json['next_page_url'],
    );
  }

  bool get isLastPage => nextPageUrl == null;
}
