import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataModel {
  final int id;
  final String titulo;
  final int estado;

  DataModel({
    required this.id,
    required this.titulo,
    required this.estado,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      titulo: json['titulo'],
      estado: json['estado'],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: PaginatedDataTableView()
    ),
  );
}

class PaginatedDataTableView extends StatefulWidget {
  const PaginatedDataTableView({super.key});

  @override
  State<PaginatedDataTableView> createState() => _PaginatedDataTableViewState();
}

class _PaginatedDataTableViewState extends State<PaginatedDataTableView> {
  int _currentPage = 1;
  int _pageSize = 10;
  List<DataModel> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

     var url = Uri.parse('http://127.0.0.1:8001/api/tareas');
    final response = await http.get(url);    //&pageSize=$_pageSize
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      inspect(jsonData);
      final dataList = jsonData as List<dynamic>;

      final List<DataModel> newData =
          dataList.map((item) => DataModel.fromJson(item)).toList();

      setState(() {
        _data.addAll(newData);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  void _loadMoreData() {
    if (!_isLoading) {
      setState(() {
        _currentPage++;
      });
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        backgroundColor: Colors.indigo[200],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  header: const Text('Lista de Tareas'),
                  rowsPerPage: _pageSize,
                  availableRowsPerPage: const [10, 25, 50],
                  onRowsPerPageChanged: (value) {
                    setState(() {
                      _pageSize = value!;
                    });
                  },
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('titulo')),
                    DataColumn(label: Text('Estado')),
                  ],
                  source: _DataSource(data: _data),
                ),
              ),
            ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<DataModel> data;

  _DataSource({required this.data});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    final estadoText = item.estado.toString() == '0' ? 'Pendiente' : 'Completada';

    return DataRow(cells: [
      DataCell(Text(item.id.toString())),
      DataCell(Text(item.titulo)),
      DataCell(Text(estadoText)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}