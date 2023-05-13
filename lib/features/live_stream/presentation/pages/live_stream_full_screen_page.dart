import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/colors/common_colors.dart';
import '../../../../utils/icons/common_icons.dart';
import '../../../../utils/text_style/common_text_style.dart';
import '../cubit/live_stream_cubit.dart';

class LiveStreamFullScreenPage extends StatefulWidget {
  const LiveStreamFullScreenPage({super.key});

  @override
  State<LiveStreamFullScreenPage> createState() =>
      _LiveStreamFullScreenPageState();
}

class _LiveStreamFullScreenPageState extends State<LiveStreamFullScreenPage> {
  late LiveStreamCubit liveStreamCubit;

  @override
  void initState() {
    liveStreamCubit = GetIt.instance<LiveStreamCubit>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    liveStreamCubit.getLiveStreamData();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    liveStreamCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveStreamCubit>(
      create: (context) => liveStreamCubit,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: BlocBuilder<LiveStreamCubit, LiveStreamState>(
              builder: (context, state) {
            if (state is LiveStreamInitial || state is LiveStreamDisconnected) {
              return Center(
                child: Text(
                  "Start Camera",
                  style: bodyMregular.copyWith(
                      color: CommonColors.themeBrandPrimaryTextInvert),
                ),
              );
            } else if (state is LiveStreamLoaded) {
              // Render the live stream data on the page
              return Stack(
                children: [
                  _buildStreamSection(
                    stream:
                        state.liveStream.dataStream?.stream.asBroadcastStream(),
                  ),
                  _buildCollapseButton(),
                ],
              );
            } else {
              // Render a loading indicator while the data is being loaded
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: CommonIcons.collapse,
      ),
    );
  }

  Widget _buildStreamSection({required Stream? stream}) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        //? Working for single frames
        return Image.memory(
          snapshot.data,
          gaplessPlayback: true,
          height: double.infinity,
          width: double.infinity,
        );
      },
    );
  }
}
