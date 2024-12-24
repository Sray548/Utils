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

  _buildBody() {
    List<Widget> widgets = [];
    widgets.addAll(_buildCity());
    widgets.addAll(_buildCategory());
    widgets.addAll(_buildExpense());
    return widgets;
  }

  String? _selectedCity;
  final List<String> _cities = ['北京', '南京', '苏州'];
  String? _selectedCategory;
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
                _selectedCity = newValue;
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
                _selectedCategory = newValue;
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
    widgets.add(TextField(
      decoration: InputDecoration(labelText: '人民币'),
    ));
    return widgets;
  }
}
