import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_login_controller.dart';

class HistoryLoginView extends GetView<HistoryLoginController> {
  const HistoryLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat riwayat login...'),
              ],
            ),
          );
        }

        if (controller.loginHistory.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Belum ada riwayat login/logout.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.loginHistory.length,
            itemBuilder: (context, index) {
              final item = controller.loginHistory[index];
              
              final email = item['email']?.toString() ?? 'Email tidak diketahui';
              final status = item['status']?.toString().toLowerCase() ?? 'login';
              final deviceInfo = item['device_info']?.toString() ?? 'Perangkat tidak diketahui';
              final authProvider = item['auth_provider']?.toString().toLowerCase() ?? 'local';

              final DateTime timestamp = item['parsed_timestamp'] ?? DateTime.now();
              final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(timestamp);

              final isLogout = status == 'logout';
              final isGoogle = authProvider == 'google';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: _buildIcon(isLogout, isGoogle),
                  title: Row(
                    children: [
                      Text(
                        isLogout ? 'Logout' : 'Login',
                        style: TextStyle(
                          color: isLogout ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: const BoxDecoration(
    color: Colors.transparent,
  ),
  child: isGoogle
      ? Image.asset(
          'assets/google.png',
          height: 25,
          width: 25,
        )
      : Image.asset(
          'assets/gmail.png',
          height: 25,
          width: 25,
        ),
),

                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.email, 'Email', email),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.access_time, 'Waktu', formattedDate),
                      const SizedBox(height: 4),
                      _buildInfoRow(Icons.phone_iphone, 'device', deviceInfo),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildIcon(bool isLogout, bool isGoogle) {
    IconData iconData;
    Color iconColor;

    if (isLogout) {
      iconData = isGoogle ? Icons.logout : Icons.exit_to_app;
      iconColor = isGoogle ? Colors.orange : Colors.red;
    } else {
      iconData = isGoogle ? Icons.login : Icons.login;  // Gunakan login icon untuk semua
      iconColor = isGoogle ? Colors.blue : Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}