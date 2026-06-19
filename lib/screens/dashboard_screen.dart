import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/menu_controller.dart' as menu;

/// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final authController = Get.find<AuthController>();
  final dashboardController = Get.find<DashboardController>();
  final menuController = Get.find<menu.MenuController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: const Color(0xff1E3A8A),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              dashboardController.refreshDashboard();
            },
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              const PopupMenuItem(
                value: 1,
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Settings'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 3,
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 3) {
                authController.logout();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Obx(() {
          return ListView(
            children: [
              // User Header
              Obx(() {
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xff1E3A8A),
                  ),
                  accountName: Text(
                    authController.getUserName() ?? 'User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    authController.getUserEmail() ?? 'email@example.com',
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: Text(
                      (authController.getUserName() ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1E3A8A),
                      ),
                    ),
                  ),
                );
              }),

              // Menu Items
              ...menuController.menuItems.value?.map((item) {
                    return ListTile(
                      leading: Icon(_getIconData(item.icon)),
                      title: Text(item.title),
                      onTap: () {
                        Navigator.pop(context);
                        menuController.navigateToMenuItem(item);
                      },
                    );
                  }).toList() ??
                  [],

              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  authController.logout();
                },
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (dashboardController.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dashboardController.errorMessage.value!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    dashboardController.refreshDashboard();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => dashboardController.refreshDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Obx(() {
                    return Text(
                      'Welcome, ${authController.getUserName() ?? 'User'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1E3A8A),
                      ),
                    );
                  }),

                  // Project ID Display
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Project ID: ${authController.getProjectId() ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    children: [
                      _buildStatCard(
                        'Total Enquiries',
                        dashboardController.getTotalEnquiries().toString(),
                        Colors.blue,
                        Icons.mail,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Open',
                        dashboardController.getOpenEnquiries().toString(),
                        Colors.orange,
                        Icons.open_in_new,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(
                        'Closed',
                        dashboardController.getClosedEnquiries().toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Conversion',
                        '${dashboardController.getConversionRate().toStringAsFixed(1)}%',
                        Colors.purple,
                        Icons.trending_up,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Enquiries Section
                  const Text(
                    'Recent Enquiries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (dashboardController.getRecentEnquiries().isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text('No recent enquiries'),
                      ),
                    )
                  else
                    ...dashboardController
                        .getRecentEnquiries()
                        .map((enquiry) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(enquiry.clientName[0]),
                          ),
                          title: Text(enquiry.clientName),
                          subtitle: Text(enquiry.propertyType),
                          trailing: Chip(
                            label: Text(enquiry.status),
                            backgroundColor: _getStatusColor(enquiry.status),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'home':
        return Icons.home;
      case 'mail':
        return Icons.mail;
      case 'folder':
        return Icons.folder;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'settings':
        return Icons.settings;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.circle;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      case 'pending':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
