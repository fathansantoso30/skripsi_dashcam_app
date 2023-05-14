import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/colors/common_colors.dart';
import '../../../../utils/icons/common_icons.dart';
import '../../../../utils/text_style/common_text_style.dart';
import '../cubit/live_stream_cubit.dart';

class LiveStreamFullScreenPage extends StatefulWidget {
  final Stream<dynamic>? stream;
  const LiveStreamFullScreenPage({super.key, required this.stream});

  @override
  State<LiveStreamFullScreenPage> createState() =>
      _LiveStreamFullScreenPageState();
}

class _LiveStreamFullScreenPageState extends State<LiveStreamFullScreenPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child:
            // Render the live stream data on the page
            Stack(
          children: [
            _buildStreamSection(
              stream: widget.stream,
            ),
            _buildCollapseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Positioned(
      bottom: 24,
      right: 24,
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
