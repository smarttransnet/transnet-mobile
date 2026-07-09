import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/driver_status_enum.dart';
import '../controllers/drivers_controller.dart';

class DriverFormScreen extends ConsumerStatefulWidget {
  final DriverModel? driver;

  const DriverFormScreen({super.key, this.driver});

  @override
  ConsumerState<DriverFormScreen> createState() => _DriverFormScreenState();
}

class _DriverFormScreenState extends ConsumerState<DriverFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _employeeNoController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _licenceNoController;
  late TextEditingController _nationalityController;
  late TextEditingController _sponsorController;

  DateTime? _licenceExpiryDate;
  late DriverStatus _selectedStatus;
  late bool _isActive;
  bool _isLoading = false;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _employeeNoController = TextEditingController(text: widget.driver?.employeeNumber ?? '');
    _firstNameController = TextEditingController(text: widget.driver?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.driver?.lastName ?? '');
    _phoneController = TextEditingController(text: widget.driver?.phoneNumber ?? '');
    _emailController = TextEditingController(text: widget.driver?.email ?? '');
    _licenceNoController = TextEditingController(text: widget.driver?.licenceNumber ?? '');
    _nationalityController = TextEditingController(text: widget.driver?.nationalityCode ?? '');
    _sponsorController = TextEditingController(text: widget.driver?.sponsorName ?? '');

    _licenceExpiryDate = widget.driver?.licenceExpiryDate;
    _selectedStatus = widget.driver?.status ?? DriverStatus.active;
    _isActive = widget.driver?.isActive ?? true;
  }

  @override
  void dispose() {
    _employeeNoController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licenceNoController.dispose();
    _nationalityController.dispose();
    _sponsorController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _licenceExpiryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _licenceExpiryDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_licenceExpiryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Licence Expiry Date')));
        return;
      }

      setState(() { _isLoading = true; });

      final payload = {
        'employeeNumber': _employeeNoController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phoneNumber': _phoneController.text,
        'email': _emailController.text,
        'licenceNumber': _licenceNoController.text,
        'licenceExpiryDate': _dateFormat.format(_licenceExpiryDate!),
        'nationalityCode': _nationalityController.text,
        'sponsorName': _sponsorController.text,
        'status': _statusToInt(_selectedStatus),
        'isActive': _isActive,
      };

      final controller = ref.read(driverFormProvider);
      bool success;
      if (widget.driver == null) {
        success = await controller.createDriver(payload);
      } else {
        success = await controller.updateDriver(widget.driver!.id, payload);
      }

      if (mounted) {
        setState(() { _isLoading = false; });
        if (success) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save driver')),
          );
        }
      }
    }
  }

  int _statusToInt(DriverStatus status) {
    switch (status) {
      case DriverStatus.active: return 0;
      case DriverStatus.onLeave: return 1;
      case DriverStatus.suspended: return 2;
      case DriverStatus.terminated: return 3;
      case DriverStatus.probation: return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver == null ? 'Create Driver' : 'Edit Driver'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _employeeNoController,
                    decoration: const InputDecoration(labelText: 'Employee Number', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _licenceNoController,
                    decoration: const InputDecoration(labelText: 'Licence Number', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Licence Expiry Date'),
                    subtitle: Text(_licenceExpiryDate == null ? 'Select Date' : _dateFormat.format(_licenceExpiryDate!)),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: const InputDecoration(labelText: 'Nationality Code', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sponsorController,
                    decoration: const InputDecoration(labelText: 'Sponsor Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DriverStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: DriverStatus.values.map((status) {
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
