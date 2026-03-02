import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/profile_controller.dart';
import '../widgets/profile_field.dart';
import '../widgets/profile_header_card.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xff111a2c),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // ✅ Responsive breakpoints
          final isMobile = width < 600;
          final isTablet = width >= 600 && width < 1024;

          final horizontalPadding = isMobile
              ? 16.0
              : isTablet
              ? 24.0
              : 32.0;
          final contentMaxWidth = isMobile ? double.infinity : 820.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 14),

                    // Header Card
                    ProfileHeaderCard(
                      name: st.isLoading
                          ? '—'
                          : (st.fullName.isNotEmpty ? st.fullName : '—'),
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ).then((_) {
                          // ✅ reload after returning from edit screen
                          ref.read(profileControllerProvider.notifier).load();
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TabBar(
                      controller: _tab,
                      indicatorColor: const Color(0xff111a2c),
                      labelColor: const Color(0xff111a2c),
                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                      tabs: const [
                        Tab(text: 'My Profile'),
                        Tab(text: 'My Tickets'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: TabBarView(
                        controller: _tab,
                        children: [
                          // ✅ Scrollable for small screens
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: st.isLoading
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 28),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : (st.error != null)
                                  ? Center(child: Text(st.error!))
                                  : Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff2f3f6),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ProfileField(
                                            label: 'Full Name:',
                                            value: st.fullName.isNotEmpty
                                                ? st.fullName
                                                : '—',
                                          ),
                                          ProfileField(
                                            label: 'Mobile No:',
                                            value: st.phone.isNotEmpty
                                                ? st.phone
                                                : '—',
                                          ),
                                          ProfileField(
                                            label: 'Email Address:',
                                            value: st.email.isNotEmpty
                                                ? st.email
                                                : '—',
                                          ),
                                          ProfileField(
                                            label: 'Date of Birth:',
                                            value: st.dob.isNotEmpty
                                                ? st.dob
                                                : '—',
                                          ),
                                          ProfileField(
                                            label: 'Gender:',
                                            value: st.gender.isNotEmpty
                                                ? st.gender
                                                : '—',
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),

                          const Center(child: Text('My Tickets (Coming Soon)')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
