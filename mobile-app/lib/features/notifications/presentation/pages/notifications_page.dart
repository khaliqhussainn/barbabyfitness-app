import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';

enum _NType { workout, reminder, achievement, tip }

class _NotifItem {
  _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.read = false,
  });
  final String title;
  final String body;
  final String time;
  final _NType type;
  bool read;
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_NotifItem> _items = [
    _NotifItem(
      title: 'Time to move! 💪',
      body: "Your scheduled workout starts in 15 minutes. Don't skip — you're on a 5-day streak!",
      time: 'Just now',
      type: _NType.reminder,
    ),
    _NotifItem(
      title: 'New Workout Unlocked',
      body: 'HIIT Circuit Advanced is now available for your fitness level.',
      time: '2h ago',
      type: _NType.workout,
    ),
    _NotifItem(
      title: '🏆 Achievement Earned',
      body: "You've completed 10 workouts this month. Keep it up!",
      time: '5h ago',
      type: _NType.achievement,
      read: true,
    ),
    _NotifItem(
      title: "Coach Tip",
      body: 'Hydrate before your morning session for better performance and faster recovery.',
      time: 'Yesterday',
      type: _NType.tip,
      read: true,
    ),
    _NotifItem(
      title: 'Workout Reminder',
      body: 'Your Upper Body Power session is scheduled for tomorrow at 7:00 AM.',
      time: 'Yesterday',
      type: _NType.reminder,
      read: true,
    ),
    _NotifItem(
      title: 'Weekly Recap Ready',
      body: 'You burned 1,240 kcal across 4 workouts this week. Tap to see your full recap.',
      time: '2 days ago',
      type: _NType.workout,
      read: true,
    ),
    _NotifItem(
      title: '🔥 Streak Alert',
      body: "3 days left to hit your monthly goal. You've got this!",
      time: '3 days ago',
      type: _NType.achievement,
      read: true,
    ),
  ];

  int get _unreadCount => _items.where((n) => !n.read).length;

  void _markAllRead() => setState(() {
        for (final n in _items) {
          n.read = true;
        }
      });

  void _dismiss(int index) => setState(() => _items.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildTopBar(context),
            if (_unreadCount > 0) ...[
              SizedBox(height: 8.h),
              _buildUnreadBanner(),
            ],
            SizedBox(height: 16.h),
            Expanded(
              child: _items.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) => _NotifCard(
                        item: _items[i],
                        onTap: () => setState(() => _items[i].read = true),
                        onDismiss: () => _dismiss(i),
                      ),
                    ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.chevron_left_rounded,
                  color: AppColors.textPrimary, size: 28.w),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Notifications',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (_unreadCount > 0)
            GestureDetector(
              onTap: _markAllRead,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(
                  'Mark all read',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUnreadBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '$_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded,
              color: AppColors.textSecondary, size: 56.w),
          SizedBox(height: 16.h),
          Text(
            'All caught up!',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'No new notifications right now',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.item,
    required this.onTap,
    required this.onDismiss,
  });

  final _NotifItem item;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  IconData get _icon {
    switch (item.type) {
      case _NType.workout:
        return Icons.fitness_center_rounded;
      case _NType.reminder:
        return Icons.alarm_rounded;
      case _NType.achievement:
        return Icons.emoji_events_rounded;
      case _NType.tip:
        return Icons.lightbulb_outline_rounded;
    }
  }

  Color get _iconColor {
    switch (item.type) {
      case _NType.workout:
        return AppColors.primary;
      case _NType.reminder:
        return const Color(0xFF3B82F6);
      case _NType.achievement:
        return const Color(0xFFF59E0B);
      case _NType.tip:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.title + item.time),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded,
            color: const Color(0xFFEF4444), size: 22.w),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: item.read
                ? AppColors.surface
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: item.read
                ? null
                : Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
          ),
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: 22.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: item.read
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.read)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.only(left: 6.w, top: 4.h),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.body,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.time,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
