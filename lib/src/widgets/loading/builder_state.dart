import 'package:flutter/material.dart';
enum Behaviour {success, error,  loading}

class BuilderStateWidget extends StatefulWidget {
  final Widget Function(BuildContext context) success;
  final Widget Function(BuildContext context)? loading;
  final Widget Function(BuildContext context)? error;
  final Behaviour behaviour;
  const BuilderStateWidget({
    Key? key,
    required this.behaviour,
    required this.success,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  _BuilderStateWidgetState createState() => _BuilderStateWidgetState();
}

class _BuilderStateWidgetState extends State<BuilderStateWidget> {
  
  Widget Function(BuildContext context)? _builder() {
    switch (widget.behaviour) {
      case Behaviour.success:
        return widget.success;
      case Behaviour.loading:
        return widget.loading;
      case Behaviour.error:
        return widget.error;
      default:
        return widget.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: _builder()!,
    );
  }
}
