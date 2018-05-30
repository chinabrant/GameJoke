import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/rendering.dart';

typedef void ImageEditCallback(ui.Image image);

class ImageEditPage extends StatefulWidget {
  ImageProvider image;

  ImageEditCallback resultCallback;

  ImageEditPage({this.image, this.resultCallback});

  @override
  State<StatefulWidget> createState() {
    return ImageEditPageState();
  }
}

class ImageEditPageState extends State<ImageEditPage> {
  GlobalKey globalKey = new GlobalKey();

  /// 从两个手指开始缩放到停止缩放为一次缩放
  ///
  ///
  double scale = 1.0;
  double _previousScale = 1.0; // 记录上一次缩放的被数

  Offset _offset = Offset.zero;
  Offset _previousOffset;

  Offset _startFocalPoint;

  ui.Image _image;
  ImageInfo _imageInfo;
  ImageStream _imageStream;
  // Widget resultWidget;
  ui.Image _resultImage;

  @override
  void initState() {
    super.initState();
  }

  void showMessage(BuildContext context, Widget child) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Dialog(child: child),
    );

    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }

  Future<ui.Image> _toImage() async {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    double x = (mediaQueryData.size.width - 300.0) / 2.0;
    double y = (mediaQueryData.size.height - 300.0) / 2.0;
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image resultImage =
        await boundary.layer.toImage(Rect.fromLTWH(-x, -y, 300.0, 300.0));
        _resultImage = resultImage;

    return _resultImage;
  }

  void _showImage() async {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    double x = (mediaQueryData.size.width - 300.0) / 2.0;
    double y = (mediaQueryData.size.height - 300.0) / 2.0;
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image resultImage =
        await boundary.layer.toImage(Rect.fromLTWH(-x, -y, 300.0, 300.0));


        showMessage(
        context,
        RawImage(
          image: resultImage,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget paint = RepaintBoundary(
        key: globalKey,
        child: CustomPaint(
          child: Container(
            color: Color(0xfff7f7f7),
          ),
          foregroundPainter: ZoomableImage(scale: this.scale, image: _image, offset: this._offset),
        ));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    Widget toolBar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 返回
        Container(
          margin: EdgeInsets.only(left: 15.0, top: mediaQueryData.padding.top),
          height: 44.0,
          width: 44.0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
              child: Center(
            child: Icon(
              Icons.arrow_back,
              color: Colors.brown,
            ),
          )),
        ),
        Expanded(
          flex: 1,
          child: Text(''),
        ),
        Container(
          color: Colors.brown,
          height: 50.0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _showImage();
                  },
                  child: Center(
                    child: Text(
                      '预览',
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    _toImage().then((image) {
                    //   if (widget.resultCallback != null) {
                    //   widget.resultCallback(image);
                    // }

                    Navigator.of(context).pop(image);
                  });
                    
                  },
                  child: Center(
                    child: Text('确定',
                        style: TextStyle(color: Colors.white, fontSize: 17.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: Stack(
        children: <Widget>[
          paint,
          // 框框
          Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            ),
          ),
          toolBar,
        ],
      ),
    );
  }

  // 开始缩放
  void _onScaleStart(ScaleStartDetails details) {
    _previousScale = scale;
    _startFocalPoint = details.focalPoint;
    _previousOffset = _offset;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    double newScale = _previousScale * details.scale;

    final Offset normalizedOffset =
        (_startFocalPoint - _previousOffset) / _previousScale;
    final Offset newOffset = details.focalPoint - normalizedOffset * newScale;


    setState(() {
      this.scale = newScale;
      this._offset = newOffset;
    });
  }

  void _getImage() {
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    _imageStream.addListener(_handleImageLoaded);
  }

  void _handleImageLoaded(ImageInfo info, bool synchronousCall) {
    setState(() {
      _image = info.image;
    });
  }

  @override
  void didChangeDependencies() {
    _getImage();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _getImage(); // in case the image cache was flushed
    super.reassemble();
  }

  @override
  void dispose() {
    _imageStream.removeListener(_handleImageLoaded);
    super.dispose();
  }
}

class ZoomableImage extends CustomPainter {
  ui.Image image;
  final double scale;
  final Offset offset;

  ZoomableImage({this.image, this.scale, this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      Size realSize = Size(image.width.toDouble(), image.height.toDouble());
      Size targetSize = realSize * scale;

      paintImage(
          canvas: canvas,
          rect: offset & targetSize, // Rect.fromLTWH(0.0, 0.0, 80.0, 80.0),
          image: image,
          fit: BoxFit.fill);
    }
  }

  @override
  bool shouldRepaint(ZoomableImage oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset;
  }
}

