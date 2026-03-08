import 'package:booko/features/profile/data/models/ticket_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booko/core/api/api_endpoints.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../state/profile_controller.dart';
import '../widgets/profile_field.dart';
import '../widgets/profile_header_card.dart';
import 'edit_profile_screen.dart';
import 'package:booko/features/profile/data/models/profile_hive_model.dart';

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
                          // My Profile Tab
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

                          // My Tickets Tab
                          const _MyTicketsView(),
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

// ---------------- My Tickets View ----------------
class _MyTicketsView extends StatefulWidget {
  const _MyTicketsView();

  @override
  State<_MyTicketsView> createState() => _MyTicketsViewState();
}

class _MyTicketsViewState extends State<_MyTicketsView> {
  List<TicketHiveModel> _tickets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Load tickets from Hive
      final profileBox = Hive.box<ProfileHiveModel>('profileBox');
      if (profileBox.isNotEmpty) {
        final profile = profileBox.getAt(0)!;
        _tickets = List.from(profile.myTickets);
      }

      // Fetch tickets from API
      final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.myTickets}');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final apiTickets = (decoded['data'] as List<dynamic>)
              .map((t) => TicketHiveModel.fromJson(t))
              .toList();

          // Merge Hive tickets + API tickets, avoid duplicates
          for (var t in apiTickets) {
            if (!_tickets.any(
              (x) =>
                  x.movieId == t.movieId &&
                  x.dayText == t.dayText &&
                  x.seats.join(',') == t.seats.join(','),
            )) {
              _tickets.add(t);
            }
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_tickets.isEmpty) {
      return const Center(child: Text('No tickets found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final t = _tickets[index];
        final seats = t.seats.join(', ');
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              t.movieTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${t.cinema} - ${t.dayText} at ${t.time}'),
                const SizedBox(height: 4),
                Text(
                  'Seats: $seats',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Text(
              'NPR ${t.totalPrice}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.indigo,
              ),
            ),
          ),
        );
      },
    );
  }
}
