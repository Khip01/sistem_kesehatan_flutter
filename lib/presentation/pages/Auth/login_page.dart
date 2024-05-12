import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sistem_kesehatan_flutter/presentation/blocs/auth/auth_bloc.dart';

import '../../extension/strings.dart';
import '../../extension/theme.dart';
import '../../widgets/footer-text-auth.dart';
import '../../widgets/label-text-auth.dart';
import '../../widgets/spacer-height.dart';
import '../../widgets/styled-button.dart';
import '../../widgets/text-field-auth.dart';
import '../../widgets/title-text-auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            emailFocusNode.unfocus();
            passFocusNode.unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 29),
            color: custWhiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerHeight(spaceHeight: 56 + 41),
                      const TitleTextAuth(
                        headerText: headerTextLogin,
                        bodyText: bodyTextLogin,
                      ),
                      const SpacerHeight(spaceHeight: 52),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: LabelTextAuth(
                          labelText: emailFormLogin,
                          sendedContext: context,
                          textFieldFocusNode: emailFocusNode,
                          labelTextColor: custPrimaryColor,
                        ),
                      ),
                      TextFieldAuth(
                        textFieldController: emailController,
                        textFieldFocusNode: emailFocusNode,
                        isPasswordField: false,
                      ),
                      const SpacerHeight(spaceHeight: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: LabelTextAuth(
                          labelText: passForm,
                          sendedContext: context,
                          textFieldFocusNode: passFocusNode,
                          labelTextColor: custPrimaryColor,
                        ),
                      ),
                      TextFieldAuth(
                        textFieldController: passController,
                        textFieldFocusNode: passFocusNode,
                        isPasswordField: true,
                      ),
                      const SpacerHeight(spaceHeight: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                padding: const EdgeInsets.only(right: 7),
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  side: const BorderSide(
                                    width: 0,
                                  ),
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black),
                                  splashRadius: 0,
                                  visualDensity: VisualDensity.compact,
                                  value: isRememberMe,
                                  onChanged: (v) =>
                                      setState(() => isRememberMe = v ?? false),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(
                                    () => isRememberMe = !isRememberMe),
                                child: LabelTextAuth(
                                  labelText: rememberMe,
                                  sendedContext: context,
                                  labelTextColor: custBlackColor,
                                ),
                              ),
                            ],
                          ),
                          LabelTextAuth(
                            labelText: forgotPassword,
                            sendedContext: context,
                            labelTextColor: custRedErrorColor,
                          ),
                        ],
                      ),
                      const SpacerHeight(spaceHeight: 27),
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            loginSuccess: (data) {
                              context.goNamed('dashboard');
                            },
                            error: (message) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            orElse: () {},
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return StyledButton(
                                actionButton: () {
                                  if (emailController.text.isEmpty ||
                                      passController.text.isEmpty) {
                                    debugPrint(
                                        'isi semua data terlebih dahulu!');
                                  }
                                  context.read<AuthBloc>().add(
                                        AuthEvent.login(
                                          emailController.text,
                                          passController.text,
                                        ),
                                      );
                                  debugPrint(emailController.text);
                                  debugPrint(passController.text);
                                },
                                buttonText: textLogin,
                                buttonColor: custPrimaryColor,
                                textColor: custWhiteColor,
                              );
                            },
                            loading: () {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          );
                        },
                      ),
                      const SpacerHeight(spaceHeight: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: custGreyColor))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: Text(
                              orWith,
                              style: TextStyle(color: custGreyColor),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: custGreyColor))),
                            ),
                          ),
                        ],
                      ),
                      const SpacerHeight(spaceHeight: 22),
                      StyledButton(
                        actionButton: () {},
                        buttonText: googleText,
                        buttonColor: custWhiteColor,
                        textColor: custBlackColor,
                        outlineButtonColor: custGreyColor,
                        buttonIconAsSvg:
                            SvgPicture.asset('assets/icons/google.svg'),
                      )
                    ],
                  ),
                ),
                FooterTextAuth(
                  sentenceText: footerTextLogin,
                  pressableText: textSignup,
                  navigateTo: () => context.goNamed('signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
