import 'package:dompetku/models/transaction.dart';
import 'package:dompetku/models/transaction_data.dart';
import 'package:dompetku/screens/groups_screen.dart';
import 'package:dompetku/screens/transactions_screen.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const String id = 'tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<String> _titles = [
    'Transactions',
    'Categories',
    'Payees',
  ];
  int _selectedPageIndex = 0;
  TransactionsFilterOption _filter = TransactionsFilterOption.All;

  String _getTitle() {
    String filterText = '';
    if (0 != _selectedPageIndex) {
      switch (_filter) {
        case TransactionsFilterOption.ThisMonth:
          filterText = ' (This Month)';
          break;
        case TransactionsFilterOption.LastMonth:
          filterText = ' (Last Month)';
          break;
        default:
      }
    }
    return '${_titles[_selectedPageIndex]}$filterText';
  }

  Widget _getPage() {
    if (1 == _selectedPageIndex) {
      return GroupsScreen(
        transactionsGroupingOption: TransactionsGroupingOption.ByCategory,
        transactionsFilterOption: _filter,
      );
    } else if (2 == _selectedPageIndex) {
      return GroupsScreen(
        transactionsGroupingOption: TransactionsGroupingOption.ByPayee,
        transactionsFilterOption: _filter,
      );
    } else {
      return TransactionsScreen();
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: (0 == _selectedPageIndex)
            ? null
            : <Widget>[
                PopupMenuButton(
                  onSelected: (TransactionsFilterOption selectedValue) {
                    setState(() {
                      _filter = selectedValue;
                    });
                  },
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('This Month'),
                      value: TransactionsFilterOption.ThisMonth,
                    ),
                    PopupMenuItem(
                      child: Text('Last Month'),
                      value: TransactionsFilterOption.LastMonth,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: TransactionsFilterOption.All,
                    ),
                  ],
                ),
              ],
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellowAccent,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.attach_money),
            title: Text('Transactions'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.people),
            title: Text('Payees'),
          ),
        ],
      ),
    );
  }
}
