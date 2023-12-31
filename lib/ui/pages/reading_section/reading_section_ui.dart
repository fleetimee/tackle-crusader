import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_huixin_app/cubit/mastering/master_materi/master_materi_cubit.dart';
import 'package:flutter_huixin_app/cubit/materi/finish_materi/finish_materi_cubit.dart';
import 'package:flutter_huixin_app/cubit/materi/loging_header/loging_header_cubit.dart';
import 'package:flutter_huixin_app/cubit/materi/loging_lines/loging_lines_cubit.dart';
import 'package:flutter_huixin_app/data/models/auth/auth_response_model.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_materi_response_model.dart';
import 'package:flutter_huixin_app/data/models/materi_pelajaran/requests/loging_lines_request_model.dart';
import 'package:flutter_huixin_app/ui/pages/home/home_ui.dart';
import 'package:flutter_huixin_app/ui/widgets/not_found.dart';
import 'package:flutter_sound/flutter_sound.dart';

// import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart'
    as fsr;
import 'package:quickalert/quickalert.dart';

import '../../../common/constants/color.dart';
import '../../../cubit/auth/user/user_cubit.dart';
import '../../../cubit/mastering/master_group_materi/master_group_materi_cubit.dart';
import '../../../data/models/mastering/master_group_materi_response_model.dart';
import '../../../data/models/materi_pelajaran/requests/finish_materi_request_model.dart';
import '../../widgets/appbar/appbar_style.dart';
import '../../widgets/bottom_appbar_button.dart';
import '../../widgets/container_course.dart';

typedef _Fn = void Function();

class ReadingSection extends StatefulWidget {
  static const String routeName = '/reading_section';
  const ReadingSection({super.key});

  @override
  State<ReadingSection> createState() => _ReadingSectionState();
}

class _ReadingSectionState extends State<ReadingSection> {
  DataUser? dataUser;
  bool _isVolumeClicked = false;
  bool _isMicrophoneClicked = false;
  int _currentContent = 0;
  int totalContent = 0;

  ReadingMateri? readingMateri;
  DataUser? user;
  // late AudioPlayer player;

  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  final FlutterSoundPlayer _mPlayerAnswer = FlutterSoundPlayer();
  final FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  Codec _codec = Codec.aacMP4;
  String _mPath = 'fleetime.mp4';
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  MasterMateri? masterMateri;

