import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mathemagician/utils.dart';

class MathNet extends CustomPainter {
  Random _random;
  final EdgeInsets _areaToPaint;

  static const double MEAN_NODE_DIST = 75.0;
  static const double NODE_DIST_VARIANCE = 100.0;
  static const double NODE_RADIUS = 12.0;
  static const double LINE_PROB = 0.85;
  static const double OFFSCREEN_TOLERANCE = 50.0;
  static const int BACKGROUND_COLOR = 0xFF74AEBE;
  static const int LINES_COLOR = 0xFF4A6A73;
  static const int TEXT_COLOR = 0xFF02556C;

  MathNet(this._areaToPaint)
      // must provide ratios
      : assert(_areaToPaint.top < 1 && _areaToPaint.right < 1 && _areaToPaint.bottom < 1 && _areaToPaint.left < 1);

  List<List<Node>> _generateNodes(Size size) {
    Rectangle reservedCenter = _getReservedRectangle(size);
    List<List<Node>> nodes = [];
    for (int row = 0;; row++) {
      double meanY = row * MEAN_NODE_DIST - OFFSCREEN_TOLERANCE;
      if (meanY > size.height + OFFSCREEN_TOLERANCE) break;
      nodes.add([]);
      for (int column = 0;; column++) {
        double meanX = column * MEAN_NODE_DIST - OFFSCREEN_TOLERANCE;
        if (meanX > size.width + OFFSCREEN_TOLERANCE) break;

        double x = randomLikeNormal(_random, meanX, NODE_DIST_VARIANCE);
        double y = randomLikeNormal(_random, meanY, NODE_DIST_VARIANCE);
        Point position = new Point(x, y);
        Node newNode = reservedCenter.containsPoint(position) ? null : new Node(new Point(x, y), 'M');
        nodes[row].add(newNode);
      }
    }
    return nodes;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('paint');
    _random = new Random(0x3C9B9A8A6);
    List<List<Node>> nodes = _generateNodes(size);

    var rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      new Paint()..color = const Color(BACKGROUND_COLOR),
    );
    for (int row = 0; row < nodes.length; row++) {
      for (int column = 0; column < nodes[row].length; column++) {
        Node node = nodes[row][column];
        if (node != null) {
          _drawNode(canvas, node);
          _drawConnectingLines(canvas, nodes, row, column);
        }
      }
    }
  }

  void _drawNode(Canvas canvas, Node node) {
//    canvas.drawCircle(new Offset(node.x, node.y), nodeRadius, new Paint());

    TextSpan span = new TextSpan(text: node.text, style: new TextStyle(color: const Color(TEXT_COLOR)));
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.rtl);
    tp.layout();
    tp.paint(canvas, new Offset(node.x - 6.0, node.y - 7.0));
  }

  void _drawConnectingLines(Canvas canvas, List<List<Node>> nodes, int row, int column) {
    Node current = nodes[row][column];
    Paint paint = new Paint()..color = const Color(LINES_COLOR);

    if (_random.nextDouble() < LINE_PROB && column + 1 < nodes[row].length) {
      Node right = nodes[row][column + 1];
      if (right != null)
        canvas.drawLine(
            new Offset(current.x + NODE_RADIUS, current.y), new Offset(right.x - NODE_RADIUS, right.y), paint);
    }
    if (_random.nextDouble() < LINE_PROB && row + 1 < nodes.length && column + 1 < nodes[row + 1].length) {
      Node diagonal = nodes[row + 1][column + 1];
      if (diagonal != null)
        canvas.drawLine(new Offset(current.x + NODE_RADIUS * sqrt2 / 2, current.y + NODE_RADIUS * sqrt2 / 2),
            new Offset(diagonal.x - NODE_RADIUS * sqrt2 / 2, diagonal.y - NODE_RADIUS * sqrt2 / 2), paint);
    }
    if (_random.nextDouble() < LINE_PROB && row + 1 < nodes.length) {
      Node bottom = nodes[row + 1][column];
      if (bottom != null)
        canvas.drawLine(
            new Offset(current.x, current.y + NODE_RADIUS), new Offset(bottom.x, bottom.y - NODE_RADIUS), paint);
    }
  }

  Rectangle _getReservedRectangle(Size size) {
    Point topLeft = new Point(size.width * _areaToPaint.left, size.height * _areaToPaint.top);
    Point bottomRight = new Point(size.width * (1 - _areaToPaint.right), size.height * (1 - _areaToPaint.bottom));
    return new Rectangle.fromPoints(topLeft, bottomRight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Node {
  Point position;
  String text;

  Node(this.position, this.text);

  double get x => position.x;

  double get y => position.y;
}
