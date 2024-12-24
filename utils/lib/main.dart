import 'dart:ffi';

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _buildBody(),
      ),
    );
  }

  final Map<String, Map<String, List<int>>> _total = {};

  _buildBody() {
    List<Widget> widgets = [];
    widgets.addAll(_buildCity());
    widgets.addAll(_buildCategory());
    widgets.addAll(_buildExpense());
    widgets.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (_total[_selectedCity] == null) {
              _total[_selectedCity] = {};
            }
            var city = _total[_selectedCity];
            if (city![_selectedCategory] == null) {
              city[_selectedCategory] = [];
            }
            var category = city[_selectedCategory];
            category!.add(1);
            setState(() {});
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
    );

    Map<String, int> result = {};
    var total = 0;
    _total.forEach(
      (city, content) {
        content.forEach(
          (category, expense) {
            for (var ele in expense) {
              if (result[city] == null) {
                result[city] = ele;
              } else {
                result[city] = result[city]! + ele;
              }
              if (result[category] == null) {
                result[category] = ele;
              } else {
                result[category] = result[category]! + ele;
              }
              total = total + ele;
            }
          },
        );
      },
    );

    widgets.add(Text('总计: $total元'));
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
    result.forEach((key, value) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(key),
            Text('$value元'),
            Text('${value * 100 ~/ total}%'),
          ],
        ),
      );
    });

    return widgets;
  }

  String _selectedCity = '北京';
  final List<String> _cities = ['北京', '南京', '苏州'];
  String _selectedCategory = '路费';
  final List<String> _categories = ['路费', '住宿', '吃饭'];

  _buildCity() {
    List<Widget> widgets = [];
    widgets.add(const Divider());
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
    widgets.add(const Divider());
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
    widgets.add(const Divider());
    widgets.add(
      const TextField(
        decoration: InputDecoration(labelText: '人民币'),
      ),
    );
    return widgets;
  }
}
