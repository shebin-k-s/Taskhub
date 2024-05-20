import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/Screens/auth_screen/auth_screen.dart';
import 'package:taskhub/api/data/projectDetails/projectDetails.dart';
import 'package:taskhub/api/project_details/project.dart';
import 'package:taskhub/main.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _expandedIndex = -1;
  String _selectedCategory = 'ALL';

  late List<Project> projectList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final _sharedPref = await SharedPreferences.getInstance();
      final eId = _sharedPref.getString(EID);

      final projects =
          await ProjectdetailsDB().getProjects(eId!, _selectedCategory);

      setState(() {
        projectList = projects;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String name = snapshot.data!;
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black12,
            appBar: AppBar(
              backgroundColor: Colors.black12,
              title: Text(
                name,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notification_add_sharp,
                    color: Colors.white,
                  ),
                  label: const Text(''),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
              leading: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(Icons.menu),
              ),
            ),
            drawer: Drawer(
              backgroundColor: Colors.black,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28.0,
                          backgroundImage:
                              NetworkImage('https://picsum.photos/200/300'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Employee ID: 123456',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ListTile(
                    title: Text('Skills',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skill 1',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Skill 2',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Skill 3',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: TextButton.icon(
                      onPressed: () {
                        // Add functionality to add new skills
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add Skill',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => AuthScreen(),
                              ));
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Your Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100, // Adjust height according to your design
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildButton("ALL"),
                          buildButton("INPROGRESS"),
                          buildButton("PENDING"),
                          buildButton("COMPLETE"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final pName = projectList[index].pId?.pName!;
                      final pRole = projectList[index].techName;
                      final deadLine = projectList[index].endDate;
                      final coworkers = projectList[index].coWorkers;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.orange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Project Name:${pName} ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Project Role: ${pRole}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Deadline: ${deadLine}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Coworkers",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      final name = coworkers[index].eId?.eName;
                                      final email = coworkers[index].eId?.email;
                                      final techName =
                                          coworkers[index].techName;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            name!,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            email!,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            techName!,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: coworkers!.length,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 4,
                      );
                    },
                    itemCount: projectList.length,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _selectedCategory==text?Colors.purple: Colors.white,
        ),
        child: TextButton(
          onPressed: () async {
            final _sharedPref = await SharedPreferences.getInstance();
            final eId = _sharedPref.getString(EID);
            setState(() {
              _selectedCategory = text;
            });
            final projects =
                await ProjectdetailsDB().getProjects(eId!, _selectedCategory);

            setState(() {
              projectList = projects;
            });
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getName() async {
    final SharedPreferences _sharedPref = await SharedPreferences.getInstance();

    return _sharedPref.getString(NAME);
  }
}
