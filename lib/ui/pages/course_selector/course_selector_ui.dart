import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_huixin_app/cubit/mastering/master_group_materi/master_group_materi_cubit.dart';
import 'package:flutter_huixin_app/data/models/auth/auth_response_model.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_lesson_response_model.dart';
import 'package:flutter_huixin_app/ui/pages/course_selector/components/course_selector_ui_master_group_tile.dart';
import 'package:flutter_huixin_app/ui/pages/course_selector/components/course_selector_ui_master_group_tile_loading.dart';

import '../../../cubit/auth/user/user_cubit.dart';
import '../../widgets/appbar/appbar_style.dart';
import '../../widgets/bottom_appbar_note.dart';

class CourseSelector extends StatefulWidget {
  static const String routeName = '/course_selector';
  const CourseSelector({super.key});

  @override
  State<CourseSelector> createState() => _CourseSelectorState();
}

class _CourseSelectorState extends State<CourseSelector> {
  Lesson? lesson;
  DataUser? user;

  @override
  void initState() {
    context.read<MasterGroupMateriCubit>().setInitial();
    super.initState();

    user = context.read<UserCubit>().state.maybeMap(
          orElse: () => null,
          loaded: (value) => value.data,
        );
  }

  // void _getUser() async {
  //   user = await AppSecureStorage.getUser();
  // }

  @override
  Widget build(BuildContext context) {
    lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
    return Scaffold(
      appBar: AppBarCourse(
        title: lesson?.name ?? '..',
        progression: context.select<MasterGroupMateriCubit, String>(
          (cubit) => cubit.state.maybeMap(
            orElse: () => '../..',
            loaded: (value) {
              return '${value.data.data?.length ?? 0}/${value.data.data?.length ?? 0}';
            },
          ),
        ),
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child:
                  BlocBuilder<MasterGroupMateriCubit, MasterGroupMateriState>(
                builder: (context, state) {
                  return GridView.builder(
                    itemCount: state.maybeMap(
                      orElse: () => 6,
                      loaded: (state) => state.data.data?.length ?? 0,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return state.when(
                        initial: () {
                          context
                              .read<MasterGroupMateriCubit>()
                              .getMasterGroupMateri(
                                  user?.userId ?? '',
                                  lesson?.idLevel ?? '',
                                  lesson?.idLesson ?? '');
                          return null;
                        },
                        loading: () {
                          return const MasterGroupMateriTileLoading();
                        },
                        loaded: (data) {
                          return MasterGroupMateriTile(
                            index: index,
                            state: state,
                            masterGroupMateri: data.data![index],
                          );
                        },
                        error: (message) {
                          return Center(
                            child: Text(message),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBarWithNotes(),
    );
  }
}
