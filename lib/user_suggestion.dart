import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mathemagician/colors.dart';


class UserSuggestionOptional extends StatelessWidget {
  final bool showText;
  final Widget child;
  final String text;

  const UserSuggestionOptional({Key key, this.child, this.text, this.showText: true}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (!showText) return child;
    return new UserSuggestion(child: child, text: text);
  }
}


class UserSuggestion extends StatefulWidget {
  static const double ARROW_WIDTH = 15.0;
  static const double CHILD_PADDING = 7.0;
  static const double TOOLTIP_DX = 35.0;
  static const double MAX_WIDTH = 220.0;

  final Widget child;
  final String text;

  const UserSuggestion({Key key, this.child, this.text}) : super(key: key);

  @override
  _UserSuggestionState createState() => new _UserSuggestionState();
}

class _UserSuggestionState extends State<UserSuggestion> {
  Offset target;
  OverlayEntry tooltip;
  OverlayEntry arrow;
  final GlobalKey childKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _hideTooltip();
    tooltip = new OverlayEntry(
      opaque: false,
      builder: (context) => _buildTooltip(context),
    );
    arrow = new OverlayEntry(
      opaque: false,
      builder: (context) => _buildTooltipArrow(context),
    );

    // not possible inside initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(arrow);
      Overlay.of(context).insert(tooltip);
    });
  }

  @override
  void deactivate() {
    _hideTooltip();
    super.deactivate();
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: widget.child,
      key: childKey,
    );
  }

  void _hideTooltip() {
    if (tooltip != null) {
      tooltip.remove();
      arrow.remove();
      tooltip = arrow = null;
    }
  }

//
//  void _handleOnTap(BuildContext context) {
//    final RenderBox box = context.findRenderObject();
//    setState(() {
//      target = box.localToGlobal(box.size.center(Offset.zero));
//      print(target);
//    });
//  }

  Widget _buildTooltip(BuildContext context) {
    final keyContext = childKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final RenderBox box = keyContext.findRenderObject();
      final Offset pos = box.localToGlobal(Offset.zero);
      final double screenWidth = MediaQuery.of(context).size.width;

      double leftOffset = pos.dx - UserSuggestion.TOOLTIP_DX + box.size.width / 2;
      double overflow = max(0.0, leftOffset + UserSuggestion.MAX_WIDTH - screenWidth + 10.0);
      leftOffset -= overflow;

      return new Positioned(
        top: pos.dy + box.size.height + UserSuggestion.CHILD_PADDING + UserSuggestion.ARROW_WIDTH / 2,
        left: leftOffset,
        child: new Material(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(
              maxWidth: UserSuggestion.MAX_WIDTH,
            ),
            child: _buildTooltipContent(),
          ),
        ),
      );
    }
    return new Offstage();
  }

  Widget _buildTooltipContent() {
    return new Container(
      decoration: new BoxDecoration(
        // TODO: cut corners
        borderRadius: new BorderRadius.circular(7.0),
        color: tooltipColor,
      ),
      alignment: Alignment.center,
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Expanded(
              child: new Text(
                widget.text,
                style: Theme.of(context).textTheme.body1.copyWith(color: tooltipTextColor),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: new GestureDetector(
                child: new Icon(Icons.clear, size: 20.0, color: tooltipButtonColor),
                onTap: _hideTooltip,
              ),
            )
          ],
        ),
      ),
    );
//        _buildTooltipArrow(),
  }

  Widget _buildTooltipArrow(BuildContext context) {
    final keyContext = childKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final RenderBox box = keyContext.findRenderObject();
      final Offset pos = box.localToGlobal(Offset.zero);
      return new Positioned(
        top: pos.dy + box.size.height + UserSuggestion.CHILD_PADDING,
        left: pos.dx + box.size.width / 2 - UserSuggestion.ARROW_WIDTH * sqrt2 / 2,
        child: new Transform.rotate(
          angle: pi / 4,
          child: new Container(
            color: tooltipColor,
            width: UserSuggestion.ARROW_WIDTH,
            height: UserSuggestion.ARROW_WIDTH,
          ),
        ),
      );
    }
    return new Offstage();
  }
}
