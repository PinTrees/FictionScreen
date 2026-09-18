import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/yanolja_model.dart';
import 'pages/desktop/yanolja_desktop_home_page.dart';
import 'pages/mobile/yanolja_mobile_booking_page.dart';
import 'pages/mobile/yanolja_mobile_detail_page.dart';
import 'pages/mobile/yanolja_mobile_home_page.dart';
import 'widgets/yanolja_bottom_nav.dart';
import 'widgets/yanolja_edit_dialog.dart';

enum YanoljaSubView { home, detail, booking }

class YanoljaScreen extends StatefulWidget {
  final YanoljaConfig? config;
  final ValueChanged<YanoljaConfig>? onConfigChanged;

  const YanoljaScreen({
    super.key,
    this.config,
    this.onConfigChanged,
  });

  @override
  State<YanoljaScreen> createState() => _YanoljaScreenState();
}

class _YanoljaScreenState extends State<YanoljaScreen> {
  late YanoljaConfig _config;
  YanoljaSubView _subView = YanoljaSubView.home;
  int _currentTab = 2;
  YanoljaLodgingItem? _selectedLodging;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? YanoljaConfig.defaultPreset();
    if (_config.lodgings.isNotEmpty) {
      _selectedLodging = _config.lodgings.first;
    }
  }

  @override
  void didUpdateWidget(covariant YanoljaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null && widget.config != oldWidget.config) {
      _config = widget.config!;
    }
  }

  void _openEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => YanoljaEditDialog(
        config: _config,
        onSave: (updated) {
          setState(() => _config = updated);
          widget.onConfigChanged?.call(updated);
        },
      ),
    );
  }

  void _handleSelectLodging(YanoljaLodgingItem lodging) {
    setState(() {
      _selectedLodging = lodging;
      _subView = YanoljaSubView.detail;
    });
  }

  void _handleBookRoom(YanoljaRoomItem room, bool isRent) {
    final newReservation = YanoljaReservation(
      reservationNo: 'YN${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}',
      lodgingName: _selectedLodging?.name ?? '선택한 숙소',
      roomName: room.name,
      isRent: isRent,
      checkInInfo: isRent ? '당일 즉시 이용 (${room.rentTime})' : '2026.09.19 (금) 15:00',
      checkOutInfo: isRent ? '이용 후 자동 퇴실' : '2026.09.20 (토) 11:00',
      guestName: _config.latestReservation?.guestName ?? '김민준',
      guestPhone: _config.latestReservation?.guestPhone ?? '010-9876-5432',
      totalAmount: isRent ? room.rentPrice : room.stayPrice,
    );

    setState(() {
      _config.latestReservation = newReservation;
      _subView = YanoljaSubView.booking;
    });
    widget.onConfigChanged?.call(_config);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 650;
        if (isDesktop) {
          return _buildDesktopLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    if (_subView == YanoljaSubView.detail && _selectedLodging != null) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: YanoljaMobileDetailPage(
            lodging: _selectedLodging!,
            onBack: () => setState(() => _subView = YanoljaSubView.home),
            onBook: _handleBookRoom,
          ),
        ),
      );
    }

    if (_subView == YanoljaSubView.booking && _config.latestReservation != null) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: YanoljaMobileBookingPage(
            reservation: _config.latestReservation!,
            onHome: () => setState(() => _subView = YanoljaSubView.home),
          ),
        ),
      );
    }

    return Stack(
      children: [
        YanoljaDesktopHomePage(
          config: _config,
          onSelectLodging: _handleSelectLodging,
          onEdit: _openEditDialog,
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFFFF3478),
            foregroundColor: Colors.white,
            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18),
            label: const Text('설정/수정', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: _openEditDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: _buildCurrentMobileView(),
      bottomNavigationBar: _subView == YanoljaSubView.home
          ? YanoljaBottomNav(
              activeIndex: _currentTab,
              onTap: (index) {
                setState(() => _currentTab = index);
                if (index == 4 && _config.latestReservation != null) {
                  setState(() => _subView = YanoljaSubView.booking);
                }
              },
            )
          : null,
      floatingActionButton: _subView == YanoljaSubView.home
          ? FloatingActionButton.small(
              backgroundColor: const Color(0xFFFF3478),
              foregroundColor: Colors.white,
              onPressed: _openEditDialog,
              child: const Icon(CupertinoIcons.slider_horizontal_3, size: 18),
            )
          : null,
    );
  }

  Widget _buildCurrentMobileView() {
    switch (_subView) {
      case YanoljaSubView.detail:
        return YanoljaMobileDetailPage(
          lodging: _selectedLodging ?? _config.lodgings.first,
          onBack: () => setState(() => _subView = YanoljaSubView.home),
          onBook: _handleBookRoom,
        );
      case YanoljaSubView.booking:
        return YanoljaMobileBookingPage(
          reservation: _config.latestReservation ??
              YanoljaReservation(
                reservationNo: 'YN000000',
                lodgingName: '숙소 이름',
                roomName: '객실 이름',
                isRent: false,
                checkInInfo: '정보 없음',
                checkOutInfo: '정보 없음',
                guestName: '게스트',
                guestPhone: '010-0000-0000',
                totalAmount: 0,
              ),
          onHome: () => setState(() => _subView = YanoljaSubView.home),
        );
      case YanoljaSubView.home:
        return YanoljaMobileHomePage(
          config: _config,
          onSelectLodging: _handleSelectLodging,
          onOpenEditDialog: _openEditDialog,
        );
    }
  }
}
