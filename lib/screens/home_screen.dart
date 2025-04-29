import 'package:flutter/material.dart';
import 'diagnose_screen.dart';
import 'scan_screen.dart';
import 'my_plants_screen.dart';
import 'chatbot_screen.dart';
import 'water_calculator_screen.dart';
import 'community_screen.dart';
import 'weather_screen.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
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
                      children: const [
                        Text('Welcome Back!',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Plant Lover',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B4332),
                                letterSpacing: 1)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D2F23),
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
                        children: const [
                          Icon(Icons.wb_sunny, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('PRO',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4332), Color(0xFF23C16B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.10),
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
                          const Text('Care your Plant with',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          const Text('Plant Diagnose',
                              style: TextStyle(
                                  color: Color(0xFF5DF28A),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF23C16B),
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
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/leaf.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.local_florist,
                                color: Colors.white, size: 60),
                      ),
                    ),
                  ],
                ),
              ),
              // Feature Grid
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [
                    _featureCard(
                        'Plant Identifier', Icons.spa, const Color(0xFF23C16B),
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScanScreen()));
                    }),
                    _featureCard('Plant Diagnose', Icons.favorite,
                        const Color(0xFF5DF28A), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DiagnoseScreen()));
                    }),
                    _featureCard('Chatbot', Icons.chat, Colors.blue, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChatbotScreen()));
                    }),
                    _featureCard('Community', Icons.people, Colors.purple, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CommunityScreen()));
                    }),
                    _featureCard('Weather', Icons.wb_sunny, Colors.orange, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WeatherScreen()));
                    }),
                    _featureCard('Water Calculator', Icons.water_drop,
                        const Color(0xFF1B4332), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WaterCalculatorScreen()));
                    }),
                    _featureCard('Light Meter', Icons.wb_sunny, Colors.amber,
                        () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Light Meter coming soon!')));
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                        backgroundColor: const Color(0xFF23C16B),
                        shape: const StadiumBorder(),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScanScreen()));
                      },
                      child: const Text('Identify',
                          style: TextStyle(color: Colors.white)),
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
        backgroundColor: const Color(0xFF23C16B),
        elevation: 6,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ScanScreen()));
        },
        child: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _featureCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
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
                child: Icon(icon, color: color, size: 26),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 0) return; // Already on Home
        _onNavTap(index);
      },
      selectedItemColor: const Color(0xFF1B4332),
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
