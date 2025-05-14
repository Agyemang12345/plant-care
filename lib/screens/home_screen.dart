import 'package:flutter/material.dart';
import 'diagnose_screen.dart';
import 'scan_screen.dart';
import 'my_plants_screen.dart';
import 'chatbot_screen.dart';
import 'water_calculator_screen.dart';
import 'community_screen.dart';
import 'weather_screen.dart';
import 'tip_page.dart';
import 'plant_identification_screen.dart';
import 'gemini_plant_scan_screen.dart';
// import 'settings_screen.dart'; // Uncomment if you have a settings screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const DiagnoseScreen()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MyPlantsScreen()));
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const CommunityScreen()));
    } else if (index == 4) {
      Navigator.pushNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget featureCard(
        String title, IconData icon, Color color, VoidCallback onTap) {
      return Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: color.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  radius: 20,
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome Back!',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor)),
                        const SizedBox(height: 2),
                        Text('Plant Lover',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            )),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wb_sunny,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('PRO',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Promo Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Care your Plant with',
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white)),
                          Text('Plant Diagnose',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              shape: const StadiumBorder(),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const DiagnoseScreen()));
                            },
                            child: const Text('Diagnose Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/plant_banner.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.local_florist,
                          color: theme.colorScheme.secondary,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Feature Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    featureCard(
                      'Plant Identification',
                      Icons.camera_alt,
                      Colors.green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PlantIdentificationScreen(
                              apiKey:
                                  'YOUR_API_KEY', // Replace with your actual API key
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    featureCard('Plant Identifier', Icons.spa,
                        theme.colorScheme.secondary, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScanScreen()));
                    }),
                    featureCard('Plant Diagnose', Icons.favorite,
                        theme.colorScheme.secondary, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DiagnoseScreen()));
                    }),
                    featureCard('Chatbot', Icons.chat, Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatbotScreen(
                            apiKey: 'ZLx3V2hqtfpEGam9Xx7TLuE7gprpNUIpU71Cghe9',
                          ),
                        ),
                      );
                    }),
                    featureCard('Community', Icons.people, Colors.purple, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CommunityScreen()));
                    }),
                    featureCard('Weather', Icons.wb_sunny, Colors.orange, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WeatherScreen()));
                    }),
                    featureCard('Water Calculator', Icons.water_drop,
                        theme.colorScheme.primary, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WaterCalculatorScreen()));
                    }),
                    featureCard('Tip', Icons.lightbulb, Colors.teal, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TipPage()),
                      );
                    }),
                  ],
                ),
              ),
              // No plants yet card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/leaf.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.local_florist,
                          color: Colors.green,
                          size: 40),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No plants yet',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("You haven't identified any plants yet",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        shape: const StadiumBorder(),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScanScreen()));
                      },
                      child: Text('Identify',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        elevation: 6,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ScanScreen()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(theme),
    );
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 0) return; // Already on Home
        _onNavTap(index);
      },
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Diagnose',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.spa),
          label: 'My Plants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
