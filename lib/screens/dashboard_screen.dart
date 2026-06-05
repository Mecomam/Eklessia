import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/member.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Member>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture = _apiService.fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iglesia Moral de Calatrava", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 768) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: 0,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Panel')),
            NavigationRailDestination(icon: Icon(Icons.people), label: Text('Miembros')),
            NavigationRailDestination(icon: Icon(Icons.monetization_on), label: Text('Finanzas')),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Panel de Control (Escritorio)", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Expanded(child: _buildMembersTable()),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vista Móvil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: _membersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay miembros registrados."));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final member = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(member.nombres.isNotEmpty ? member.nombres[0] : "?", style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text("${member.apellidos}, ${member.nombres}"),
                        subtitle: Text("Estado: ${member.estadoEspiritual ?? 'No asignado'}"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTable() {
    return FutureBuilder<List<Member>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: const [
                DataColumn(label: Text('Nombre Completo', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Estado Espiritual', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: snapshot.data!.map((member) => DataRow(
                cells: [
                  DataCell(Text("${member.apellidos}, ${member.nombres}")),
                  DataCell(Text(member.email ?? 'N/D')),
                  DataCell(Text(member.telefono ?? 'N/D')),
                  DataCell(Text(member.estadoEspiritual ?? 'N/D')),
                ],
              )).toList(),
            ),
          ),
        );
      },
    );
  }
}
