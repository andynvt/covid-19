import 'package:covid/core/language/language.dart';
import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';

class TTDialog {
  static TTDialog _sInstance;

  TTDialog._();

  factory TTDialog.shared() {
    if (_sInstance == null) {
      _sInstance = TTDialog._();
    }
    return _sInstance;
  }

  void showAlert(
      BuildContext context, {
        String title,
        @required String message,
        String okText,
        Function callback,
      }) {
    assert(context != null);
    assert(message != null);
    if (okText == null) {
      okText = Language.get.ok;
    }
    _showDialog(context,
        message: message,
        title: title,
        okText: okText,
        okCallback: callback,
        cancelText: null);
  }

  void showConfirm(
      BuildContext context, {
        String title,
        @required String message,
        String okText,
        String cancelText,
        Function okCallback,
        Function cancelCallback,
      }) {
    assert(message != null);
    _showDialog(context,
        isConfirmed: true,
        message: message,
        title: title,
        okText: okText,
        cancelText: cancelText,
        okCallback: okCallback,
        cancelCallback: cancelCallback);
  }

  void _showDialog(
      BuildContext context, {
        bool isConfirmed = false,
        String title = '',
        @required String message,
        String okText,
        String cancelText,
        Function okCallback,
        Function cancelCallback,
      }) {
    if (okText == null) {
      okText = Language.get.ok;
    }
    if (cancelText == null && isConfirmed) {
      cancelText = Language.get.cancel;
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Cl.grey300,
          elevation: 0,
          contentPadding: const EdgeInsets.only(top: 16, bottom: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: title != null
              ? Text(
            title,
            textAlign: TextAlign.center,
            style: Style.alertTitle,
          )
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: title != null
                    ? EdgeInsets.symmetric(horizontal: 16)
                    : EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Style.alertMessage,
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(top: 30),
                color: Cl.brownGrey,
              ),
              Container(
                height: 56,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(_).pop();
                            if (okCallback != null) {
                              okCallback();
                            }
                          },
                          child: Text(
                            okText,
                            style: Style.alertButton,
                          ),
                        ),
                      ),
                    ),
                    cancelText != null
                        ? Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(_).pop();
                            if (cancelCallback != null) {
                              cancelCallback();
                            }
                          },
                          child: Text(
                            cancelText,
                            style: Style.alertButton,
                          ),
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
