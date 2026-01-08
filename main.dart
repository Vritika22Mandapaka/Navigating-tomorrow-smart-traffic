import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  int? id;
  String name;
  String email;

  User({this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _database;

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) {
      return User.fromMap(maps[index]);
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/aboutus': (context) => AboutUsScreen(),
        '/updates': (context) => UpdatesScreen(),
        '/profile': (context) => ProfileScreen(username: ""), // Initial username is empty
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeContent(),
    NavigationPage(),
    UpdatesScreen(),
    ProfileScreen(username: ""), // Initial username is empty
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigation',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Route Rovex'),
      backgroundColor: Color.fromARGB(255, 2, 127, 35),
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'login',
                child: Text('Login'),
              ),
              PopupMenuItem<String>(
                value: 'signup',
                child: Text('Signup'),
              ),
              PopupMenuItem<String>(
                value: 'aboutus',
                child: Text('About Us'),
              ),
            ];
          },
          onSelected: (String value) {
            if (value == 'login') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            } else if (value == 'signup') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
            } else if (value == 'aboutus') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
            }
          },
        ),
      ],
    );
  }
}
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white, // Add color to the search bar
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onSubmitted: (String query) {
                // Handle search here, show suggestions or navigate to results page
                // For simplicity, let's just print the query for now
                print('Search query submitted: $query');
              },
            ),
            SizedBox(height: 60.0),

            ElevatedButton.icon(
              onPressed: () {
                // Navigate to NavigationPage when Road Emergency button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationPage(),
                  ),
                );
              },
              icon: Icon(Icons.warning),
              label: Text('Road Emergency'),
            ),
            SizedBox(height: 35.0),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to NavigationPage when Recommended Path button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationPage(),
                  ),
                );
              },
              icon: Icon(Icons.directions),
              label: Text('Recommended Path'),
            ),
            SizedBox(height: 35.0),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to UpdatesScreen when Updates button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatesScreen(),
                  ),
                );
              },
              icon: Icon(Icons.update),
              label: Text('Updates'),
            ),
            SizedBox(height: 35.0),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to UpdatesScreen when Demographs & News button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatesScreen(),
                  ),
                );
              },
              icon: Icon(Icons.article),
              label: Text('Demographs & News'),
            ),
          ],
        ),
      ),
    );
  }
}
class RouteInfo {
  final String name;
  final String imageAssetPath;

  RouteInfo({required this.name, required this.imageAssetPath});
}

