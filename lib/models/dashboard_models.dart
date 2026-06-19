/// Dashboard Response Model
class DashboardResponse {
  final bool success;
  final String message;
  final DashboardData? data;

  DashboardResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

/// Dashboard Data Model
class DashboardData {
  final int totalEnquiries;
  final int openEnquiries;
  final int closedEnquiries;
  final double conversionRate;
  final List<RecentEnquiry> recentEnquiries;
  final List<DashboardStat> stats;

  DashboardData({
    required this.totalEnquiries,
    required this.openEnquiries,
    required this.closedEnquiries,
    required this.conversionRate,
    required this.recentEnquiries,
    required this.stats,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    var enquiriesList = json['recentEnquiries'] as List?;
    var statsList = json['stats'] as List?;

    return DashboardData(
      totalEnquiries: json['totalEnquiries'] ?? 0,
      openEnquiries: json['openEnquiries'] ?? 0,
      closedEnquiries: json['closedEnquiries'] ?? 0,
      conversionRate: (json['conversionRate'] ?? 0.0).toDouble(),
      recentEnquiries: enquiriesList?.map((e) => RecentEnquiry.fromJson(e)).toList() ?? [],
      stats: statsList?.map((e) => DashboardStat.fromJson(e)).toList() ?? [],
    );
  }
}

/// Recent Enquiry Model
class RecentEnquiry {
  final String id;
  final String clientName;
  final String propertyType;
  final String status;
  final String createdAt;

  RecentEnquiry({
    required this.id,
    required this.clientName,
    required this.propertyType,
    required this.status,
    required this.createdAt,
  });

  factory RecentEnquiry.fromJson(Map<String, dynamic> json) {
    return RecentEnquiry(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      propertyType: json['propertyType'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

/// Dashboard Statistics Model
class DashboardStat {
  final String label;
  final int value;
  final double percentage;

  DashboardStat({
    required this.label,
    required this.value,
    required this.percentage,
  });

  factory DashboardStat.fromJson(Map<String, dynamic> json) {
    return DashboardStat(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }
}
