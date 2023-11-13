import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/color.dart';
import 'package:qena_movie/main.dart';
import 'package:qena_movie/screens/userPage/AddUser.dart';
import 'package:qena_movie/widgets/My_Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  UserMainState createState() => UserMainState();
}

class UserMainState extends State<UserMain> {
  bool isAdmin = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  @override
  String empId = '';

  @override
  void initState() {
    super.initState();
  }

  String searchQuery = '';

  Future<List<dynamic>> getData() async {
    String endpointUrl;
    endpointUrl = '${BASE_URL}api/getuser?q=$searchQuery';

    var response = await http.get(Uri.parse(endpointUrl));
    return json.decode(response.body);
  }

  Future updateUser(String id, Map<String, dynamic> data) async {
    var url = Uri.parse('${BASE_URL}api/update-user45/$id');
    var response = await http.put(url, body: data);
    return json.decode(response.body);
  }

  Future<void> DeleteUser(String id) async {
    final url = '${BASE_URL}api/delete-user/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // Deletion successful
      print('request data with id $id deleted successfully.');
    } else {
      // Handle deletion failure
      print(
          'Failed to delete request data with id $id. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer34(),
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search Employee',
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.testColor1,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: CustomColors.testColor1,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Adduser(),
            ),
          );
          debugPrint('Clicked FloatingActionButton Button');
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          // if (snapshot.hasError) print(snapshot.error);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'user no available',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'user no availabl',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return snapshot.hasData
                ? RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        List<dynamic> list = snapshot.data!;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          padding: const EdgeInsets.symmetric(
                            // horizontal: 20,
                            vertical: 6,
                          ),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Slidable(
                            closeOnScroll: true,
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              textColor: Colors.black,
                              collapsedIconColor: CustomColors.testColor1,
                              iconColor: CustomColors.testColor1,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    list[index]['name'],
                                    style: GoogleFonts.splineSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    list[index]['empid'],
                                    style: GoogleFonts.splineSans(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Name: ${list[index]['name']}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'Email: ${list[index]['email']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Address: ${list[index]['address']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Mobile: ${list[index]['mobile']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Org Id: ${list[index]['oid']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'status: ${list[index]['status']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Role: ${list[index]['role']}',
                                                    style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  // Rest of the Text widgets...
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 17),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.all(4),
                                                child: Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            String status =
                                                                list[index]
                                                                    ['status'];
                                                            if (status !=
                                                                    'active' &&
                                                                status !=
                                                                    'inactive') {
                                                              status =
                                                                  'inactive'; // Set the default value to 'Disapprove' if the current status is not 'Approve' or 'Disapprove'
                                                            }

                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Current Status: ${list[index]['status']}'),
                                                              content:
                                                                  StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setState) {
                                                                  return Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      DropdownButton<
                                                                          String>(
                                                                        value:
                                                                            status,
                                                                        onChanged:
                                                                            (String?
                                                                                newValue) {
                                                                          if (newValue !=
                                                                              null) {
                                                                            setState(() {
                                                                              status = newValue;
                                                                            });
                                                                          }
                                                                        },
                                                                        items: const [
                                                                          DropdownMenuItem(
                                                                            value:
                                                                                'active',
                                                                            child:
                                                                                Text('active'),
                                                                          ),
                                                                          DropdownMenuItem(
                                                                            value:
                                                                                'inactive',
                                                                            child:
                                                                                Text('inactive'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var updateData =
                                                                        {
                                                                      'status':
                                                                          status,
                                                                    };
                                                                    var response =
                                                                        await updateUser(
                                                                      list[index]
                                                                          [
                                                                          '_id'],
                                                                      updateData,
                                                                    );
                                                                    // Handle the response as needed
                                                                    if (response !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        list[index]['status'] =
                                                                            status; // Update the status in the list
                                                                      });
                                                                    }
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            230,
                                                                            11,
                                                                            11),
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            243,
                                                                            194,
                                                                            33),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                  ),
                                                                  child: const Text(
                                                                      'Action'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child:
                                                          const Text('Action'),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              13.2),
                                                      child: ElevatedButton(
                                                        onPressed: _isUpdating
                                                            ? null
                                                            : () async {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    String
                                                                        name =
                                                                        list[index]
                                                                            [
                                                                            'name'];
                                                                    String
                                                                        username =
                                                                        list[index]
                                                                            [
                                                                            'username'];
                                                                    String
                                                                        mobile =
                                                                        list[index]
                                                                            [
                                                                            'mobile'];
                                                                    String
                                                                        gender =
                                                                        list[index]
                                                                            [
                                                                            'gender'];
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Update employee Name: ${list[index]['name']}'),
                                                                      content:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          TextField(
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Name',
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              name = value;
                                                                            },
                                                                            controller:
                                                                                TextEditingController(text: name),
                                                                          ),
                                                                          TextField(
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Username',
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              username = value;
                                                                            },
                                                                            controller:
                                                                                TextEditingController(text: username),
                                                                          ),
                                                                          TextField(
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Mobile',
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              mobile = value;
                                                                            },
                                                                            controller:
                                                                                TextEditingController(text: mobile),
                                                                          ),
                                                                          TextField(
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              labelText: 'Gender',
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              gender = value;
                                                                            },
                                                                            controller:
                                                                                TextEditingController(text: gender),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Cancel'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: _isUpdating
                                                                              ? null
                                                                              : () async {
                                                                                  setState(() {
                                                                                    _isUpdating = true; // Start showing the progress indicator
                                                                                  });

                                                                                  var updateData = {
                                                                                    'name': name,
                                                                                    'mobile': mobile,
                                                                                    'gender': gender,
                                                                                    'username': username,
                                                                                  };
                                                                                  var response = await updateUser(
                                                                                    list[index]['_id'],
                                                                                    updateData,
                                                                                  );

                                                                                  // Handle the response as needed
                                                                                  Navigator.pop(context);
                                                                                  setState(() {
                                                                                    // Update the data state
                                                                                  });

                                                                                  setState(() {
                                                                                    _isUpdating = false; // Stop showing the progress indicator
                                                                                  });
                                                                                },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            foregroundColor: const Color.fromARGB(
                                                                                255,
                                                                                230,
                                                                                11,
                                                                                11),
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                243,
                                                                                194,
                                                                                33),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 8,
                                                                            ),
                                                                          ),
                                                                          child: _isUpdating
                                                                              ? CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                )
                                                                              : const Text('Update'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                        child: const Text(
                                                            'Update'),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.2),
                                                        child: ElevatedButton(
                                                          onPressed: _isDeleting
                                                              ? null
                                                              : () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Confirm Deletion'),
                                                                        content:
                                                                            const Text('Are you sure you want to delete this user?'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Cancel'),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: _isDeleting
                                                                                ? null
                                                                                : () async {
                                                                                    setState(() {
                                                                                      _isDeleting = true; // Start showing the progress indicator
                                                                                    });

                                                                                    Navigator.pop(context); // Close the confirmation dialog
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (context) => AlertDialog(
                                                                                        title: const Text('Deleting request'),
                                                                                        content: const Text('Please wait...'),
                                                                                      ),
                                                                                    );

                                                                                    try {
                                                                                      await DeleteUser(list[index]['_id']);
                                                                                      Navigator.pop(context); // Close the "Deleting Employee" dialog

                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => AlertDialog(
                                                                                          title: const Text('Success'),
                                                                                          content: const Text('Request deleted successfully.'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                                setState(() {});
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                foregroundColor: Colors.white,
                                                                                                backgroundColor: Colors.red,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                                ),
                                                                                                padding: const EdgeInsets.symmetric(
                                                                                                  horizontal: 16,
                                                                                                  vertical: 8,
                                                                                                ),
                                                                                              ),
                                                                                              child: const Text('OK'),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    } catch (error) {
                                                                                      Navigator.pop(context); // Close the "Deleting Employee" dialog

                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => AlertDialog(
                                                                                          title: const Text('Error'),
                                                                                          content: const Text('Failed to delete employee data.'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Text('OK'),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    setState(() {
                                                                                      _isDeleting = false; // Stop showing the progress indicator
                                                                                    });
                                                                                  },
                                                                            child: _isDeleting
                                                                                ? CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                  )
                                                                                : const Text('Confirm'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                          child: const Text(
                                                              'Delete'),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 170.0, left: 50.0),
                    child: const Text(
                      'Loading.....!!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.blue,
                      ),
                    ),
                  );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        padding: const EdgeInsets.all(10),
        color: CustomColors.testColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MovieApp23(),
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
