library awesome_input;

import 'package:flutter/material.dart';

class AwesomeInput extends StatefulWidget {
  AwesomeInput({
    Key? key,
    required this.textEditingController,
    required this.headerText,
    this.headerStyle,
    this.errorMsg,
    this.errorTextStyle,
    this.inputBorderRadius,
    this.hintText,
  });
  final TextEditingController textEditingController;
  final String headerText;
  final TextStyle? headerStyle;
  final double? inputBorderRadius;
  final String? errorMsg;
  final TextStyle? errorTextStyle;
  final String? hintText;

  @override
  _AwesomeInputState createState() => _AwesomeInputState(
      textEditingController,
      headerText,
      headerStyle,
      inputBorderRadius,
      errorMsg,
      errorTextStyle,
      hintText);
}

class _AwesomeInputState extends State<AwesomeInput> {
  final TextEditingController textEditingController;
  final String headerText;
  final TextStyle? headerStyle;
  final double? inputBorderRadius;
  final String? errorMsg;
  final TextStyle? errorTextStyle;
  final String? hintText;
  bool showErrorState = false;
  bool _onFocus = false;
  final FocusNode _focusNode = FocusNode();

  _AwesomeInputState(
      this.textEditingController,
      this.headerText,
      this.headerStyle,
      this.inputBorderRadius,
      this.errorMsg,
      this.errorTextStyle,
      this.hintText);
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _onFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _inputHeader(),
        _inputField(),
        if (errorMsg != null) _errorMsg()
      ],
    );
  }

  Widget _inputHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        headerText,
        style: headerStyle ??
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _errorMsg() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        errorMsg!,
        style: errorTextStyle ?? const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _inputField() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(inputBorderRadius ?? 8.0),
          border: Border.all(width: 1, color: _getInputBorderColor())),
      child: TextField(
        autofocus: true,
        focusNode: _focusNode,
        obscuringCharacter: '*',
        autofillHints: const <String>[AutofillHints.oneTimeCode],
        cursorColor: Colors.black,
        keyboardType: TextInputType.visiblePassword,
        controller: textEditingController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    );
  }

  Color _getInputBorderColor() {
    if (showErrorState) {
      return Colors.red;
    }
    return _onFocus == true ? Colors.blue : Colors.grey;
  }
}
