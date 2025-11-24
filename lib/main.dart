import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'catatan_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MapScreen());
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<CatatanModel> _savedNotes = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('markers');
    if (s == null) return;
    try {
      final list = json.decode(s) as List<dynamic>;
      setState(() {
        _savedNotes.clear();
        _savedNotes.addAll(
            list.map((e) => CatatanModel.fromJson(e as Map<String, dynamic>)));
      });
    } catch (_) {}
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final s = json.encode(_savedNotes.map((e) => e.toJson()).toList());
    await prefs.setString('markers', s);
  }

  IconData _iconForType(CatatanType t) {
    switch (t) {
      case CatatanType.Toko:
        return Icons.store;
      case CatatanType.Rumah:
        return Icons.home;
      case CatatanType.Kantor:
        return Icons.work;
    }
  }

  Color _colorForType(CatatanType t) {
    switch (t) {
      case CatatanType.Toko:
        return Colors.blue;
      case CatatanType.Rumah:
        return Colors.green;
      case CatatanType.Kantor:
        return Colors.orange;
    }
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _findMyLocation() async {
    // Cek layanan dan izin GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Ambil posisi
    Position position = await Geolocator.getCurrentPosition();

    // Pindahkan kamera peta
    _mapController.move(
        latlong.LatLng(position.latitude, position.longitude), 15.0);
  }

  // Fungsi menangani Long Press pada peta
  void _handleLongPress(TapPosition _, latlong.LatLng point) async {
    String address = 'Alamat tidak dikenal';
    try {
      final placemarks =
          await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) address = placemarks.first.street ?? address;
    } catch (_) {}

    final noteCtrl = TextEditingController();
    CatatanType type = CatatanType.Toko;

    final saved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Tambah Catatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Alamat: $address'),
            TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Catatan')),
            const SizedBox(height: 8),
            DropdownButton<CatatanType>(
              value: type,
              onChanged: (v) => type = v ?? CatatanType.Toko,
              items: CatatanType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text('Simpan')),
        ],
      ),
    );

    if (saved == true) {
      setState(() {
        _savedNotes.add(CatatanModel(
            position: point,
            note: noteCtrl.text.isEmpty ? 'Catatan Baru' : noteCtrl.text,
            address: address,
            type: type));
      });
      await _saveAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo-Catatan")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const latlong.LatLng(-6.2, 106.8),
          initialZoom: 13.0,
          onLongPress: _handleLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _savedNotes
                .map((n) => Marker(
                      point: n.position,
                      width: 36,
                      height: 36,
                      child: GestureDetector(
                        onTap: () async {
                          final del = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Detail Catatan'),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tipe: ${n.type.name}'),
                                    Text('Catatan: ${n.note}'),
                                    Text('Alamat: ${n.address}'),
                                  ]),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(c).pop(false),
                                    child: const Text('Tutup')),
                                TextButton(
                                    onPressed: () => Navigator.of(c).pop(true),
                                    child: const Text('Hapus',
                                        style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (del == true) {
                            setState(() => _savedNotes.remove(n));
                            await _saveAll();
                          }
                        },
                        child: Icon(_iconForType(n.type),
                            color: _colorForType(n.type), size: 30),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
