import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/Screens/admin_screen/widgets/add_screen.dart';
import 'package:taskhub/Screens/admin_screen/widgets/notification_screen.dart';
import 'package:taskhub/Screens/admin_screen/widgets/project_screen.dart';
import 'package:taskhub/Screens/auth_screen/auth_screen.dart';
import 'package:taskhub/api/data/admin/admin.dart';
import 'package:taskhub/api/employee_model/employee.dart';
import 'package:taskhub/api/project_details/co_worker.dart';
import 'package:taskhub/api/project_details/project.dart';
import 'package:taskhub/main.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> skills = ['Skill 1', 'Skill 2', 'Skill 3'];

  List<Employee> employee = [];
  List<Project> projectList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      print("calling");
      final emp = await AdminDB().getEmployees();
      final project = await AdminDB().getAllProjects();

      setState(() {
        employee = emp ?? [];
        projectList = project;
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
                name.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notification_add_sharp,
                    color: Colors.white,
                  ),
                  label: const Text(''),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(color: Colors.white), // Change color here
                    ),
                  ),
                ),
              ],
              leading: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Icon(Icons.menu)),
            ),
            drawer: Drawer(
              backgroundColor: const Color.fromARGB(255, 58, 58, 58),
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
                  ListTile(
                    title: Text(
                      'Skills',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: skills.length,
                          itemBuilder: (context, index) {
                            return Text(
                              skills[index],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
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
                  TextButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Employees',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              print("press");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddScreen();
                                },
                              ).then((value) async {
                                await fetchData();
                              });
                            },
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: employee.length,
                      itemBuilder: (BuildContext context, int index) {
                        final name = employee[index].eName;
                        final email = employee[index].email;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    name!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    email!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'Skills:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: employee[index]
                                        .skills!
                                        .map((skill) => Text(
                                              skill,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Projects',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              print("press");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ProjectScreen();
                                },
                              ).then((value) async {
                                await fetchData();
                              });
                            },
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: ListView.builder(
                      itemCount: projectList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final pName = projectList[index].pId!.pName;
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');

                        final startDateString =
                            projectList[index].pId!.startDate;
                        final endDateString = projectList[index].pId!.endDate;

                        final startDate = DateTime.parse(startDateString!);
                        final endDate = DateTime.parse(endDateString!);

                        final formattedStartDate = formatter.format(startDate);
                        final formattedEndDate = formatter.format(endDate);
                        final coworkers = projectList[index].coWorkers;

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Project Name: ${pName}"),
                                  Text("Start Date: ${formattedStartDate}"),
                                  Text("end Date: ${formattedEndDate}"),
                                  Text("Project Members : "),
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final eName = coworkers[index].eId!.eName;
                                      final email = coworkers[index].eId!.email;
                                      final status = coworkers[index].status;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(eName!),
                                          Text(email!),
                                          Text(status!),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 1,
                                      );
                                    },
                                    itemCount: coworkers!.length,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<String?> getName() async {
    final SharedPreferences _sharedPref = await SharedPreferences.getInstance();

    return _sharedPref.getString(NAME);
  }
}
