import 'package:flutter/material.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/utils/icons/common_icons.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(12),
      //TODO: Make scrollable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDate(),
          const SizedBox(
            height: 12,
          ),
          _buildCardVideo(),
        ],
      ),
    );
  }

  Widget _buildDate() {
    return Text(
      "Today",
      style: bodyLmedium,
    );
  }

  Widget _buildCardVideo() {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //TODO: Add gesture detector on container
              Container(
                width: 120,
                height: 90,
                color: Colors.black,
                child: Stack(
                  children: [
                    //TODO: Add image previews or thumbnail
                    Center(child: CommonIcons.play),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 4,
                          bottom: 2,
                        ),
                        child: Text(
                          "55m 24s",
                          style: bodyXSregular.copyWith(
                            color: CommonColors.themeGreysMainSurface,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "namafile.avi",
                    style: bodySregular,
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 2, 0),
                        child: CommonIcons.time,
                      ),
                      Text(
                        "6:30 AM",
                        style: bodySmedium,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            //TODO: Add ontap function on share icon
            child: CommonIcons.share,
          )
        ],
      ),
    );
  }
}
