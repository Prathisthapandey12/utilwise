import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/data_provider.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  late Future<List<(String, String)>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DataProvider>(context, listen: false);
    final String? userPhoneNumber = provider.user?.phoneNo;

    if (userPhoneNumber != null) {
      _requestsFuture = provider.fetchAllRequests(userPhoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final String? userPhoneNumber = provider.user?.phoneNo;

    if (userPhoneNumber == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Pending Requests")),
        body: Center(child: Text("Error: User not logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Pending Requests")),
      body: FutureBuilder<List<(String, String)>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No pending requests."));
          }

          var requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];
              String communityName = request.$1;
              String communityId = request.$2;

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Community: $communityName"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          bool success = await provider.acceptRequest(communityId, userPhoneNumber);
                          if (success) {
                            setState(() {
                              _requestsFuture = provider.fetchAllRequests(userPhoneNumber);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Request approved"))
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await provider.deleteRequest(communityId, userPhoneNumber);
                          setState(() {
                            _requestsFuture = provider.fetchAllRequests(userPhoneNumber);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Request rejected"))
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}