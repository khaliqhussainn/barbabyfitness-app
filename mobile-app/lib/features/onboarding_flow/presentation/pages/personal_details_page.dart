import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../providers/personal_details_provider.dart';

class PersonalDetailsPage extends ConsumerStatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  ConsumerState<PersonalDetailsPage> createState() =>
      _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends ConsumerState<PersonalDetailsPage> {
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final details = ref.read(personalDetailsProvider);
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(personalDetailsProvider);
    final notifier = ref.read(personalDetailsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            _buildTopBar(context),
            SizedBox(height: 48.h),
            _buildHeader(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildAgeCard(notifier),
                  SizedBox(height: 12.h),
                  _buildGenderCard(details, notifier),
                  SizedBox(height: 12.h),
                  _buildHeightCard(details, notifier),
                  SizedBox(height: 12.h),
                  _buildWeightCard(details, notifier),
                ],
              ),
            ),
            const Spacer(),
            _buildPaginationDots(),
            SizedBox(height: 24.h),
            _buildConfirmButton(context),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => context.go(RouteNames.mainGoal),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Text(
            'Personal Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Help us calculate your baseline metrics',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeCard(PersonalDetailsNotifier notifier) {
    return _DetailCard(
      label: 'Age',
      child: TextField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) {
          final parsed = int.tryParse(v);
          if (parsed != null) notifier.setAge(parsed);
        },
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 21.sp,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Enter your age',
          hintStyle: TextStyle(
            color: AppColors.inputHint.withValues(alpha: 0.5),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(
      PersonalDetails details, PersonalDetailsNotifier notifier) {
    return _DetailCard(
      label: 'Gender',
      child: Row(
        children: [
          _GenderButton(
            label: 'Male',
            isSelected: details.gender == Gender.male,
            onTap: () => notifier.setGender(Gender.male),
          ),
          SizedBox(width: 8.w),
          _GenderButton(
            label: 'Female',
            isSelected: details.gender == Gender.female,
            onTap: () => notifier.setGender(Gender.female),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightCard(
      PersonalDetails details, PersonalDetailsNotifier notifier) {
    return _DetailCard(
      label: 'Height',
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) notifier.setHeight(parsed);
              },
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Enter your height',
                hintStyle: TextStyle(
                  color: AppColors.inputHint.withValues(alpha: 0.5),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          _UnitToggle<HeightUnit>(
            leftLabel: 'CM',
            rightLabel: 'FT',
            selected: details.heightUnit,
            leftValue: HeightUnit.cm,
            rightValue: HeightUnit.ft,
            onChanged: notifier.setHeightUnit,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightCard(
      PersonalDetails details, PersonalDetailsNotifier notifier) {
    return _DetailCard(
      label: 'Weight',
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) notifier.setWeight(parsed);
              },
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Enter your weight',
                hintStyle: TextStyle(
                  color: AppColors.inputHint.withValues(alpha: 0.5),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          _UnitToggle<WeightUnit>(
            leftLabel: 'KG',
            rightLabel: 'LBS',
            selected: details.weightUnit,
            leftValue: WeightUnit.kg,
            rightValue: WeightUnit.lbs,
            onChanged: notifier.setWeightUnit,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        final isActive = index == 4;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 52.w : 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AppPrimaryButton(
        label: 'Confirm Details',
        onPressed: () => context.go(RouteNames.devicePermissions),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354.w,
      height: 96.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4.h),
          child,
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 153.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _UnitToggle<T> extends StatelessWidget {
  const _UnitToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.selected,
    required this.leftValue,
    required this.rightValue,
    required this.onChanged,
  });

  final String leftLabel;
  final String rightLabel;
  final T selected;
  final T leftValue;
  final T rightValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final leftSelected = selected == leftValue;

    return Container(
      width: 144.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          _TogglePill(
            label: leftLabel,
            isSelected: leftSelected,
            onTap: () => onChanged(leftValue),
          ),
          _TogglePill(
            label: rightLabel,
            isSelected: !leftSelected,
            onTap: () => onChanged(rightValue),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
