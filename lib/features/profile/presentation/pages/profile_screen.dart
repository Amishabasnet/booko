import 'dart:io';

import 'package:booko/features/profile/presentation/state/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  ImageProvider _imageProvider(ProfileData? profile) {
    if (profile?.imagePath != null && profile!.imagePath!.isNotEmpty) {
      return FileImage(File(profile.imagePath!));
    }
    return const AssetImage('assets/images/default_avatar.png');
    // Or use:
    // return const NetworkImage('https://i.pravatar.cc/200');
  }

  void _openEdit(BuildContext context, ProfileData? profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialProfile: profile),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (res == true) {
      // Demo: clear local profile. Replace with your auth logout later.
      await ref.read(profileProvider.notifier).clearProfile();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(profileProvider);
    final theme = Theme.of(context);

    if (st.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final p = st.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Text(
          'My Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
        children: [
          // Top profile card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: p == null ? null : _imageProvider(p),
                  child: p == null
                      ? const Icon(Icons.person_outline, color: Colors.black54)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (p?.name.isNotEmpty == true) ? p!.name : 'Guest User',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (p?.email.isNotEmpty == true)
                            ? p!.email
                            : 'guest@booko.app',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _openEdit(context, p),
                            child: const Text('Edit Profile'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          _MenuTile(
            icon: Icons.confirmation_number_outlined,
            title: 'My Tickets',
            subtitle: 'View booked tickets',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyTicketsScreen()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.favorite_border,
            title: 'Favourites',
            onTap: () => _toast(context, 'Favourites (coming soon)'),
          ),
          _MenuTile(
            icon: Icons.download_outlined,
            title: 'Downloads',
            onTap: () => _toast(context, 'Downloads (coming soon)'),
          ),
          _MenuTile(
            icon: Icons.language_outlined,
            title: 'Language',
            onTap: () => _toast(context, 'Language (coming soon)'),
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            onTap: () => _toast(context, 'Location (coming soon)'),
          ),
          _MenuTile(
            icon: Icons.subscriptions_outlined,
            title: 'Subscription',
            onTap: () => _toast(context, 'Subscription (coming soon)'),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'My Tickets',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'No tickets yet',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
