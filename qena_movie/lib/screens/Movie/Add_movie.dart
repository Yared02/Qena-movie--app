import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/theme_helper.dart';
import 'package:qena_movie/main.dart';
// import 'package:qena_movie/widget/navigation_drawer_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qena_movie/common/Color.dart';

import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qena_movie/widgets/My_Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController movieId = TextEditingController();
  final TextEditingController imdbID = TextEditingController();
  final TextEditingController Title = TextEditingController();
  final TextEditingController Year = TextEditingController();
  final TextEditingController Runtime = TextEditingController();
  final TextEditingController Genre = TextEditingController();
  final TextEditingController Director = TextEditingController();
  final TextEditingController Writer = TextEditingController();
  final TextEditingController Actors = TextEditingController();
  final TextEditingController selectDate = TextEditingController();
  final TextEditingController description = TextEditingController();

  final TextEditingController Plot = TextEditingController();
  final TextEditingController Language = TextEditingController();
  final TextEditingController Type = TextEditingController();
  final TextEditingController eidController = TextEditingController();

  final TextEditingController _oidController = TextEditingController();

  String? selectedFilePath;
  String? selectedFileName;
  String? selectedType;
  String? selectedLanguge;

  String _oId = '';
  String _empid = '';

  Future<void> _loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _oId = prefs.getString('oid') ?? '';
      _empid = prefs.getString('empid') ?? '';

      // oidController.text = _oId;
      eidController.text = _empid;
    });
  }

  Future<void> _saveValues(String empid, String oid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('empid', empid);
    await prefs.setString('oid', oid);

    setState(() {
      _oId = oid;
      _empid = empid;
    });
  }

  void initState() {
    super.initState();
    _loadSavedValues();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFilePath = file.path;
        selectedFileName = file.name;
      });
    } else {
      // User canceled the file picker dialog.
    }
  }

  bool _isLoading = false;

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start showing the progress indicator
      });
      FormData formData = FormData.fromMap({
        "eid": eidController.text,
        "oid": _oId,
        'movieId': movieId.text,
        'imdbID': imdbID.text,
        'description': description.text,
        'Director': Director.text,

        'Title': Title.text,
        // 'gender': _selectedGender,
        'Runtime': Runtime.text,
        'Genre': Genre.text,
        'releaseDate': selectDate.text, //dateinput
        'Writer': Writer.text,
        'Actors': Actors.text,
        'Plot': Plot.text,
        'Language': selectedLanguge, //Type
        'Type': selectedType,
        "file": await MultipartFile.fromFile(
          selectedFilePath!,
          filename: selectedFileName!,
        ),
      });
      try {
        var response = await dio.post("${BASE_URL}addMovie", data: formData);
        if (response.statusCode == 201) {
          // File uploaded successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" successfully")),
          );
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File upload failed")),
          );
        }
      } catch (e) {
        // Handle exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred")),
        );
      }
      setState(() {
        _isLoading = false; // Stop showing the progress indicator
      });
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Request(),
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    eidController.dispose();
    // _oId.dispose();
    movieId.dispose();
    imdbID.dispose();
    Title.dispose();
    Year.dispose();
    Runtime.dispose();

    Genre.dispose();
    Writer.dispose();
    Actors.dispose();
    Plot.dispose();
    Actors.dispose();
    Language.dispose();
    super.dispose();
  }

  @override
  void _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      selectDate.text = formattedDate;
    } else {
      print("Start date is not selected");
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      selectDate.text = formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer34(),
      appBar: AppBar(
        elevation: 0, // No shadow
        backgroundColor: CustomColors.testColor1,

        title: Text(
          "Add Movie",
          style: GoogleFonts.splineSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              // Add save functionality
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: CustomColors.testColor1,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MyApp77(),
          //   ),
          // );
          debugPrint('Clicked FloatingActionButton Button');
        },
        child: const Icon(Icons.home),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: movieId,
                decoration: ThemeHelper()
                    .textInputDecoration('enter movieId', 'Enter movieId'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter movieId';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: imdbID,
                // decoration: InputDecoration(labelText: 'Tendername Name'),
                decoration: ThemeHelper()
                    .textInputDecoration('imdbID', 'Enter  imdbID'),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Enter imdbID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Title,
                decoration:
                    ThemeHelper().textInputDecoration('Title', 'Title '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: description,
                decoration: ThemeHelper()
                    .textInputDecoration('Description', 'description '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Year,
                decoration:
                    ThemeHelper().textInputDecoration('Year', ' Enter Year '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Runtime,
                decoration: ThemeHelper()
                    .textInputDecoration('Runtime', 'please Enter Runtime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Runtime';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Genre,
                decoration:
                    ThemeHelper().textInputDecoration('Genre', 'Enter  Genre '),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Genre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                decoration:
                    ThemeHelper().textInputDecoration('Type', 'Enter Type'),
                style: TextStyle(
                  fontSize: 16, // Customize the font size
                  color: Colors.black, // Customize the text color
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a tyoe of movie';
                  }
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    value: 'Action',
                    child: Text('Action'),
                  ),
                  DropdownMenuItem(
                    value: 'Romance',
                    child: Text('Romance'),
                  ),
                  DropdownMenuItem(
                    value: 'War',
                    child: Text('War'),
                  ),
                  DropdownMenuItem(
                    value: 'Documentary',
                    child: Text('Documentary'),
                  ),
                  DropdownMenuItem(
                    value: 'Drama',
                    child: Text('Drama'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Director,
                decoration: ThemeHelper()
                    .textInputDecoration('Director', 'Enter Director'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Director';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Writer,
                decoration:
                    ThemeHelper().textInputDecoration('Writer', 'Enter Writer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Writer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Actors,
                decoration:
                    ThemeHelper().textInputDecoration('Actors', 'Enter Actors'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Actors';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: Plot,
                decoration:
                    ThemeHelper().textInputDecoration('Plot', 'Enter Plot'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Plot';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedLanguge,
                onChanged: (newValue) {
                  setState(() {
                    selectedLanguge = newValue;
                  });
                },
                decoration:
                    ThemeHelper().textInputDecoration('Type', 'Enter Languge'),
                style: TextStyle(
                  fontSize: 16, // Customize the font size
                  color: Colors.black, // Customize the text color
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Languge';
                  }
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'Amharic',
                    child: Text('Amharic'),
                  ),
                  DropdownMenuItem(
                    value: 'Indian',
                    child: Text('Indian'),
                  ),
                  DropdownMenuItem(
                    value: 'Arabic',
                    child: Text('Arabic'),
                  ),
                  DropdownMenuItem(
                    value: 'Spanish',
                    child: Text('Spanish'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                  width: 500, // Adjust the width as needed
                  child: TextField(
                    controller: selectDate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                      labelText: 'Release Date',
                      hintText: ' date',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    readOnly: true,
                    onTap: () => _selectStartDate(context),
                  )),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: pickFile,
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors
                            .testColor1, // Set the background color of the button
                        onPrimary: Colors.white, // Set the text color
                        textStyle: TextStyle(
                            fontSize: 16), // Set the font size of the text
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20), // Set the padding
                        // You can customize more properties here, such as elevation, shape, etc.
                      ),
                      child: Text('Select poster'),
                    ),
                    Text("SelectedFile  $selectedFileName"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 400,
                height: 35,
                child: ElevatedButton(
                  onPressed: selectedFilePath != null ? submitForm : null,
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors
                        .testColor1, // Set the background color of the button
                    onPrimary: Colors.white, // Set the text color
                    textStyle: TextStyle(
                        fontSize: 16), // Set the font size of the text
                    // Set the padding
                    // You can customize more properties here, such as elevation, shape, etc.
                  ),
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ),
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

  Widget dateField(BuildContext context, IconData icon,
      TextEditingController dateInput, String label) {
    return TextField(
      controller: dateInput,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              8.0), // Set the border radius of the text field
        ),
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: const TextStyle(
            color: CustomColors.testColor1), // Customize the label text style
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0), // Set the content padding of the text field
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
