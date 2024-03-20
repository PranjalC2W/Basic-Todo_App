import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'databaseDB.dart';

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

  @override
  void initState() {
    super.initState();
    databaseFun();
  }

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
          return SingleChildScrollView(
            child: Padding(
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
                      color: Color.fromARGB(210, 101, 140, 192),
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
                          color: Color.fromARGB(210, 101, 140, 192),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                          color: Color.fromARGB(210, 101, 140, 192),
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
                          color: Color.fromARGB(210, 101, 140, 192),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                          Color.fromARGB(210, 101, 140, 192),
                        ),
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
  List imageList = [
    "assets/images/person.png",
    "assets/images/female.png",
    "assets/images/dr.png",
    "assets/images/professor.png"
  ];
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
        backgroundColor: const Color.fromARGB(210, 101, 140, 192),
        title: const Text(
          "Todo List App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
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
                              child: Image.asset(
                                  imageList[index % imageList.length])),
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
                                  color: const Color.fromARGB(255, 44, 39, 39)),
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
                                color: Color.fromARGB(210, 101, 140, 192),
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
                                color: Color.fromARGB(210, 101, 140, 192),
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
        backgroundColor: const Color.fromARGB(210, 101, 140, 192),
        onPressed: () {
          showMyBottomsheet(false);
          titleController.clear();
          descController.clear();
          dateController.clear();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
