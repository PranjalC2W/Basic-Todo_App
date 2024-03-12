import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

dynamic database;

//insert data
Future importData(Todo obj) async {
  final localDB = await database;
  await localDB.insert(
    "todoInfo",
    obj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//getdata
Future<List<Todo>> getData() async {
  final localDB = await database;
  List<Map<String, dynamic>> listData = await localDB.query("todoInfo");
  return List.generate(listData.length, (i) {
    return Todo(
      taskId: listData[i]['taskId'],
      title: listData[i]['title'],
      desc: listData[i]['desc'],
      date: listData[i]['date'],
    );
  });
}

//deleteTask
Future deleteTask(Todo todoObj) async {
  final localDB = await database;
  await localDB.delete(
    'todoInfo',
    where: 'taskId=?',
    whereArgs: [todoObj.taskId],
  );
}

//update task
Future updateTask(Todo todoobj) async {
  final localDB = await database;
  await localDB.update(
    "todoInfo",
    todoobj.toMap(),
    where: 'taskId=?',
    whereArgs: [todoobj.taskId],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    path.join(await getDatabasesPath(), "ToDoDB.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE todoInfo(taskId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, date TEXT)');
    },
  );
  getData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class Todo {
  int? taskId;
  String title;
  String desc;
  String date;
  Todo(
      {this.taskId,
      required this.title,
      required this.desc,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'title:$title,desc:$desc,date:$date';
  }
}

class _TodoAppState extends State<TodoApp> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  //bool isedit=false;
  void showMyBottomsheet(bool isedit, [Todo? todoObj]) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )),
        isDismissible: true,
        context: context,
        builder: ((BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Create Task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title:",
                      style: TextStyle(
                        color: Color.fromRGBO(2, 167, 177, 1),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Description :",
                      style: TextStyle(
                        color: Color.fromRGBO(2, 167, 177, 1),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'Enter description:',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Date :",
                      style: TextStyle(
                        color: Color.fromRGBO(2, 167, 177, 1),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          hintText: 'select date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                        readOnly: true,
                        onTap: () async {
                          //pick the data from the date picker
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2025));
                          //format the date into the required format out the date
                          String formatDate =
                              DateFormat.yMMMd().format(pickedDate!);
                          setState(() {
                            dateController.text = formatDate;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromRGBO(2, 167, 177, 1)),
                    ),
                    onPressed: () {
                      if (isedit == true) {
                        submit(isedit, todoObj);
                      } else {
                        submit(isedit);
                      }

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        }));
  }

  Future getallTask() async {
    List tasklist = await getData();
    setState(() {
      cardlist = tasklist;
    });
  }

  List cardlist = [];
  List<Color> colorlist = [
    const Color.fromRGBO(250, 232, 232, 1),
    const Color.fromRGBO(232, 237, 250, 1),
    const Color.fromRGBO(250, 249, 232, 1),
    const Color.fromRGBO(250, 232, 250, 1),
  ];

  void submit(bool isedit, [Todo? todoObj]) {
    if (titleController.text.trim().isNotEmpty &&
        descController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (!isedit) {
        setState(() {
          // cardlist.add(
          //   Todo(
          //     title: titleController.text.trim(),
          //     desc: descController.text.trim(),
          //     date: dateController.text.trim()
          //     )

          //     );

          importData(Todo(
              title: titleController.text,
              desc: descController.text,
              date: dateController.text));
        });
      } else {
        setState(() {
          todoObj!.title = titleController.text.trim();
          todoObj.date = dateController.text.trim();
          todoObj.desc = descController.text.trim();
          updateTask(todoObj);
        });
      }
    }
    titleController.clear();
    descController.clear();
    dateController.clear();
  }

//edit task
  void editTask(Todo todoObj) {
    titleController.text = todoObj.title;
    descController.text = todoObj.desc;
    dateController.text = todoObj.date;

    showMyBottomsheet(true, todoObj);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getallTask();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        title: const Text(
          "Todo List App",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: cardlist.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
              margin: const EdgeInsets.all(15),
              width: 330,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorlist[index % colorlist.length],
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      offset: Offset(10, 10),
                      blurRadius: 10,
                    )
                  ]),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.07),
                                    blurRadius: 10,
                                  ),
                                ]),
                            child: Image.network(
                                "https://www.shareicon.net/download/2017/01/12/870452_list.ico"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              SizedBox(
                                width: 243,
                                child: Text(
                                  cardlist[index].title,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 243,
                                child: Text(
                                  cardlist[index].desc,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Row(
                          children: [
                            Text(
                              cardlist[index].date,
                              style: GoogleFonts.quicksand(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color.fromRGBO(132, 132, 132, 1)),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  editTask(cardlist[index]);
                                });
                              },
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Color.fromRGBO(2, 167, 177, 1),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  deleteTask(cardlist[index]);
                                });
                              },
                              child: const Icon(
                                Icons.delete_outline_outlined,
                                color: Color.fromRGBO(2, 167, 177, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        onPressed: () {
          showMyBottomsheet(false);
          titleController.clear();
          descController.clear();
          dateController.clear();
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
