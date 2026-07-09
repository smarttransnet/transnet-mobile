import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/models/vehicle_type_enum.dart';
import '../../data/models/vehicle_status_enum.dart';
import '../controllers/vehicle_form_controller.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  final VehicleModel? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _plateNumberController;
  late TextEditingController _chassisNumberController;
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _odometerController;
  
  late VehicleType _selectedType;
  late VehicleStatus _selectedStatus;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController(text: widget.vehicle?.plateNumber ?? '');
    _chassisNumberController = TextEditingController(text: widget.vehicle?.chassisNumber ?? '');
    _makeController = TextEditingController(text: widget.vehicle?.make ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(text: widget.vehicle?.year.toString() ?? '');
    _odometerController = TextEditingController(text: widget.vehicle?.odometerReading.toString() ?? '0');
    
    _selectedType = widget.vehicle?.vehicleType ?? VehicleType.truck;
    _selectedStatus = widget.vehicle?.status ?? VehicleStatus.active;
    _isActive = widget.vehicle?.isActive ?? true;
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _chassisNumberController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      final payload = {
        'plateNumber': _plateNumberController.text,
        'chassisNumber': _chassisNumberController.text,
        'make': _makeController.text,
        'model': _modelController.text,
        'year': int.tryParse(_yearController.text) ?? 2024,
        'odometerReading': double.tryParse(_odometerController.text) ?? 0,
        'vehicleType': _selectedType.name == 'truck' ? 1 : 2,
        'status': _statusToInt(_selectedStatus),
        'isActive': _isActive,
        'vehicleCategoryId': widget.vehicle?.vehicleCategoryId ?? '8399467f-494a-419a-8aab-87eb98d960d8',
      };

      final controller = ref.read(vehicleFormProvider);
      bool success;
      if (widget.vehicle == null) {
        success = await controller.createVehicle(payload);
      } else {
        success = await controller.updateVehicle(widget.vehicle!.id, payload);
      }

      if (mounted) {
        setState(() { _isLoading = false; });
        if (success) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save vehicle')),
          );
        }
      }
    }
  }

  int _statusToInt(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active: return 1;
      case VehicleStatus.maintenance: return 2;
      case VehicleStatus.outOfService: return 3;
      case VehicleStatus.sold: return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Create Vehicle' : 'Edit Vehicle'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _plateNumberController,
                    decoration: const InputDecoration(labelText: 'Plate Number', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _chassisNumberController,
                    decoration: const InputDecoration(labelText: 'Chassis Number', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _makeController,
                    decoration: const InputDecoration(labelText: 'Make', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _odometerController,
                    decoration: const InputDecoration(labelText: 'Odometer Reading', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<VehicleType>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Vehicle Type', border: OutlineInputBorder()),
                    items: VehicleType.values.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type.name));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedType = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<VehicleStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: VehicleStatus.values.map((status) {
                      return DropdownMenuItem(value: status, child: Text(status.name));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedStatus = v!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Is Active'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