  @override
  void initState() {
    context.read<MasterMateriCubit>().setInitial();
    dataUser = context.read<UserCubit>().state.maybeMap(
          orElse: () => null,
          loaded: (value) => value.data,
        );
    _mPlayer.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });

    user = context.read<UserCubit>().state.maybeMap(
          orElse: () => null,
          loaded: (value) => value.data,
        );
    super.initState();
    // player = AudioPlayer();
  }

  @override
  void dispose() {
    // player.dispose();
    _mPlayer.closePlayer();
    _mPlayerAnswer.closePlayer();

    _mRecorder.closeRecorder();
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openRecorder();
    if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  void record() {
    _mRecorder
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: fsr.AudioSource.microphone,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        _mplaybackReady = true;
        _isMicrophoneClicked = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    _mPlayer
        .startPlayer(
            fromURI: _mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void playAnswer(String url) async {
    ap.AudioPlayer audioPlayer = ap.AudioPlayer();
    await audioPlayer.play(ap.UrlSource(url));
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {});
    });
  }

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }
    return _mRecorder.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return null;
    }
    return _mPlayer.isStopped ? play : stopPlayer;
  }

  // void _playAudio(audioUrl) async {
  //   debugPrint('audioUrl: $audioUrl');
  //   await player.setUrl(audioUrl);
  //   player.setVolume(1);
  //   player.play();
  // }

  @override
  Widget build(BuildContext context) {
    readingMateri = ModalRoute.of(context)!.settings.arguments as ReadingMateri;

    final state = context.watch<MasterMateriCubit>().state;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBarReading(
          title: 'Reading',
          context: context,
          disabledRoute: false,
        ),
        body: state.maybeMap(
            orElse: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            initial: (value) {
              context.read<MasterMateriCubit>().getMasterMateri(
                    user!.userId!,
                    readingMateri!.masterGroupMateri.idLevel!,
                    readingMateri!.masterGroupMateri.idGroupMateri!,
                  );
              return null;
            },
            loaded: (value) {
              if (value.data.data == null || value.data.data!.isEmpty) {
                return const NotFound(
                  text:
                      'This course is currently empty, please wait until the course is ready',
                );
              }
              final materi = value.data.data![_currentContent];
              masterMateri = materi;
              totalContent = value.data.data!.length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: ContainerCourse(
                                    text: materi.latihanTitle!,
                                    color: _isMicrophoneClicked == true
                                        ? AppColors.whiteColor4
                                        : Colors.white,
                                  ),
                                ),
                                Positioned(
                                  top: MediaQuery.of(context).size.height *
                                      0.267,
                                  left: MediaQuery.of(context).size.width * 0.6,
                                  child: IconButton(
                                    enableFeedback: true,
                                    iconSize: 50,
                                    onPressed: () {
                                      setState(() {
                                        _isVolumeClicked = true;

                                        playAnswer(
                                            '${materi.latihanUrlFile!.replaceAll('/level', '')}${materi.latihanVoice}');
                                      });
                                    },
                                    icon: Image.asset(
                                      "assets/images/volume_reading.png",
                                      fit: BoxFit.contain,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _isVolumeClicked,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      materi.latihanCina!,
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      materi.latihanIndonesia!,
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: getRecorderFn(),
                                      child: Image.asset(
                                        "assets/images/microphone.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      _mRecorder.isRecording ? 'Stop' : 'Speak',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.yellowColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    if (_isMicrophoneClicked)
                                      ElevatedButton(
                                        onPressed: getPlaybackFn(),
                                        child: Text(
                                          _mPlayer.isPlaying ? 'Stop' : 'Play',
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
        bottomNavigationBar: BottomNavigationBarButton(
          name: totalContent == _currentContent + 2 ? 'FINISH' : 'NEXT',
          color:
              _isMicrophoneClicked ? AppColors.greenColor : AppColors.greyWhite,
          onTap: _isMicrophoneClicked
              ? totalContent == _currentContent + 2
                  ? () async {
                      File voiceFile = File((await _mRecorder.stopRecorder())!);
                      context.read<LogingLinesCubit>().postLogingLines(
                            LogingLinesRequestModel(
                              id_log_materi_header:
                                  readingMateri!.logingHeaderId,
                              id_materi: masterMateri!.idMateri!,
                              user_id: dataUser!.userId!,
                              voice_try: voiceFile,
                            ),
                          );
                      context.read<FinishMateriCubit>().finishMateri(
                            FinishMateriRequestModel(
                              user_id: dataUser!.userId!,
                              id_level: masterMateri!.idLevel!,
                              id_group_materi: readingMateri!
                                  .masterGroupMateri.idGroupMateri!,
                              id_lesson:
                                  readingMateri!.masterGroupMateri.idLesson!,
                              mode: 'reading',
                            ),
                          );
                      context.read<LogingHeaderCubit>().setInitial();
                      context.read<LogingLinesCubit>().setInitial();
                      context.read<MasterMateriCubit>().setInitial();
                      final newMasterGroupMateri =
                          readingMateri!.masterGroupMateri;
                      newMasterGroupMateri.statusReading = 'finish';
                      context
                          .read<MasterGroupMateriCubit>()
                          .getMasterGroupMateri(dataUser!.userId!,
                              masterMateri!.idLevel!, masterMateri!.idLesson!);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        HomePage.routeName,
                        (route) => false,
                      );

                      // showTopSnackBar(
                      //   Overlay.of(context),
                      //   CustomSnackBar.success(
                      //     message:
                      //         "Reading ${readingMateri!.masterGroupMateri.name} has been finished, you can proceed to the exercise section",
                      //   ),
                      // );
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text:
                            'reading lesson complete, please now do reading exercise',
                      );
                    }
                  : () async {
                      File voiceFile = File((await _mRecorder.stopRecorder())!);
                      context.read<LogingLinesCubit>().postLogingLines(
                            LogingLinesRequestModel(
                              id_log_materi_header:
                                  readingMateri!.logingHeaderId,
                              id_materi: masterMateri!.idMateri!,
                              user_id: dataUser!.userId!,
                              voice_try: voiceFile,
                            ),
                          );
                      setState(
                        () {
                          ++_currentContent;
                          _isVolumeClicked = false;
                          _isMicrophoneClicked = false;
                        },
                      );
                    }
              : () {},
        ),
      ),
    );
  }
}
