import 'package:flutter/material.dart';
import 'package:homsai/themes/card.theme.dart';

enum AlertType { tips, warning, error, info }

class AlertAction {
  final String label;
  final void Function() onPressed;

  AlertAction(this.label, this.onPressed);
}

class Alert extends StatefulWidget {
  const Alert(
    this.type, {
    Key? key,
    this.icon,
    required this.title,
    this.message,
    this.action,
    this.cancelable = true,
    this.closeBtnAction,
  }) : super(key: key);

  final AlertType type;
  final Widget? icon;
  final Widget title;
  final Widget? message;
  final bool cancelable;
  final AlertAction? action;
  final void Function()? closeBtnAction;

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  bool isClosed = false;

  ThemeData getCardTheme(BuildContext context, AlertType type) {
    switch (type) {
      case AlertType.tips:
        return HomsaiCardTheme.tipAlertTheme(Theme.of(context));
      case AlertType.warning:
        return HomsaiCardTheme.warningAlertTheme(Theme.of(context));
      case AlertType.error:
        return HomsaiCardTheme.errorAlertTheme(Theme.of(context));
      case AlertType.info:
        return HomsaiCardTheme.infoAlertTheme(Theme.of(context));
    }
  }

  void close() {
    setState(() {
      isClosed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isClosed) return const SizedBox.shrink();
    return Theme(
      data: getCardTheme(context, widget.type),
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, right: 16, left: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.icon != null)
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: widget.icon!),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: widget.title,
                          ),
                          if (widget.cancelable)
                            InkWell(
                              onTap: widget.closeBtnAction ?? close,
                              borderRadius: BorderRadius.circular(20),
                              child: const Icon(Icons.close_rounded),
                            ),
                        ],
                      ),
                      if (widget.message != null) const SizedBox(height: 9),
                      if (widget.message != null) widget.message!,
                      (widget.action != null)
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: widget.action!.onPressed,
                                child: Text(widget.action!.label),
                              ),
                            )
                          : const SizedBox(height: 9),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
