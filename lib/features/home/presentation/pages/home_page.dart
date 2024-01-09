import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/cubit/album_cubit.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/pages/album_page.dart';
import 'package:skripsi_dashcam_app/features/home/presentation/cubit/navbar_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/cubit/live_stream_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/pages/live_stream_page.dart';
import 'package:skripsi_dashcam_app/utils/icons/common_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  late LiveStreamCubit liveStreamCubit;
  late AlbumCubit albumCubit;

  @override
  void initState() {
    super.initState();
    liveStreamCubit = GetIt.instance<LiveStreamCubit>();
    albumCubit = GetIt.instance<AlbumCubit>();
    _selectedIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavbarCubit>(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider<LiveStreamCubit>(create: (context) => liveStreamCubit),
        BlocProvider<AlbumCubit>(create: (context) => albumCubit),
      ],
      child: BlocConsumer<NavbarCubit, NavbarState>(
          builder: (context, state) {
            var cubit = NavbarCubit.get(context);

            return Scaffold(
              bottomNavigationBar: _buildNavbarSection(
                onChange: (index) {
                  cubit.changeBottomNavBar(index);
                  _selectedIndex = cubit.currentIndex;
                },
              ),
              extendBody: true,
              body: _pages.elementAt(_selectedIndex),
            );
          },
          listener: (context, state) {}),
    );
  }

  Widget _buildNavbarSection({required final Function(int) onChange}) {
    return BottomNavigationBar(
        elevation: 4,
        currentIndex: _selectedIndex,
        onTap: onChange,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "Gallery",
            icon: CommonIcons.gallery,
            activeIcon: CommonIcons.galleryActive,
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: CommonIcons.home,
            activeIcon: CommonIcons.homeActive,
          ),
          // BottomNavigationBarItem(
          //   label: "Settings",
          //   icon: CommonIcons.settings,
          //   activeIcon: CommonIcons.settingsActive,
          // ),
        ]);
  }

  static final List<Widget> _pages = <Widget>[
    const AlbumPage(),
    const LiveStreamPage(),
    //TODO: Add settings page
    // Container(
    //   color: Colors.grey.shade300,
    //   child: const Center(
    //     child: Text('Settings still work on progress...'),
    //   ),
    // ),
  ];
}
