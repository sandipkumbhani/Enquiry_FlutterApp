import 'package:get/get.dart';
import '../config/app_config.dart';
import '../models/dashboard_models.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Dashboard Controller - Manages dashboard state and API calls
class DashboardController extends GetxController {
  final apiService = Get.find<ApiService>();

  /// Reactive Variables
  var isLoading = false.obs;
  var dashboardData = Rx<DashboardData?>(null);
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetch dashboard data from API
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Get project ID from global storage
      final projectId = StorageService.getProjectId();
      if (projectId == null) {
        errorMessage.value = 'Project ID not found. Please login again.';
        return;
      }

      // Make API call with project ID
      final response = await apiService.get(
        AppConfig.dashboardEndpoint,
        queryParameters: {'projectId': projectId},
      );

      if (response['success']) {
        final dashboardResponse = DashboardResponse.fromJson(response['data']);

        if (dashboardResponse.success && dashboardResponse.data != null) {
          dashboardData.value = dashboardResponse.data;
          errorMessage.value = null;
          print('✅ Dashboard data loaded successfully');
        } else {
          errorMessage.value = dashboardResponse.message;
        }
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load dashboard';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }

  /// Get total enquiries count
  int getTotalEnquiries() => dashboardData.value?.totalEnquiries ?? 0;

  /// Get open enquiries count
  int getOpenEnquiries() => dashboardData.value?.openEnquiries ?? 0;

  /// Get closed enquiries count
  int getClosedEnquiries() => dashboardData.value?.closedEnquiries ?? 0;

  /// Get conversion rate
  double getConversionRate() => dashboardData.value?.conversionRate ?? 0.0;

  /// Get recent enquiries
  List<RecentEnquiry> getRecentEnquiries() =>
      dashboardData.value?.recentEnquiries ?? [];

  /// Get dashboard statistics
  List<DashboardStat> getStats() => dashboardData.value?.stats ?? [];
}
