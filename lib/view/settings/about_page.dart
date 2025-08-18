import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "About Foot Track"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Description
                Text(
                  'Welcome to Foot Track',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Foot Track is your ultimate companion for managing football teams, players, matches, and tournaments. Organize your teams, track player performance, and create exciting tournaments with ease.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 24),

                // Info Cards in GridView
                _buildInfoCard(
                  context,
                  icon: Icons.info,
                  title: 'App Version',
                  description: 'Version 1.0.0',
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.email,
                  title: 'Contact Us',
                  description: 'support@foottrack.com',
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.developer_mode,
                  title: 'Developed By',
                  description: 'Foot Track Team',
                ),
                _buildInfoCard(
                  context,
                  icon: Icons.star,
                  title: 'Our Mission',
                  description:
                      'Empowering football enthusiasts to manage their teams and tournaments effortlessly.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