class NavigationPage extends StatelessWidget {
  final List<RouteInfo> routes = [
    RouteInfo(name: "Emergency Road", imageAssetPath: "assets/emergency_road.jpg"),
    RouteInfo(name: "Recommended Path 1", imageAssetPath: "assets/path1.jpg"),
    RouteInfo(name: "Recommended Path 2", imageAssetPath: "assets/path1.jpg"),
    RouteInfo(name: "Recommended Path 3", imageAssetPath: "assets/path1.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6), // Adjust the opacity as needed
          child: ListView.builder(
            itemCount: routes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  routes[index].name,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutePage(routeInfo: routes[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class RoutePage extends StatelessWidget {
  final RouteInfo routeInfo;

  RoutePage({required this.routeInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(routeInfo.imageAssetPath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class UpdatesScreen extends StatelessWidget {
  final List<NewsArticle> articles = [
    NewsArticle(
      title: 'Traffic Update: Increased Congestion During Rush Hour',
      description: 'Commuters are facing increased congestion during rush hour due to a combination of ongoing roadwork and a higher volume of vehicles. Plan your commute accordingly.',
      imageAsset: 'assets/traffic_congestion.jpg',
    ),
    NewsArticle(
      title: 'Traffic Update: Smooth Flow of Traffic After Road Maintenance',
      description: 'Following recent road maintenance, traffic is flowing smoothly in most areas. Enjoy a more efficient commute and drive safely.',
      imageAsset: 'assets/smooth_traffic.jpg',
    ),
    NewsArticle(
      title: 'Accident Report: Multi-Vehicle Collision on Highway',
      description: 'A multi-vehicle collision occurred on the highway earlier today, leading to temporary road closures. Emergency services are on the scene, and drivers are advised to take alternative routes.',
      imageAsset: 'assets/highway_collision.jpg',
    ),
    NewsArticle(
      title: 'Accident Report: Intersection Incident Causes Traffic Diversions',
      description: 'An accident occurred at a busy intersection, resulting in traffic diversions. Authorities are managing the situation, and commuters should expect delays in the affected area.',
      imageAsset: 'assets/intersection_accident.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Updates'), backgroundColor: Color.fromARGB(220, 6, 163, 50)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: NewsTile(article: articles[index]),
            );
          },
        ),
      ),
    );
  }
}
class NewsTile extends StatelessWidget {
  final NewsArticle article;

  NewsTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title, style: TextStyle(fontSize: 18.0)),
      contentPadding: EdgeInsets.all(8.0),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Image.asset(
            article.imageAsset,
            width: double.infinity,
            height: 150.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          Text(article.description),
        ],
      ),
    );
  }
}


class NewsArticle {
  final String title;
  final String description;
  final String imageAsset;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}


class ProfileScreen extends StatelessWidget {
  final String username;

  ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),backgroundColor: Color.fromARGB(220, 6, 163, 50)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), // Adjust the opacity as needed
              BlendMode.dstATop,
            ),
          ),
        ),
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username and Profile Photo
            ElevatedButton(
              onPressed: () {
                // Implement action for username and profile photo
                print('Username button pressed for $username');
              },
              child: Row(
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 8.0),
                  Text('Username: $username'),
                ],
              ),
            ),
            SizedBox(height: 50.0),

            // Date of Birth
            ElevatedButton(
              onPressed: () {
                // Implement action for date of birth
                print('Date of Birth button pressed');
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8.0),
                  Text('Date of Birth -24/Jan/1985'),
                ],
              ),
            ),
            SizedBox(height: 50.0),

            // Recently Navigated
            ElevatedButton(
              onPressed: () {
                // Implement action for recently navigated
                print('Recently Navigated button pressed');
              },
              child: Row(
                children: [
                  Icon(Icons.history),
                  Text('Recently Navigated - Vizag Railway Station'),
                ],
              ),
            ),
            SizedBox(height: 50.0),

            // Frequently Searched Areas
            ElevatedButton(
              onPressed: () {
                // Implement action for frequently searched areas
                print('Frequently Searched Areas button pressed');
              },
              child: Row(
                children: [
                  Icon(Icons.star),
                  Text('Frequently Searched Areas - Alipuram'),
                ],
              ),
            ),
            SizedBox(height: 50.0),

            // Emergency Contact
            ElevatedButton(
              onPressed: () {
                // Implement action for emergency contact
                print('Emergency Contact button pressed');
              },
              child: Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 8.0),
                  Text('Emergency Contact - +91xxxxxxxxxx'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    // Perform login action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(username: _usernameController.text),
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm the password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    // Perform signup action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(username: _emailController.text),
                      ),
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Traffic congestion poses a significant challenge in today\'s urban landscapes, '
                'with the surge in the number of vehicles on the roads. The traditional traffic '
                'light systems struggle to efficiently handle increasing vehicle queues at '
                'intersections. To address this issue, our innovative solution, titled "Navigating '
                'Tomorrow: Smart Traffic Management with Object Detection," integrates advanced '
                'technologies such as object detection, machine learning, and optimization techniques. '
                'This project aims to revolutionize the monitoring, control, and optimization of '
                'traffic flow, ultimately contributing to safer and healthier travel experiences.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Our system goes beyond conventional traffic management by employing machine learning '
                'algorithms to predict traffic patterns. This predictive capability enhances early '
                'accident detection, facilitating quicker emergency responses and improving overall '
                'road safety. Notably, ambulances can benefit from intelligent detection and signaling, '
                'ensuring they receive priority clearance, allowing them to reach critical situations '
                'promptly. Through the fusion of object detection and optimization strategies, our '
                'project presents a holistic and innovative approach to tackling the complex challenges '
                'faced by modern urban environments.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}