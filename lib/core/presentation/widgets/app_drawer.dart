import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';

class AppDrawer extends ConsumerWidget {
  final String currentRouteName;

  const AppDrawer({super.key, required this.currentRouteName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Center(
              child: Text(
                'SmartTransnet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: currentRouteName == AppRoutes.homeName,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(AppRoutes.homeName);
                  },
                ),
                _DrawerItem(
                  icon: Icons.local_shipping,
                  title: 'Trips',
                  isSelected: currentRouteName == AppRoutes.tripsName,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(AppRoutes.tripsName);
                  },
                ),
                _DrawerItem(
                  icon: Icons.directions_car,
                  title: 'Vehicles',
                  isSelected: currentRouteName == AppRoutes.vehiclesName,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(AppRoutes.vehiclesName);
                  },
                ),
                _DrawerItem(
                  icon: Icons.people,
                  title: 'Drivers',
                  isSelected: currentRouteName == AppRoutes.driversName,
                  onTap: () {
                    Navigator.pop(context);
                    context.goNamed(AppRoutes.driversName);
                  },
                ),
                _DrawerItem(icon: Icons.receipt_long, title: 'Invoices', onTap: () {}),
                _DrawerItem(icon: Icons.settings, title: 'Settings', onTap: () {}),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await ref.read(authRepositoryProvider).logout();
              if (context.mounted) {
                context.goNamed(AppRoutes.loginName);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.1),
        leading: Icon(
          icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
