import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:utils/database_helper.dart';

void main() {
  runApp(const UtilApp());
}

class UtilApp extends StatelessWidget {
  const UtilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _expenseController =
      TextEditingController(text: '0');

  @override
  void dispose() {
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dbHelper.queryAllRows(),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> data = snapshot.data ?? [];
          return ListView(
            children: _buildBody(data),
          );
        },
      ),
    );
  }

  _buildBody(data) {
    List<Widget> widgets = [];
    widgets.addAll(_buildCity());
    widgets.addAll(_buildCategory());
    widgets.addAll(_buildExpense());

    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _dbHelper.insert({
                    'city': _selectedCity,
                    'category': _selectedCategory,
                    'expense': double.parse(_expenseController.text),
                    'time': DateTime.now().toString(),
                  }).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '添加',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _dbHelper.queryAllRows().then((allRows) {
                    for (var ele in allRows) {
                      _dbHelper.delete(ele['id']).then((_) {
                        setState(() {});
                      });
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '清空',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Map<String, num> result = {};
    num total = 0;
    for (var ele in data) {
      total = total + ele['expense'];
      var category = ele['category'];
      var expense = ele['expense'];
      if (result[category] == null) {
        result[category] = expense;
      } else {
        result[category] = result[category]! + expense;
      }

      var city = ele['city'];
      if (result[city] == null) {
        result[city] = expense;
      } else {
        result[city] = result[city]! + expense;
      }
    }

    widgets.add(Text('总计花费 $total 元'));

    widgets.add(
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('类别'),
          Text('总数'),
          Text('占比'),
        ],
      ),
    );

    Map.fromEntries(
      result.entries.toList()
        ..sort(
          (a, b) => b.value.compareTo(a.value),
        ),
    ).forEach((key, value) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(key),
            Text(value.toStringAsFixed(2)),
            Text('${(value / total * 100).toStringAsFixed(2)}%'),
          ],
        ),
      );
    });

    for (var ele in data) {
      widgets.add(
        GestureDetector(
          onTap: () {
            _dbHelper.delete(ele['id']).then((_) {
              setState(() {});
            });
          },
          child: Text(
              '${ele['city']}, ${ele['category']}, ${ele['expense']}元, ${ele['time']}'),
        ),
      );
    }

    return widgets;
  }

  String _selectedCity = '北京';
  final List<String> _cities = ['北京', '南京', '苏州'];
  String _selectedCategory = '路费';
  final List<String> _categories = ['路费', '住宿', '吃饭'];

  _buildCity() {
    List<Widget> widgets = [];
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('城市'),
          DropdownButton<String>(
            value: _selectedCity, // 当前选中的值
            hint: const Text('请选择一个项目'), // 如果没有选中任何值时显示的提示文本
            items: _cities.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCity = newValue ?? '';
              });
            },
          ),
        ],
      ),
    );
    return widgets;
  }

  _buildCategory() {
    List<Widget> widgets = [];
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('花销类别'),
          DropdownButton<String>(
            value: _selectedCategory, // 当前选中的值
            hint: const Text('请选择一个项目'), // 如果没有选中任何值时显示的提示文本
            items: _categories.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue ?? '';
              });
            },
          ),
        ],
      ),
    );
    return widgets;
  }

  _buildExpense() {
    List<Widget> widgets = [];
    widgets.add(
      TextField(
        controller: _expenseController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: '人民币'),
      ),
    );
    return widgets;
  }
}
