// import 'dart:async';
// import 'package:echosphere/View/Screen/Services/daily_needs_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/educational_requirements_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/garments_footwear_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/general_services_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/grocery_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/home_utilities_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/jewellery_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/masti_family_time_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/personal_care_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/pet_grooming_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/photography_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/sports_gym_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/tours_travels_subcategory_screen.dart';
// import 'package:echosphere/View/Screen/Services/wedding_necessities_subcategory_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:echosphere/view/widgets/custom_bottom_bar.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/service_screen.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/profile_screen.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/about_screen.dart';
// import 'package:echosphere/view/screen/Services/healthcare_subcategory_screen.dart';
// import 'package:echosphere/view/screen/Services/agricultural_subcategory_screen.dart';
// import 'package:echosphere/view/screen/Services/hotels_subcategory_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     HomeTab(),
//     ServiceScreen(),
//     ProfileScreen(),
//     AboutScreen(),
//   ];

//   final List<String> _titles = const [
//     "Ecosphere",
//     "Services",
//     "Profile",
//     "About",
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_titles[_selectedIndex]),
//         backgroundColor: const Color(0xFF2E7D32),
//         centerTitle: true,
//       ),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: CustomBottomBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }


// /// HOME TAB WITH ANIMATED SLIDER

// class HomeTab extends StatefulWidget {
//   const HomeTab({super.key});

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   late final PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   final List<Map<String, dynamic>> categories = [
//     {
//       "title": "Healthcare",
//       "image": "assets/categories/hospitals.jpg",
//       "screen": const HealthcareSubcategoryScreen(),
//     },
//     {
//       "title": "Agricultural Requirements",
//       "image": "assets/categories/agri.jpg",
//       "screen": const AgriculturalSubcategoryScreen(),
//     },
//     {
//       "title": "Hotels",
//       "image": "assets/categories/hotel.png",
//       "screen": const HotelsSubcategoryScreen(),
//     },
//     {
//       "title": "Home Utilities",
//       "image": "assets/categories/home_utilities.jpg",
//       "screen": const HomeUtilitiesSubcategoryScreen(),
//     },
//     {
//       "title": "Garments & Footwear",
//       "image": "assets/categories/garments_footwear.jpg",
//       "screen": const GarmentsFootwearSubcategoryScreen(),
//     },
//     {
//       "title": "Grocery",
//       "image": "assets/categories/grocery.webp",
//       "screen": const GrocerySubcategoryScreen(),
//     },
//     {
//       "title": "Jewellery",
//       "image": "assets/categories/jewellery.webp",
//       "screen": const JewellerySubcategoryScreen(),
//     },
//     {
//       "title": "Daily Needs",
//       "image": "assets/categories/medical.jpg",
//       "screen": const DailyNeedsSubcategoryScreen(),
//     },
//     {
//       "title": "Pet Grooming Centers",
//       "image": "assets/categories/pet_grooming_centers.jpg",
//       "screen": const PetGroomingSubcategoryScreen(),
//     },
//     {
//       "title": "Sports & Gym",
//       "image": "assets/categories/gym.jpg",
//       "screen": const SportsGymSubcategoryScreen(),
//     },
//     {
//       "title": "Photography",
//       "image": "assets/categories/photography.jpg",
//       "screen": const PhotographySubcategoryScreen(),
//     },
//     {
//       "title": "Personal Care",
//       "image": "assets/categories/personal_care.jpg",
//       "screen": const PersonalCareSubcategoryScreen(),
//     },
//     {
//       "title": "Wedding Necessities",
//       "image": "assets/categories/wedding.jpg",
//       "screen": const WeddingNecessitiesSubcategoryScreen(),
//     },
//     {
//       "title": "Services",
//       "image": "assets/categories/services.jpg",
//       "screen": const GeneralServicesSubcategoryScreen(),
//     },
//     {
//       "title": "Educational Requirements",
//       "image": "assets/categories/educational_requirement.jpg",
//       "screen": const EducationalRequirementsSubcategoryScreen(),
//     },
//     {
//       "title": "Masti & Family Time",
//       "image": "assets/categories/family_time.jpg",
//       "screen": const MastiFamilyTimeSubcategoryScreen(),
//     },
//     {
//       "title": "Tours & Travels",
//       "image": "assets/categories/tours_travels.webp",
//       "screen": const ToursTravelsSubcategoryScreen(),
//     },

//     ///
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.85);
//     _startAutoSlide();
//   }

//   void _startAutoSlide() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_pageController.hasClients) {
//         _currentPage++;
//         if (_currentPage >= categories.length) {
//           _currentPage = 0;
//         }

