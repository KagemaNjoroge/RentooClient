import 'package:flutter/material.dart';

class ExportCsvButton extends StatefulWidget {
  Function? callBack;
  ExportCsvButton({super.key, this.callBack});

  @override
  State<ExportCsvButton> createState() => _ExportCsvButtonState();
}

class _ExportCsvButtonState extends State<ExportCsvButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Export as CSV/Excel",
      onPressed: () {
        if (widget.callBack != null) {
          widget.callBack!();
        }
      },
      icon: const Icon(Icons.data_object_rounded),
    );
  }
}
