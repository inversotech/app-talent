import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String textHeader;
  final TextStyle? styleTextHeader;
  final String text;
  final int trimLines;
  final TextStyle style;
  final TextStyle? styleClickableText;
  final String trimCollapsedText;
  final String trimExpandedText;

  const ExpandableText(
      {Key? key,
      this.trimLines = 2,
      this.textHeader = '',
      this.styleTextHeader,
      required this.text,
      required this.style,
      this.styleClickableText,
      this.trimCollapsedText = '...más',
      this.trimExpandedText = ' menos'})
      : super(key: key);

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  String textAll = '';
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  void initState() {
    textAll = widget.textHeader + widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextSpan link = TextSpan(
        text: _readMore ? widget.trimCollapsedText : widget.trimExpandedText,
        style: widget.styleClickableText,
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.textHeader,
          style: widget.styleTextHeader,
          children: <TextSpan>[
            TextSpan(text: widget.text, style: widget.style)
          ],
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          maxLines: widget.trimLines,
          textDirection: TextDirection.rtl,
          ellipsis: '',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset)!;
        TextSpan textSpan;
        int indexHeader = widget.textHeader.length;
        if (endIndex > widget.text.length) {
          indexHeader = endIndex - widget.text.length;
          endIndex = widget.text.length;
        }
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.textHeader.substring(0, indexHeader)
                : widget.textHeader,
            style: widget.styleTextHeader,
            children: <TextSpan>[
              TextSpan(
                text: _readMore
                    ? widget.text.substring(0, endIndex)
                    : widget.text,
                style: widget.style,
                children: <TextSpan>[link],
              )
            ],
          );
        } else {
          textSpan = TextSpan(
            text: widget.textHeader,
            style: widget.styleTextHeader,
            children: <TextSpan>[
              TextSpan(text: widget.text, style: widget.style)
            ],
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
