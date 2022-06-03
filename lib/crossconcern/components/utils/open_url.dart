import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

void openUrl(BuildContext context, String url) async {
  if (await canLaunchUrlString(url)) {
    launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            HomsaiLocalizations.of(context)!.accountBugReportErrorText + url),
      ),
    );
  }
}
