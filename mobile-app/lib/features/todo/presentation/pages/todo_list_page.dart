import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<_TodoItem> _items = [
    _TodoItem(title: 'HIIT Endurance', subtitle: '30 MIN · Intermediate', isDone: false),
    _TodoItem(title: 'Morning Stretch', subtitle: '10 MIN · Beginner', isDone: true),
    _TodoItem(title: 'Core Crusher', subtitle: '20 MIN · Advanced', isDone: false),
    _TodoItem(title: 'Evening Walk', subtitle: '45 MIN · Beginner', isDone: false),
    _TodoItem(title: 'Hydration Goal', subtitle: '8 glasses of water', isDone: true),
  ];

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Add Task',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Task name…',
                hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inputBorder)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: subtitleCtrl,
              style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'Details (optional)…',
                hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14.sp),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inputBorder)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _items.add(_TodoItem(
                    title: title,
                    subtitle: subtitleCtrl.text.trim(),
                    isDone: false,
                  ));
                });
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Add',
                style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final done = _items.where((e) => e.isDone).length;
    final total = _items.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildTopBar(context),
            SizedBox(height: 24.h),
            _buildProgress(done, total),
            SizedBox(height: 20.h),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: Icon(Icons.add_rounded, color: AppColors.onPrimary, size: 28.w),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            "Today's Plan",
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(int done, int total) {
    final fraction = total == 0 ? 0.0 : done / total;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Progress',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$done / $total completed',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8.h,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      itemCount: _items.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) => _buildTile(index),
    );
  }

  Widget _buildTile(int index) {
    final item = _items[index];
    return Dismissible(
      key: ValueKey('$index-${item.title}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 24.w),
      ),
      onDismissed: (_) => setState(() => _items.removeAt(index)),
      child: GestureDetector(
        onTap: () => setState(() => _items[index] = item.copyWith(isDone: !item.isDone)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: item.isDone
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: item.isDone
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isDone ? AppColors.primary : Colors.transparent,
                  border: item.isDone
                      ? null
                      : Border.all(color: AppColors.textSecondary, width: 1.5),
                ),
                child: item.isDone
                    ? Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 14.w)
                    : null,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        color: item.isDone
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textSecondary,
                      ),
                    ),
                    if (item.subtitle.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
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

class _TodoItem {
  const _TodoItem({
    required this.title,
    required this.subtitle,
    required this.isDone,
  });

  final String title;
  final String subtitle;
  final bool isDone;

  _TodoItem copyWith({bool? isDone}) => _TodoItem(
        title: title,
        subtitle: subtitle,
        isDone: isDone ?? this.isDone,
      );
}
