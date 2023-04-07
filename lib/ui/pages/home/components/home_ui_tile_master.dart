import 'package:flutter/material.dart';
import 'package:flutter_huixin_app/common/constants/color.dart';
import 'package:flutter_huixin_app/cubit/mastering/master_level/master_level_cubit.dart';

class TileMasterLevel extends StatelessWidget {
  final int index;
  final String levelName;
  final String levelImageUrl;
  final String levelImage;
  final MasterLevelState state;

  const TileMasterLevel({
    super.key,
    required this.index,
    required this.levelName,
    required this.levelImage,
    required this.levelImageUrl,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    /// This function is used to select the level
    /// and navigate to the course selector page
    /// if the level is unlocked
    /// or show a dialog if the level is locked
    void selectLevel() {
      state.maybeMap(
        orElse: () => null,
        loaded: (state) {
          if (index == 0) {
            Navigator.pushNamed(
              context,
              '/course_selector',
              arguments: {
                'level_id': state.data.data![index].idLevel,
                'level_name': levelName,
              },
            );
          } else {
            return (state.data.data![index].reportReading!.isNotEmpty ||
                    state.data.data![index].reportSpeaking!.isNotEmpty)
                ? Navigator.pushNamed(
                    context,
                    '/course_selector',
                    arguments: {
                      'level_id': state.data.data![index].idLevel,
                      'level_name': levelName,
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Level Locked'),
                        content:
                            const Text('Please complete the previous level'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
          }
        },
      );
    }

    return InkWell(
      onTap: selectLevel,
      child: Card(
        color: AppColors.whiteColor,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/crown.png",
                  height: 10,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  '1/2',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: state.maybeMap(
                orElse: () => null,
                loaded: (state) {
                  if (index == 0) {
                    return Container(
                      color: AppColors.bottom,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                levelName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Image.network(
                                'https://huixin.id/assets/level/$levelImage',
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                "assets/images/progress_bar.png",
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return (state.data.data![index].reportReading!.isNotEmpty ||
                            state.data.data![index].reportSpeaking!.isNotEmpty)
                        ? Container(
                            color: AppColors.bottom,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      levelName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Image.network(
                                      'https://huixin.id/assets/level/$levelImage',
                                      height: 80,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 8),
                                    Image.asset(
                                      "assets/images/progress_bar.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.whiteColor2,
                            child: Center(
                              child: Image.asset(
                                "assets/images/lock.png",
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                  }
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}