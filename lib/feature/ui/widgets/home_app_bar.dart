import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_note_app/feature/data/manager/notifications/notification_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationScheduledSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Notification scheduled successfully')),
          );
        } else if (state is NotificationFetchedSuccess) {
          if (state.notifications.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Pending Notifications'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) =>
                        Text(state.notifications[index]),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No pending notifications')),
            );
          }
        } else if (state is NotificationCancelledSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All notifications canceled')),
          );
        } else if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AppBar(
          title: const Text('Voice Notes'),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    context
                        .read<NotificationCubit>()
                        .fetchPendingNotifications();
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
                if (state.notifications.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        state.notifications.length.toString(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              onPressed: () {
                context.read<NotificationCubit>().cancelAllNotifications();
              },
              icon: const Icon(Icons.notifications_off_outlined),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
