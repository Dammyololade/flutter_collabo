import 'package:flutter/material.dart';

import '../AppConfig.dart';

typedef TextValidator = Function(String value);

///
/// project: flutter_collabo
/// @package: custom
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class CustomWidgets {

  static positiveButton(String title, VoidCallback callback)
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: RaisedButton(
        onPressed: callback,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text("$title",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        color: AppConfig.APP_BUTTON_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static negativeButton(String title, VoidCallback callback, {TextStyle textStyle})
  {
    return FlatButton(
      onPressed: callback,
      child: Text("$title",
        style: textStyle ?? TextStyle(fontSize: 15),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static Widget inputCard(Widget child, {
    bool validated, IconData icon, bool showValidationIcon = false})
  {
    return Card(
      margin: EdgeInsets.only(left: 20, top: 10, right: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.grey, size: 20,),

            SizedBox(width: 5,),

            Expanded(child: child),

            SizedBox(width: showValidationIcon ? 5 : 0,),

            !showValidationIcon ? SizedBox() :
            Icon(Icons.done, size: 20, color: validated ? Colors.green : Colors.grey,),
          ],
        ),
      ),
    );
  }

  static titleStyle()
  {
    return TextStyle(
        color: AppConfig.APP_PRIMARY_COLOR,
        fontSize: 25,
        fontWeight: FontWeight.w600
    );
  }

  static Widget FormTextField(String label, String hint, TextEditingController _controller,
      TextInputType inputType, String errorMessage, {bool isObscureText = false, Color borderColor, TextValidator textValidator,
        bool isLastTextField = false, FocusNode focusNode, FocusNode nextFocusNode,
        BuildContext context, TextStyle labelTextStyle, String prefixText = "", bool hasBorder = true,
        TextStyle hintStyle, TextStyle inputStyle = const TextStyle(color: Colors.black), EdgeInsets contentPadding = const EdgeInsets.all(5)
      })
  {
    return Center(
      child: Column(
        children: <Widget>[
          label.isEmpty ? SizedBox() :
          Row(
            children: <Widget>[
              Text(label, style: labelTextStyle ?? TextStyle(color: Color(0xFF716D73), fontSize: 15, fontWeight: FontWeight.w500),)
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: hintStyle ?? TextStyle(
                  color: Color(0XFF757575),
                  fontSize: 13
              ),
              errorStyle: TextStyle(color: Colors.red, fontSize: 10),
              border: !hasBorder ? InputBorder.none : UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: borderColor ?? Colors.black26,
                      width: 1
                  )
              ),
              enabledBorder: !hasBorder ? InputBorder.none : UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: borderColor ?? Colors.black26,
                      width: 1
                  )
              ),
              contentPadding: contentPadding,
              prefixText: prefixText,
            ),
            controller: _controller,
            maxLines: 1,
            enabled: true,
            keyboardType: inputType,
            obscureText: isObscureText ?? false,
            textInputAction: isLastTextField ? TextInputAction.done : TextInputAction.next,
            validator: textValidator ?? (value) {
              if(value.isEmpty) {
                return errorMessage;
              }
            },
            focusNode: focusNode,
            onFieldSubmitted: (term){
              if(focusNode != null && context != null){
                isLastTextField ? FocusScope.of(context).consumeKeyboardToken()
                    : FocusScope.of(context).requestFocus(nextFocusNode);
              }
            },
            style: inputStyle,
          ),
        ],
      ),
    );
  }

}