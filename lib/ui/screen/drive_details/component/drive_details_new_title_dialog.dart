import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap.dart';
import '../../../extensions/context_extensions.dart';
import '../cubit/drive_details_cubit.dart';
import '../cubit/drive_details_state.dart';

class DriveDetailsNewTitleDialog extends StatelessWidget {
  const DriveDetailsNewTitleDialog({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: _AppBar(),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: _Form(),
        ),
      );
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(context.str.driveDetailsEditTitle),
        centerTitle: true,
        leading: const BackButton(),
      );
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<_Form> {
  TextEditingController? _textFieldController;

  @override
  void initState() {
    final String? currentTitle =
        context.read<DriveDetailsCubit>().state.drive?.title;
    _textFieldController = TextEditingController(text: currentTitle);
    super.initState();
  }

  void _onSave() {
    final String? newTitle = _textFieldController?.text;
    if (newTitle != null) {
      context.read<DriveDetailsCubit>().saveNewTitle(newTitle);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _TitleTextField(
            controller: _textFieldController,
          ),
          const GapVertical24(),
          _SaveButton(
            onPressed: _onSave,
          ),
        ],
      );
}

class _TitleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode _focusNode = FocusNode();

  _TitleTextField({
    required this.controller,
  });

  void _onTapOutside(_) {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final DriveDetailsStateStatus cubitStatus = context.select(
      (DriveDetailsCubit cubit) => cubit.state.status,
    );

    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: context.str.driveDetailsNewTitleTextFieldPlaceholder,
        errorText: cubitStatus == DriveDetailsStateStatus.newTitleIsEmptyString
            ? context.str.requiredField
            : null,
      ),
      controller: controller,
      focusNode: _focusNode,
      onTapOutside: _onTapOutside,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(context.str.save),
        ),
      );
}
