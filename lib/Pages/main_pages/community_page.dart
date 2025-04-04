import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:utilwise/Pages/main_pages/navigation_page.dart';
import 'package:utilwise/Pages/main_pages/object_page.dart';
import 'package:utilwise/Pages/profile_pages/profile_page.dart';
import 'package:utilwise/screens/add_screens/add-recurring-expense.dart';

import '../../components/expense.dart';
import '../../components/object.dart';
import '../../provider/data_provider.dart';
import '../add_from_pages/add_from_community_page.dart';
import '../group_member_pages/add_member_page.dart';
import '../group_member_pages/community_info_page.dart';
import '../logs_notification_pages/logs_notification.dart';
import 'no_internet_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key, required this.creatorTuple}) : super(key: key);
  final String creatorTuple;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // int clickedObject = 0;
  String objectName = '';
  TextEditingController searchController = TextEditingController();
  Iterable<Widget>? allMiscExpenses;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final providerCommunity = Provider.of<DataProvider>(context, listen: false);
    return StreamBuilder<bool>(
        stream: connectivityStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return buildScaffold(providerCommunity);
            } else {
              return const NoInternetPage();
            }
          } else {
            return buildScaffold(providerCommunity);
          }
        });
  }

  buildScaffold(providerCommunity) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF56D0A0),
        leading: Container(
          width: 30,
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavigationPage()),
              );
            },
          ),
        ),
        title: Row(
          children: <Widget>[
            Image.asset(
              '${providerCommunity.extractCommunityImagePathByName(widget.creatorTuple)}',
              width: 20,
              height: 20,
            ),
            SizedBox(width: 5),
            Flexible(
                child: Text(
              (widget.creatorTuple).split(":")[0],
              style: TextStyle(fontSize: 18),
            )),
          ],
        ),
        actions: [
          Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () async {
                  List<String> notification = await providerCommunity
                      .getNotification(widget.creatorTuple);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogsNotification(
                        creatorTuple: widget.creatorTuple,
                        notification: notification,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.notifications,
                  size: 20,
                ),
              )),
          Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityInfo(
                        creatorTuple: widget.creatorTuple,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.group,
                  size: 25,
                ),
              )),
          Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    // padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      radius: 15,
                      // radius: kSpacingUnit.w * 10,
                      child: Text(
                        "${providerCommunity.user?.username[0]}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )))
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, objectDataProvider, child) {
          return Container(
            child: SingleChildScrollView(
                child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 175,
                  width: 300,
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF56D0A0),
                      width: 2,
                    ),
                    color: Colors.green.shade50,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      backgroundColor: Color(0xFF56D0A0),
                                      heroTag: "BTN-5",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddMembers(
                                                creatorTuple:
                                                    widget.creatorTuple),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.person_add),
                                    ),
                                  ),
                                  const Text(
                                    "Add Member",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      backgroundColor: Color(0xFF56D0A0),
                                      heroTag: "BTN-6",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddFromCommunityPage(
                                                      selectedPage: 0,
                                                      creatorTuple:
                                                          widget.creatorTuple)),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Row(
                                          children: const [
                                            Text("+"),
                                            Icon(Icons.grid_view),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add Object",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: FloatingActionButton(
                                      backgroundColor: Color(0xFF56D0A0),
                                      heroTag: "BTN-7",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddFromCommunityPage(
                                                    selectedPage: 1,
                                                    creatorTuple:
                                                        widget.creatorTuple),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        child: Row(
                                          children: const [
                                            Text("+"),
                                            Icon(Icons.currency_rupee_outlined),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "Add Expense",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: FloatingActionButton(
                                        backgroundColor: Color(0xFF56D0A0),
                                        heroTag: "BTN-9",
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RecurringExpensesScreen(
                                                creatorTuple:
                                                    widget.creatorTuple,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(Icons.repeat),
                                      ),
                                    ),
                                    const Text(
                                      "Recurring Expenses",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // clickedObject = 0;
                        objectName = "";
                      });
                    },
                  ),
                ),
                DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 10),
                          child: TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color(0xFF56D0A0),
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.grid_view),
                              ),
                              Tab(
                                icon: Icon(Icons.list),
                              ),
                              Tab(icon: Icon(Icons.tab))
                            ],
                          ),
                        ),

                        Container(
                            height: isLoading
                                ? 300
                                : 300 +
                                    max<int>(
                                            (objectDataProvider
                                                    .objectUnresolvedExpenseMap[
                                                        widget.creatorTuple]![
                                                        "Misc"]!
                                                    .length +
                                                1),
                                            (objectDataProvider
                                                .communityObjectMap[
                                                    widget.creatorTuple]!
                                                .length)) *
                                        10.0,
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    child: Container(
                                      child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: (objectDataProvider
                                                      .communityObjectMap[
                                                          widget.creatorTuple]!
                                                      .length >
                                                  1)
                                              ? List.of(objectDataProvider
                                                  .communityObjectMap[
                                                      widget.creatorTuple]!
                                                  .map((e) {
                                                  if (!e.toLowerCase().contains(
                                                      searchController.text
                                                          .toLowerCase()
                                                          .trim())) {
                                                    return SizedBox(
                                                      height: 0,
                                                    );
                                                  }
                                                  if (e == "Misc") {
                                                    return SizedBox(
                                                      height: 0,
                                                    );
                                                  }
                                                  return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          objectName = e;
                                                        });
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ObjectPage(
                                                                    objectName:
                                                                        objectName,
                                                                    creatorTuple:
                                                                        widget
                                                                            .creatorTuple),
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          AnimatedContainer(
                                                            width: 180,
                                                            height: 150,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        2,
                                                                    vertical:
                                                                        5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        250),
                                                            curve: Curves
                                                                .easeInOut,
                                                            child: Object(
                                                              name: e,
                                                              creatorTuple: widget
                                                                  .creatorTuple,
                                                            ),
                                                          ),
                                                          // Text(e),
                                                        ],
                                                      ));
                                                }))
                                              : [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 30,
                                                        vertical: 50),
                                                    child: const Text(
                                                        "Hey there! Add your first object in this community using the Add Object button above!",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          // fontWeight: FontWeight.bold,
                                                        )),
                                                  )
                                                ]
                                          // )
                                          // ),
                                          // ),
                                          ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Miscellaneous Expenses",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              if (allMiscExpenses != null) {
                                                convertAndShareCSV();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'No expenses found'),
                                                      duration:
                                                          Duration(seconds: 3)),
                                                );
                                              }
                                            },
                                            child: Icon(Icons.file_download)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    isLoading
                                        ? SizedBox()
                                        : Column(
                                            children: List.of(miscExpenses(
                                                objectDataProvider,
                                                searchController)),
                                          ),
                                    isLoading
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 20),
                                            child: SingleChildScrollView(
                                              child: Text(
                                                  "Hey there! Add your first miscellaneous expense in this community using the Add Expense button above and selecting the Misc object!",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  )),
                                            ),
                                          )
                                        : miscExpenses(objectDataProvider,
                                                    searchController)
                                                .isEmpty
                                            ? Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 30,
                                                        vertical: 20),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                          "Hey there! Add your first miscellaneous expense in this community using the Add Expense button above and selecting the Misc object!",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                  ],
                                ), //Miscellaneous expense
                                Column(
                                  children: [
                                    Text(
                                      "Category Templates",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  // width: 50,
                                                  // height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Color(0xFF56D0A0),
                                                      width: 2,
                                                    ),
                                                    color: Colors.green.shade50,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 10,
                                                        spreadRadius: 1,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Icon(Icons
                                                                .apartment),
                                                            Container(
                                                              child:
                                                                  Text("Housing Societies"),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Adding objects...'),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3)),
                                                                );

                                                                bool res1 = await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Maintenance");
                                                                bool res2 = await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Bills");
                                                                bool res3 = await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Security");
                                                                bool res4 = await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Repairing");

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .removeCurrentSnackBar();

                                                                if (res1 &&
                                                                    res2 &&
                                                                    res3 &&
                                                                    res4) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          'Objects added successfully!'),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          'Error in adding objects!'),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Icon(Icons
                                                                  .add), // Plus button
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text("Maintenance"),
                                                                  Text(
                                                                      "Bills"),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text("Security"),
                                                                  Text(
                                                                      "Repairing")
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                // width: 50,
                                                // height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Color(0xFF56D0A0),
                                                    width: 2,
                                                  ),
                                                  color: Colors.green.shade50,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 10,
                                                      spreadRadius: 1,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Icon(Icons.menu_book),
                                                          Container(
                                                            child: Text(
                                                                "Education"),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Adding objects...'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3)),
                                                              );

                                                              bool res1 =
                                                                  await providerCommunity
                                                                      .addObject(
                                                                          widget
                                                                              .creatorTuple,
                                                                          "Fees");
                                                              bool res2 = await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Books");
                                                              bool res3 = await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Stationary");
                                                              bool res4 = await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Uniform");

                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .removeCurrentSnackBar();

                                                              if (res1 &&
                                                                  res2 &&
                                                                  res3 &&
                                                                  res4) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Objects added successfully!'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        'Error in adding objects!'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Icon(Icons
                                                                .add), // Plus button
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text("Fees"),
                                                                Text("Books"),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                    "Stationary"),
                                                                Text("Uniform")
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              // width: 50,
                                              // height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(0xFF56D0A0),
                                                  width: 2,
                                                ),
                                                color: Colors.green.shade50,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(Icons
                                                            .emoji_food_beverage),
                                                        Container(
                                                          child:
                                                              Text("Family Household"),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Adding objects...'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3)),
                                                            );

                                                            bool res1 =
                                                                await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Rent");

                                                            bool res2 =
                                                                await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Groceries");

                                                            bool res3 = await providerCommunity
                                                                .addObject(
                                                                    widget
                                                                        .creatorTuple,
                                                                    "Utility Bills");

                                                            bool res4 =
                                                                await providerCommunity
                                                                    .addObject(
                                                                        widget
                                                                            .creatorTuple,
                                                                        "Repairs");
                                                            bool res5 =
                                                            await providerCommunity
                                                                .addObject(
                                                                widget
                                                                    .creatorTuple,
                                                                "Subscription");

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .removeCurrentSnackBar();

                                                            if (res1 &&
                                                                res2 &&
                                                                res3 &&
                                                                res4 &&
                                                                res5
                                                                  ) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Objects added successfully!'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                ),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Error in adding objects!'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Icon(Icons
                                                              .add), // Plus button
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text("Rent"),
                                                              Text("Groceries"),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                  "Utility Bills"),
                                                              Text("Repairs")
                                                            ],
                                                          ),
                                                        ),

                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                  "Subscriptions")
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Container(
                                            // width: 50,
                                            // height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(0xFF56D0A0),
                                                width: 2,
                                              ),
                                              color: Colors.green.shade50,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(Icons.shopping_cart),
                                                      Container(
                                                        child: Text("Office Teams"),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Adding objects...'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3)),
                                                          );

                                                          bool res1 =
                                                              await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Office Supplies");
                                                          bool res2 =
                                                              await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Team Lunch");
                                                          bool res3 =
                                                              await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Software Subscriptions");
                                                          bool res4 =
                                                              await providerCommunity
                                                                  .addObject(
                                                                      widget
                                                                          .creatorTuple,
                                                                      "Travel");
                                                          bool res5 =
                                                          await providerCommunity
                                                              .addObject(
                                                              widget
                                                                  .creatorTuple,
                                                              "Events");

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .removeCurrentSnackBar();

                                                          if (res1 &&
                                                              res2 &&
                                                              res3 &&
                                                              res4 &&
                                                              res5) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Objects added successfully!'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              ),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Error in adding objects!'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Icon(Icons
                                                            .add), // Plus button
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text("Office Supplies"),
                                                            Text("Events"),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text("Team Lunch"),

                                                            Text("Travel")
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Text("Software Subscriptions"),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.withOpacity(0),
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 4),
              child: FloatingActionButton(
                backgroundColor: Color(0xFF56D0A0),
                heroTag: "BTN-13",
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Icon(Icons.home),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 4),
              child: FloatingActionButton(
                backgroundColor: Color(0xFF56D0A0),
                heroTag: "BTN-8",
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          DataProvider dataProvider =
                              Provider.of<DataProvider>(context, listen: false);
                          const snackbar1 = SnackBar(
                            content: Text("Refreshing..."),
                            duration: Duration(seconds: 4),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar1);
                          await dataProvider
                              .getCommunityDetails(widget.creatorTuple);
                        } catch (error) {
                          print(error);
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                child: Icon(Icons.sync),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Stream<bool> get connectivityStream =>
      Connectivity().onConnectivityChanged.map((List<ConnectivityResult> result) {
        return result != ConnectivityResult.none;
      });

  Iterable<Widget> miscExpenses(
      DataProvider objectDataProvider, TextEditingController searchController) {
    Iterable<Widget> miscExpenses = objectDataProvider
            .objectUnresolvedExpenseMap[widget.creatorTuple]!["Misc"]
        as Iterable<Widget>;
    if (miscExpenses.firstOrNull == null) {
      return [];
    }
    for (int i = 0; i < miscExpenses.length; i++) {
      Expense expense = miscExpenses.elementAt(i) as Expense;
      if (!expense.description
          .toLowerCase()
          .contains(searchController.text.toLowerCase().trim())) {
        miscExpenses = miscExpenses.where((element) => element != expense);
      }
    }
    allMiscExpenses = miscExpenses;
    return miscExpenses;
  }

  Future<void> convertAndShareCSV() async {
    // Convert expenses data to CSV format
    List<List<dynamic>> csvData = [
      // Add header row if needed
      ['Creator', 'Amount', 'Date', 'Is View Only', 'Description'],
      for (Expense expense in allMiscExpenses! as List<Expense>)
        [
          expense.creator,
          expense.amount,
          expense.date,
          expense.isViewOnly,
          expense.description
        ],
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    // Get the directory for storing the CSV file
    Directory directory = await getTemporaryDirectory();
    File file = File('${directory.path}/data.csv');

    // Write the CSV data to the file
    await file.writeAsString(csv);

    // Share the CSV file
    Share.shareXFiles([XFile('${directory.path}/data.csv')], text: 'CSV file');

  }
}
