import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Foot Track Privacy Policy',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Last updated: August 19, 2025',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: '1. Introduction',
                content:
                    'Welcome to Foot Track, a mobile application designed to help you manage football teams, players, matches, and tournaments. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our app. By using Foot Track, you agree to the terms outlined in this policy.',
              ),
              _buildSection(
                context,
                title: '2. Information We Collect',
                content:
                    'We collect the following types of information:\n'
                    '- **Personal Information**: Name, email address, and profile images when you create a player or team profile.\n'
                    '- **Usage Data**: Information about how you interact with the app, such as teams created, matches tracked, and tournaments organized.\n'
                    '- **Device Information**: Device type, operating system, and unique device identifiers to improve app performance.',
              ),
              _buildSection(
                context,
                title: '3. How We Use Your Information',
                content:
                    'We use your information to:\n'
                    '- Provide and improve the Foot Track app’s functionality.\n'
                    '- Personalize your experience, such as displaying your teams and players.\n'
                    '- Analyze app usage to enhance performance and user experience.\n'
                    '- Communicate with you, including sending updates or support messages.',
              ),
              _buildSection(
                context,
                title: '4. Data Sharing',
                content:
                    'We do not share your personal information with third parties except:\n'
                    '- With your consent.\n'
                    '- To comply with legal obligations or protect our rights.\n'
                    '- With service providers who assist in app operations (e.g., cloud storage), under strict confidentiality agreements.',
              ),
              _buildSection(
                context,
                title: '5. Data Security',
                content:
                    'We implement reasonable security measures to protect your information, such as encryption and secure storage. However, no system is completely secure, and we cannot guarantee absolute security.',
              ),
              _buildSection(
                context,
                title: '6. Your Rights',
                content:
                    'You have the right to:\n'
                    '- Access, update, or delete your personal information.\n'
                    '- Opt out of certain data collection (e.g., usage analytics).\n'
                    '- Contact us at support@foottrack.com to exercise these rights.',
              ),
              _buildSection(
                context,
                title: '7. Contact Us',
                content:
                    'If you have questions about this Privacy Policy, please contact us at:\n'
                    'Email: support@foottrack.com\n'
                    'Address: Foot Track Inc., 123 Football Lane, Sports City, SC 12345',
              ),
              const SizedBox(height: 16),
              AuthButton(
                label: 'Back',
                onClick: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
