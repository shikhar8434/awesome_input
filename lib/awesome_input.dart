library awesome_input;

import 'package:awesome_input/input_field_type.dart';
import 'package:flutter/material.dart';
import 'package:awesome_input/gen/assets.gen.dart';

class AwesomeInput extends StatefulWidget {
  AwesomeInput(
      {Key? key,
      required this.inputFieldType,
      required this.textEditingController,
      required this.headerText,
      this.headerStyle,
      this.errorMsg,
      this.errorTextStyle,
      this.inputBorderRadius,
      this.hintText,
      this.updateParentState});
  final InputFieldType inputFieldType;
  final TextEditingController textEditingController;
  final String headerText;
  final TextStyle? headerStyle;
  final double? inputBorderRadius;
  final String? errorMsg;
  final TextStyle? errorTextStyle;
  final String? hintText;
  final Function()? updateParentState;

  @override
  _AwesomeInputState createState() => _AwesomeInputState(
      inputFieldType,
      textEditingController,
      headerText,
      headerStyle,
      inputBorderRadius,
      errorMsg,
      errorTextStyle,
      hintText,
      updateParentState);
}

class _AwesomeInputState extends State<AwesomeInput> {
  final TextEditingController textEditingController;
  final String headerText;
  final TextStyle? headerStyle;
  final double? inputBorderRadius;
  final String? errorMsg;
  final TextStyle? errorTextStyle;
  final String? hintText;
  final InputFieldType inputFieldType;
  final Function()? updateParentState;
  bool showErrorState = false;
  bool _onFocus = false;
  bool _expandTextArea = false;
  bool _showDropDown = false;
  final FocusNode _focusNode = FocusNode();

  _AwesomeInputState(
      this.inputFieldType,
      this.textEditingController,
      this.headerText,
      this.headerStyle,
      this.inputBorderRadius,
      this.errorMsg,
      this.errorTextStyle,
      this.hintText,
      this.updateParentState);
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
        _getInputField(inputFieldType),
        if (errorMsg != null) _errorMsg(),
        if (_showDropDown) _dropDownList()
      ],
    );
  }

  Widget _getInputField(InputFieldType type) {
    switch (type) {
      case InputFieldType.DefaultInputField:
        return _inputField();
      case InputFieldType.TextAreaField:
        return _textAreaInput();
      case InputFieldType.PasswordInputField:
        return _inputField(obscureText: true);
      case InputFieldType.CalendarField:
        return _inputField();
      case InputFieldType.DropDownInputField:
        return _inputField();
    }
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

  Widget _dropDownList() {
    return Container(
      color: Colors.black,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                "item",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }),
    );
  }

  Widget _inputField({bool? obscureText}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(inputBorderRadius ?? 8.0),
          border: Border.all(width: 1, color: _getInputBorderColor())),
      child: TextFormField(
        autofocus: true,
        focusNode: _focusNode,
        obscuringCharacter: '*',
        obscureText: obscureText != null ? obscureText : false,
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
          suffixIcon: getSuffixIcon(),
          hintStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
      ),
    );
  }

  Widget getSuffixIcon() {
    return inputFieldType == InputFieldType.DropDownInputField
        ? InkWell(
            onTap: () {
              setState(() {
                _showDropDown = !_showDropDown;
                updateParentState!();
              });
            },
            child: Icon(Icons.keyboard_arrow_down_outlined))
        : Container();
  }

  Color _getInputBorderColor() {
    if (showErrorState) {
      return Colors.red;
    }
    return _onFocus == true ? Colors.blue : Colors.grey;
  }

  Widget _textAreaInput() {
    return Container(
        height: _expandTextArea ? 400 : 200,
        padding: const EdgeInsets.all(16),
        child: Container(
            padding:
                const EdgeInsets.only(top: 16, left: 12, right: 4, bottom: 4),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Stack(children: [
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type Here..",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 32,
                  width: 32,
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 4, left: 8, right: 4),
                  child: InkWell(
                      onTap: (() {
                        setState(() {
                          _expandTextArea = !_expandTextArea;
                        });
                      }),
                      child: Assets.icons.calendar.svg(color: Colors.red)),
                ),
              )
            ])));
  }
}
