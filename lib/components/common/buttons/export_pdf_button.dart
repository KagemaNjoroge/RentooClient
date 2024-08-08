import 'package:flutter/material.dart';

class ExportPdfButton extends StatefulWidget {
  Function? callBack;
  ExportPdfButton({super.key, this.callBack});

  @override
  State<ExportPdfButton> createState() => _ExportPdfButtonState();
}

class _ExportPdfButtonState extends State<ExportPdfButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Download as PDF",
      onPressed: () {
        if (widget.callBack != null) {
          widget.callBack!();
        }
      },
      icon: const Icon(Icons.picture_as_pdf),
    );
  }
}