//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 800),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             /// SLIDER
//             SizedBox(
//               height: 200,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => category["screen"],
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: Image.asset(
//                                   category["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Positioned.fill(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                       colors: [
//                                         Colors.black.withOpacity(0.7),
//                                         Colors.transparent,
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 20,
//                                 left: 20,
//                                 child: Text(
//                                   category["title"],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }


//latest
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:echosphere/view/widgets/custom_bottom_bar.dart';

// Bottom bar screens
import 'package:echosphere/View/Screen/BottomBarScreen/service_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/profile_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/about_screen.dart';

// Subcategory screens
import 'package:echosphere/View/Screen/Services/daily_needs_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/educational_requirements_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/garments_footwear_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/general_services_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/grocery_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/home_utilities_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/jewellery_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/masti_family_time_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/personal_care_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/pet_grooming_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/photography_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/sports_gym_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/tours_travels_subcategory_screen.dart';
import 'package:echosphere/View/Screen/Services/wedding_necessities_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/healthcare_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/agricultural_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/hotels_subcategory_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    ServiceScreen(),
    ProfileScreen(),
    AboutScreen(),
  ];

  final List<String> _titles = const [
    "Echosphere",
    "Services",
    "Profile",
    "About",
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
/// HOME TAB
//////////////////////////////////////////////////////////////

// class HomeTab extends StatefulWidget {
//   const HomeTab({super.key});

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   late final PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   final List<Map<String, dynamic>> categories = [
//     {
//       "title": "Healthcare",
//       "image": "assets/categories/hospitals.jpg",
//       "screen": const HealthcareSubcategoryScreen(),
//     },
//     {
//       "title": "Agricultural Requirements",
//       "image": "assets/categories/agri.jpg",
//       "screen": const AgriculturalSubcategoryScreen(),
//     },
//     {
//       "title": "Hotels",
//       "image": "assets/categories/hotel.png",
//       "screen": const HotelsSubcategoryScreen(),
//     },
//     {
//       "title": "Educational Requirements",
//       "image": "assets/categories/educational_requirement.jpg",
//       "screen": const EducationalRequirementsSubcategoryScreen(),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.85);
//     _startAutoSlide();
//   }

//   void _startAutoSlide() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         _currentPage++;
//         if (_currentPage >= categories.length) {
//           _currentPage = 0;
//         }

//         _pageController.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 800),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             /// Greeting Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Hello, User 👋",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Find your service provider",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 Image.asset(
//                   "assets/images/logo.png",
//                   height: 40,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             /// Search Bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search services...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// Section Title
//             const Text(
//               "Popular Categories",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 15),

//             /// SLIDER
//             SizedBox(
//               height: 200,
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: categories.length,
//                 itemBuilder: (context, index) {
//                   final category = categories[index];

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => category["screen"],
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Stack(
//                             children: [
//                               Positioned.fill(
//                                 child: Image.asset(
//                                   category["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Positioned.fill(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                       colors: [
//                                         Colors.black.withOpacity(0.7),
//                                         Colors.transparent,
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 20,
//                                 left: 20,
//                                 child: Text(
//                                   category["title"],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// Quick Grid
//             const Text(
//               "Explore More",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 15),

//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: categories.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1,
//               ),
//               itemBuilder: (context, index) {
//                 final item = categories[index];

//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => item["screen"],
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       item["image"],
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

//
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> allCategories = [
    {
      "title": "Healthcare",
      "image": "assets/categories/hospitals.jpg",
      "screen": const HealthcareSubcategoryScreen(),
    },
    {
      "title": "Agricultural Requirements",
      "image": "assets/categories/agri.jpg",
      "screen": const AgriculturalSubcategoryScreen(),
    },
    {
      "title": "Hotels",
      "image": "assets/categories/hotel.png",
      "screen": const HotelsSubcategoryScreen(),
    },
    {
      "title": "Home Utilities",
      "image": "assets/categories/home_utilities.jpg",
      "screen": const HomeUtilitiesSubcategoryScreen(),
    },
    {
      "title": "Garments & Footwear",
      "image": "assets/categories/garments_footwear.jpg",
      "screen": const GarmentsFootwearSubcategoryScreen(),
    },
    {
      "title": "Grocery",
      "image": "assets/categories/grocery.webp",
      "screen": const GrocerySubcategoryScreen(),
    },
    {
      "title": "Jewellery",
      "image": "assets/categories/jewellery.webp",
      "screen": const JewellerySubcategoryScreen(),
    },
    {
      "title": "Educational Requirements",
      "image": "assets/categories/educational_requirement.jpg",
      "screen": const EducationalRequirementsSubcategoryScreen(),
    },
    {
      "title": "Masti & Family Time",
      "image": "assets/categories/family_time.jpg",
      "screen": const MastiFamilyTimeSubcategoryScreen(),
    },
    {
      "title": "Tours & Travels",
      "image": "assets/categories/tours_travels.webp",
      "screen": const ToursTravelsSubcategoryScreen(),
    },
  ];

  List<Map<String, dynamic>> get sliderCategories =>
      allCategories.take(4).toList();

  List<Map<String, dynamic>> get exploreCategories =>
      allCategories.skip(4).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= sliderCategories.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Greeting
            const Text(
              "Popular Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            /// SLIDER (First 4 only)
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: sliderCategories.length,
                itemBuilder: (context, index) {
                  final category = sliderCategories[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => category["screen"],
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                category["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned( 
                              bottom: 20,
                              left: 20,
                              child: Text(
                                category["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            /// Explore More
            const Text(
              "Explore More",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            /// GRID (Remaining items)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exploreCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = exploreCategories[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => item["screen"],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              item["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              item["title"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
