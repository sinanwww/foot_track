import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:get/get.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Foot Track Terms and Conditions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Last updated: August 19, 2025',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                title: '1. Acceptance of Terms',
                content:
                    'By using Foot Track, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use the app. We reserve the right to update these terms at any time, and continued use of the app constitutes acceptance of the updated terms.',
              ),
              _buildSection(
                context,
                title: '2. Use of the App',
                content:
                    'Foot Track is provided for personal, non-commercial use to manage football teams, players, matches, and tournaments. You agree to:\n'
                    '- Use the app in compliance with all applicable laws.\n'
                    '- Not use the app for any unlawful or prohibited purpose.\n'
                    '- Not attempt to hack, modify, or disrupt the app’s functionality.',
              ),
              _buildSection(
                context,
                title: '3. User Responsibilities',
                content:
                    'You are responsible for:\n'
                    '- Maintaining the confidentiality of your account and login information.\n'
                    '- Ensuring the accuracy of data entered, such as player or team information.\n'
                    '- Any content you upload, including ensuring it does not infringe on third-party rights.',
              ),
              _buildSection(
                context,
                title: '4. Intellectual Property',
                content:
                    'All content, features, and functionality of Foot Track (including but not limited to text, graphics, and logos) are the property of Foot Track Inc. or its licensors. You may not reproduce, distribute, or create derivative works without express permission.',
              ),
              _buildSection(
                context,
                title: '5. Limitation of Liability',
                content:
                    'Foot Track is provided "as is" without warranties of any kind. We are not liable for:\n'
                    '- Any indirect, incidental, or consequential damages arising from app use.\n'
                    '- Errors or inaccuracies in app content or functionality.\n'
                    '- Data loss or interruptions in service.',
              ),
              _buildSection(
                context,
                title: '6. Termination',
                content:
                    'We may terminate or suspend your access to Foot Track at our discretion, including for violation of these terms. Upon termination, your right to use the app will cease immediately.',
              ),
              _buildSection(
                context,
                title: '7. Contact Us',
                content:
                    'If you have questions about these Terms and Conditions, please contact us at:\n'
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[800],
                ),
          ),
        ],
      ),
    );
  }
}