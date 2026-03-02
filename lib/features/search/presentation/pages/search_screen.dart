import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/debounce.dart';
import '../providers/search_provider.dart';
import '../widgets/search_list_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  bool get wantKeepAlive => true;

  void _clear(SearchNotifier notifier) {
    _controller.clear();
    notifier.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final notifier = ref.watch(searchProvider);

    final w = MediaQuery.of(context).size.width;
    final pad = w >= 700 ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie, Genres & Language'),
        actions: [
          if (notifier.query.isNotEmpty)
            TextButton(
              onPressed: () => _clear(notifier),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(pad),
            child: TextField(
              controller: _controller,
              onChanged: (val) {
                _debouncer.run(() {
                  ref.read(searchProvider).search(val);
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search movie / language...',
              ),
            ),
          ),
          Expanded(
            child: notifier.loading
                ? const Center(child: CircularProgressIndicator())
                : notifier.results.isEmpty
                ? const Center(child: Text("No results"))
                : ListView.builder(
                    itemCount: notifier.results.length,
                    itemBuilder: (_, i) =>
                        SearchListItem(movie: notifier.results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
