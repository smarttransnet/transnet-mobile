import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/reference_data.dart';
import '../../data/repositories/reference_data_repository.dart';
import '../controllers/create_trip_controller.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _tripNumber;
  
  DriverRef? _selectedDriver;
  VehicleRef? _selectedVehicle;
  TrailerRef? _selectedTrailer;
  ClientRef? _selectedClient;
  
  DateTime _scheduledStartAt = DateTime.now();
  String _origin = '';
  String _destination = '';
  
  String? _selectedCategoryId;
  TripCategoryMaterialRef? _selectedCategoryMapping;
  String _quantity = '';

  @override
  void initState() {
    super.initState();
    _tripNumber = 'TRP-${Random().nextInt(10000).toString().padLeft(4, '0')}';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final payload = {
      "tripNumber": _tripNumber,
      "driverId": _selectedDriver?.id,
      "vehicleId": _selectedVehicle?.id,
      "trailerId": _selectedTrailer?.id,
      "clientId": _selectedClient?.id,
      "origin": _origin,
      "destination": _destination,
      "scheduledStartAt": _scheduledStartAt.toUtc().toIso8601String(),
      "tripCategoryMaterialId": _selectedCategoryMapping?.id,
      "quantity": double.tryParse(_quantity),
    };

    final success = await ref.read(createTripControllerProvider.notifier).createTrip(payload);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip created successfully!'), backgroundColor: Colors.green),
      );
      context.pop();
    }
  }

  Widget build(BuildContext context) {
    final refDataAsync = ref.watch(tripReferenceDataProvider);
    final isSaving = ref.watch(createTripControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('New Trip', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: refDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load reference data\n$err', textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(tripReferenceDataProvider),
                child: const Text('Retry'),
              )
            ],
          ),
        ),
        data: (data) => _buildForm(data, isSaving),
      ),
    );
  }

  Widget _buildForm(TripReferenceData data, bool isSaving) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('General Info'),
          _buildCard([
            _buildReadOnlyField('Trip Number', _tripNumber, Icons.tag),
            const Divider(height: 1),
            _buildSelector<ClientRef>(
              label: 'Client (Optional)',
              icon: Icons.business,
              value: _selectedClient?.companyName,
              items: data.clients,
              itemLabel: (c) => c.companyName,
              onSelected: (c) => setState(() => _selectedClient = c),
            ),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Assignment'),
          _buildCard([
            _buildSelector<DriverRef>(
              label: 'Driver *',
              icon: Icons.person,
              value: _selectedDriver?.fullName,
              items: data.drivers,
              itemLabel: (d) => d.fullName,
              onSelected: (d) => setState(() => _selectedDriver = d),
              validator: (v) => _selectedDriver == null ? 'Please select a driver' : null,
            ),
            const Divider(height: 1),
            _buildSelector<VehicleRef>(
              label: 'Vehicle *',
              icon: Icons.directions_car,
              value: _selectedVehicle?.displayName,
              items: data.vehicles,
              itemLabel: (v) => v.displayName,
              onSelected: (v) => setState(() => _selectedVehicle = v),
              validator: (v) => _selectedVehicle == null ? 'Please select a vehicle' : null,
            ),
            const Divider(height: 1),
            _buildSelector<TrailerRef>(
              label: 'Trailer (Optional)',
              icon: Icons.rv_hookup,
              value: _selectedTrailer?.displayName,
              items: data.trailers,
              itemLabel: (t) => t.displayName,
              onSelected: (t) => setState(() => _selectedTrailer = t),
            ),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('Route & Schedule'),
          _buildCard([
            _buildDateTimeField(),
            const Divider(height: 1),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Origin',
                prefixIcon: Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSaved: (v) => _origin = v ?? '',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const Divider(height: 1),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSaved: (v) => _destination = v ?? '',
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('Cargo & Material'),
          _buildCard([
            _buildCargoSelectors(data),
            if (_selectedCategoryMapping != null) ...[
              const Divider(height: 1),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity (${_selectedCategoryMapping!.uomCode}) *',
                  prefixIcon: Icon(Icons.scale, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => _quantity = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ]
          ]),
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: isSaving ? null : _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 2,
            ),
            child: isSaving
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary, strokeWidth: 2))
                : const Text('CREATE TRIP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateTimeField() {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _scheduledStartAt,
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null && mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_scheduledStartAt),
          );
          if (time != null) {
            setState(() {
              _scheduledStartAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scheduled Start *', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(
                  '${_scheduledStartAt.year}-${_scheduledStartAt.month.toString().padLeft(2,'0')}-${_scheduledStartAt.day.toString().padLeft(2,'0')} ${_scheduledStartAt.hour.toString().padLeft(2,'0')}:${_scheduledStartAt.minute.toString().padLeft(2,'0')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector<T>({
    required String label,
    required IconData icon,
    required String? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T) onSelected,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return FormField<String>(
      validator: validator,
      builder: (state) {
        return InkWell(
          onTap: () => _showSelectionSheet(label, items, itemLabel, onSelected, state),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: state.hasError ? colorScheme.error : colorScheme.onSurfaceVariant),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyle(fontSize: 12, color: state.hasError ? colorScheme.error : colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text(
                        value ?? 'Select $label',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                          color: value != null ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(state.errorText!, style: TextStyle(color: colorScheme.error, fontSize: 12)),
                        )
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSelectionSheet<T>(
    String title,
    List<T> items,
    String Function(T) itemLabel,
    void Function(T) onSelected,
    FormFieldState<String> state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Select $title', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      return ListTile(
                        title: Text(itemLabel(item)),
                        onTap: () {
                          onSelected(item);
                          state.didChange(itemLabel(item)); // trigger validation
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCargoSelectors(TripReferenceData data) {
    // 1. Unique Categories
    final categories = data.categories.map((e) => e.categoryName).toSet().toList().cast<String>();
    
    final uoms = _selectedCategoryId == null
        ? <TripCategoryMaterialRef>[]
        : data.categories
            .where((e) => e.tripCategoryId == _selectedCategoryId)
            .toList().cast<TripCategoryMaterialRef>();

    return Column(
      children: [
        _buildSelector<String>(
          label: 'Trip Category (Optional)',
          icon: Icons.category,
          value: _selectedCategoryId != null ? categories.firstWhere((c) => data.categories.any((m) => m.tripCategoryId == _selectedCategoryId && m.categoryName == c)) : null,
          items: categories,
          itemLabel: (c) => c,
          onSelected: (c) {
            setState(() {
              _selectedCategoryId = data.categories.firstWhere((e) => e.categoryName == c).tripCategoryId;
              _selectedCategoryMapping = null;
            });
          },
        ),
        if (_selectedCategoryId != null) ...[
          const Divider(height: 1),
          _buildSelector<TripCategoryMaterialRef>(
            label: 'UOM',
            icon: Icons.straighten,
            value: _selectedCategoryMapping?.uomCode,
            items: uoms,
            itemLabel: (u) => u.uomCode,
            onSelected: (u) => setState(() => _selectedCategoryMapping = u),
          ),
        ]
      ],
    );
  }
}
