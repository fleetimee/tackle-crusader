// ignore_for_file: override_on_non_overriding_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_huixin_app/cubit/auth/register_apple/register_apple_cubit.dart';
import 'package:flutter_huixin_app/cubit/auth/register_google/register_google_cubit.dart';
import 'package:flutter_huixin_app/data/models/auth/requests/register_request_model.dart';
import 'package:flutter_huixin_app/ui/pages/signin/signin_ui.dart';
import 'package:flutter_huixin_app/ui/widgets/dialog_box.dart';
import 'package:flutter_huixin_app/ui/widgets/social_icons_button.dart';
import 'package:flutter_huixin_app/utils/uuid_gen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../cubit/auth/register/register_cubit.dart';
import '../../widgets/appbar/appbar_style.dart';
import '../../widgets/button.dart';
import '../../widgets/register_form.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// Initialize FormBuilder global key
  /// that will be used to validate form
  /// and store it in [_fbKey] variable
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  /// Initialize File variable for image picker
  /// that will be used to store the image
  @override
  File? _image;

  /// Dispose the controllers
  /// to avoid memory leaks
  /// when the widget is removed from the widget tree
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _noMemberController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  /// Initialize Image Picker
  /// that will be used to pick image from gallery or camera
  /// and store it in [_image] variable
  Future<void> _pickImage(ImageSource source) async {
    /// Pick image from gallery or camera
    /// and store it in [pickedFile] variable
    final pickedFile = await ImagePicker().pickImage(source: source);

    /// Check if the image is not null
    /// and store it in [_image] variable
    /// to display it in the UI
    if (pickedFile != null) {
      setState(() {
        /// Store the image in [_image] variable
        _image = File(pickedFile.path);
      });
    }
  }

  /// Bunch of TextEditingControllers
  /// that will be used to get the value of the text field
  /// and pass it to the [AuthCubit]
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noMemberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  RegisterRequestModel _buildRegisterRequestModel() {
    return RegisterRequestModel(
      user_name: _usernameController.text,
      email: _emailController.text,
      user_password: _passwordController.text,
      no_member: _noMemberController.text,
      full_name: _fullNameController.text,
      birth_date: _birthDateController.text,
      token_device: UUIDGenerator.generateUUID(),
      img_file: _image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              loaded: (user) {
                if (user.status == 'Error') {
                  ErrorDialog(
                    context: context,
                    title: 'Error',
                    desc: user.message!,
                    btnOkOnPress: () {},
                    btnOkText: 'OK',
                  ).show();
                } else {
                  SuccessDialog(
                    context: context,
                    title: 'Success',
                    desc:
                        'Your registration is successfull, please login to access the application',
                    btnOkOnPress: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ).show();
                }
              },
              error: (error) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                ),
              ),
            );
          },
        ),
        BlocListener<RegisterGoogleCubit, RegisterGoogleState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              loaded: (user) {
                SuccessDialog(
                  context: context,
                  title: 'Success',
                  desc:
                      'Your registration with Google Account is successfull, please login to access the application, and don\'t forget to change your details in the profile page',
                  btnOkOnPress: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                ).show();
              },
              error: (error) => showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: 'Register with Google Account failed',
                ),
              ),
            );
          },
        ),
        BlocListener<RegisterAppleCubit, RegisterAppleState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              loaded: (user) {
                SuccessDialog(
                  context: context,
                  title: 'Success',
                  desc:
                      'Your registration with Apple ID is successfull, please login to access the application, and don\'t forget to change your details in the profile page',
                  btnOkOnPress: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                ).show();
              },
              error: (error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Register with Apple ID failed'),
                ),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return LoaderOverlay(
            child: Scaffold(
              appBar: AppBarDefault(
                title: "Signup",
              ),
              body: FormBuilder(
                /// Initialize FormBuilder global
                /// key to validate the form
                key: _fbKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                            ),
                            _imagePicker(),
                            const SizedBox(
                              height: 20.0,
                            ),
                            RegisterForm(
                                name: 'username',
                                label: 'Username',
                                controller: _usernameController,
                                obscureTextEnabled: 'false',
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(
                                      6,
                                      allowEmpty: false,
                                      errorText:
                                          'Username must be at least 6 characters',
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RegisterForm(
                              name: 'email',
                              label: 'Email',
                              controller: _emailController,
                              obscureTextEnabled: 'false',
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RegisterForm(
                              name: 'password',
                              label: 'Password',
                              controller: _passwordController,
                              obscureTextEnabled: 'true',
                              obscureToggle: true,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                    errorText: 'Password is required',
                                  ),
                                  FormBuilderValidators.minLength(
                                    6,
                                    allowEmpty: false,
                                    errorText:
                                        'Password must be at least 6 characters',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RegisterForm(
                              name: 'noMember',
                              label: 'No Member',
                              controller: _noMemberController,
                              obscureTextEnabled: 'false',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RegisterForm(
                              name: 'fullName',
                              label: 'Full Name',
                              controller: _fullNameController,
                              obscureTextEnabled: 'false',
                              validator: FormBuilderValidators.required(),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            RegisterFormDate(
                              name: 'birth_date',
                              label: 'Birth Date',
                              controller: _birthDateController,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            PrimaryButton(
                              text: state.maybeWhen(
                                loading: () => 'Loading...',
                                orElse: () => 'Sign Up',
                              ),
                              onPressed: () {
                                if (_fbKey.currentState?.saveAndValidate() ??
                                    false) {
                                  if (_image == null) {
                                    _showErrorDialog(
                                        context, 'Please choose picture');
                                  } else {
                                    context.loaderOverlay.show();
                                    context
                                        .read<RegisterCubit>()
                                        .register(
                                          _buildRegisterRequestModel(),
                                        )
                                        .then((value) =>
                                            context.loaderOverlay.hide())
                                        .onError((error, stackTrace) =>
                                            context.loaderOverlay.hide());
                                  }
                                } else {
                                  debugPrint('validation failed');
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Text(
                              'Or Sign Up With',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SocialIcon(
                              onTapApple: () {
                                context
                                    .read<RegisterAppleCubit>()
                                    .registerWithApple();
                              },
                              onTapFacebook: () {
                                // context.read<LoginFbCubit>().registerWithFb();
                              },
                              onTapGoogle: () {
                                context.loaderOverlay.show();

                                context
                                    .read<RegisterGoogleCubit>()
                                    .registerWithGoogle()
                                    .then(
                                        (value) => context.loaderOverlay.hide())
                                    .onError((error, stackTrace) =>
                                        context.loaderOverlay.hide());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imagePicker() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: _image == null
              ? CircleAvatar(
                  radius: 80,
                  child: Image.asset(
                    "assets/images/photo-placeholder.png",
                    fit: BoxFit.fill,
                  ),
                )
              : CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(_image!),
                ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 10,
          right: MediaQuery.of(context).size.width / 2 - 80,
          child: GestureDetector(
            child: Image.asset(
              "assets/images/photo-picker.png",
              fit: BoxFit.fill,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text('Take a picture'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _pickImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Select from gallery'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
