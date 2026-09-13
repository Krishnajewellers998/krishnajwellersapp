class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  bool get hasReachedMax => page >= totalPages;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
    String itemsKey,
  ) {
    return PaginatedResponse<T>(
      items: (json[itemsKey] as List<dynamic>?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
