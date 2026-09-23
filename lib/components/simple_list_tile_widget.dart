import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'simple_list_tile_model.dart';
export 'simple_list_tile_model.dart';

/// Reusable list row with a title and subtitle.
class SimpleListTileWidget extends StatefulWidget {
  const SimpleListTileWidget({
    super.key,
    this.title,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;

  @override
  State<SimpleListTileWidget> createState() => _SimpleListTileWidgetState();
}

class _SimpleListTileWidgetState extends State<SimpleListTileWidget> {
  late SimpleListTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SimpleListTileModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          widget.title!,
          style: TextStyle(),
        ),
        subtitle: Text(
          widget.subtitle!,
          style: TextStyle(),
        ),
        dense: false,
      ),
    );
  }
}
