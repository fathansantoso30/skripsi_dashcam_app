import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/cubit/album_cubit.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/pages/album_page.dart';
import 'package:skripsi_dashcam_app/features/home/presentation/cubit/connectivity_cubit.dart';
import 'package:skripsi_dashcam_app/features/home/presentation/cubit/navbar_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/cubit/live_stream_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/pages/live_stream_page.dart';
import 'package:skripsi_dashcam_app/utils/icons/common_icons.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  late ConnectivityCubit connectivityCubit;
  late LiveStreamCubit liveStreamCubit;
  late AlbumCubit albumCubit;
  late NavbarCubit navbarCubit;

  @override
  void initState() {
    super.initState();
    connectivityCubit = GetIt.instance<ConnectivityCubit>();
    navbarCubit = GetIt.instance<NavbarCubit>();
    liveStreamCubit = GetIt.instance<LiveStreamCubit>();
    albumCubit = GetIt.instance<AlbumCubit>();
    _selectedIndex = 1;
    connectivityCubit.checkWifiStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(create: (context) => connectivityCubit),
        BlocProvider<NavbarCubit>(
          create: (context) => navbarCubit,
        ),
        BlocProvider<LiveStreamCubit>(create: (context) => liveStreamCubit),
        BlocProvider<AlbumCubit>(create: (context) => albumCubit),
      ],
      child: BlocConsumer<ConnectivityCubit, ConnectivityState>(
          builder: (context, state) {
        // var cubit = NavbarCubit.get(context);
        // cubit.checkWifiStatus();

        if (state is ConnectTrueState) {
          return _buildHomePage();
        }

        if (state is ConnectFalseState) {
          return Scaffold(
            body: SafeArea(
              minimum: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonIcons.checkWifiFalse,
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Your device is not connected to Camera yet, please connect to ESP32-CAM WiFi and turn on Location",
                      style: bodyLregular,
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            minimum: const EdgeInsets.all(12),
            child: Center(
                child: Text(
              "Please wait while checking your connection to Camera...",
              style: bodyLregular,
              textAlign: TextAlign.center,
            )),
          ),
        );
      }, listener: (context, state) {
        if (state is ConnectFalseState) {
          connectivityCubit.checkWifiStatus();
        }
      }),
    );
  }

  Widget _buildHomePage() {
    return BlocBuilder<NavbarCubit, NavbarState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: _buildNavbarSection(
            onChange: (index) {
              navbarCubit.changeBottomNavBar(index);
              _selectedIndex = navbarCubit.currentIndex;
            },
          ),
          extendBody: true,
          body: _pages.elementAt(_selectedIndex),
        );
      },
    );
  }

  Widget _buildNavbarSection({required final Function(int) onChange}) {
    return BottomNavigationBar(
        elevation: 4,
        currentIndex: _selectedIndex,
        onTap: onChange,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            label: "Album",
            icon: CommonIcons.gallery,
            activeIcon: CommonIcons.galleryActive,
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: CommonIcons.home,
            activeIcon: CommonIcons.homeActive,
          ),
        ]);
  }

  static final List<Widget> _pages = <Widget>[
    const AlbumPage(),
    const LiveStreamPage(),
  ];
}
