import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/model/ai/ai_home.dart';
import 'package:url_launcher/url_launcher.dart';

class AiSearchPage extends StatefulWidget {
  const AiSearchPage({Key? key}) : super(key: key);

  @override
  State<AiSearchPage> createState() => _AiSearchPageState();
}

class _AiSearchPageState extends State<AiSearchPage> {
  AiHomeDataModel? _aiData;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // API provided: https://www.localkart.app/portal/api/shopservicecategories
      const url = "https://www.localkart.app/portal/api/shopservicecategories";
      final response = await ApiClientLocalKart().httpGet(url);
      final data = json.decode(response.body);

      if (data['errorCode'] == 0) {
        setState(() {
          _aiData = AiHomeDataModel.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching AI search data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF6B1B9A), // Purple
              Color(0xFF1976D2), // Blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // ChatGPT Button
              _buildChatGPTButton(),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _aiData == null
                        ? const Center(child: Text("Error loading content", style: TextStyle(color: Colors.white)))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 100),
                                // Title
                                Text(
                                  _aiData?.title ?? "What are you looking for today?",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Subtitle
                                Text(
                                  _aiData?.subtitle ?? "Tap a suggestion, type or speak to explore.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Suggestion Chips
                                _buildChipsSection(),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
              ),

              // Bottom Input
              _buildBottomSearch(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatGPTButton() {
    return InkWell(
      onTap: () async {
        final url = Uri.parse("https://chatgpt.com");
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Click here to go to ChatGPT",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(width: 8),
            Icon(Icons.north_east, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsSection() {
    List<AiItem> combinedItems = [];
    
    // Adding some from Shop, Service and all from Offer to match screenshot
    if (_aiData?.shop != null) combinedItems.addAll(_aiData!.shop!.take(3));
    if (_aiData?.service != null) combinedItems.addAll(_aiData!.service!.take(3));
    if (_aiData?.offer != null) combinedItems.addAll(_aiData!.offer!);

    return Wrap(
      spacing: 10,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: combinedItems.map((item) => _buildItemChip(item)).toList(),
    );
  }

  Widget _buildItemChip(AiItem item) {
    return InkWell(
      onTap: () {
        if (item.type == "Today" || item.type == "Weekly" || item.type == "Festival") {
          // Handle offer click if specific logic exists
        } else {
          Navigator.of(context).pushNamed(root_services_list, arguments: {
            "state_id": "1",
            "dist_id": "752",
            "title": item.type == "Services" ? "Services" : "Shopping",
            "services_id": item.id,
            "sub_title": item.name,
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white24, width: 0.5),
        ),
        child: Text(
          item.name ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBottomSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(left: 20, right: 8),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Start typing...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF6B56D3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
