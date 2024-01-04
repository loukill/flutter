import 'package:flutter/material.dart';
import 'package:flutter_dashboard/model/user.dart';
import 'package:flutter_dashboard/services/userservice.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late Future<List<User>> futureUsers;
  List<User> displayedUsers = [];
  TextEditingController searchController = TextEditingController();
  UserService userService = UserService();
  int sortColumnIndex = 0; // Index of the column to sort
  bool isAscending = true; // Sort order

  @override
  void initState() {
    super.initState();
    // Call the instance method getAllUsers directly in initState
    futureUsers = userService.getAllUsers();
  }

  void _filterUsers(String query) {
    futureUsers.then((users) {
      setState(() {
        displayedUsers = users.where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.numTel.toString().contains(query)).toList();
        // Sort the displayedUsers by name
        _sortDisplayedUsers();
      });
    });
  }

  void _sortDisplayedUsers() {
    if (isAscending) {
      displayedUsers.sort((a, b) => getField(a).compareTo(getField(b)));
    } else {
      displayedUsers.sort((a, b) => getField(b).compareTo(getField(a)));
    }
  }

  String getField(User user) {
    switch (sortColumnIndex) {
      case 0:
        return user.name;
      case 1:
        return user.numTel.toString();
      // Add more cases if you have additional columns to sort
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearch(displayedUsers));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<User> users = snapshot.data!;
            if (users.isEmpty) {
              return Center(
                child: Text('No users found.'),
              );
            }
            displayedUsers = users; // Display all users initially
            _sortDisplayedUsers(); // Sort by name
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: DataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: isAscending,
                columns: [
                  DataColumn(
                    label: Text('Name'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sortColumnIndex = columnIndex;
                        isAscending = ascending;
                        _sortDisplayedUsers();
                      });
                    },
                  ),
                  DataColumn(
                    label: Text('Phone Number'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sortColumnIndex = columnIndex;
                        isAscending = ascending;
                        _sortDisplayedUsers();
                      });
                    },
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: displayedUsers.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          user.numTel.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Logic to ban the user
                                print('Banned user: ${user.name}');
                                userService.banUser(user.id.toString());
                              },
                              child: Text('Ban'),
                            ),
                            SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                // Logic to unban the user
                                print('Unbanned user: ${user.name}');
                                userService.unbanUser(user.id.toString());
                              },
                              child: Text('Unban'),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelectChanged: (selected) {
                      // Handle tap on user
                      print('Tapped user: ${user.name}');
                    },
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class UserSearch extends SearchDelegate<User> {
  final List<User> users;

  UserSearch(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Check if there are selected results, if not, close with null
        // close(context, query.isEmpty ? null : User());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? users
        : users.where((user) =>
            user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.numTel.toString().contains(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final user = suggestionList[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.numTel.toString()),
          onTap: () {
            // Handle tap on the suggested user
            print('Tapped user: ${user.name}');
            close(context, user);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserListView(),
  ));
}
