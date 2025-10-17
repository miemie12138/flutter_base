import 'dart:async';
import 'dart:developer';

import 'dart:ui';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/liberary.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyLoading {
  MyLoading._();

  static late BuildContext _context;
  static late String _lodingLottieAssetPath;

  static init(BuildContext context, String lottieAssetPath) {
    _context = context;
    _lodingLottieAssetPath = lottieAssetPath;
  }

  static OverlayEntry? _entry;
  static MyLoadingWidgetController? _controller;
  static Timer? _timer;
  static bool _handling = false;

  /// 显示loading
  static show({
    String? msg,
    bool barrier = false,
    bool cancelOnTouchOutside = false,
    Duration? timeout = const Duration(seconds: 30),
  }) {
    if (_handling) return;
    _handling = true;

    _controller ??= MyLoadingWidgetController(
      message: msg ?? '',
      barrier: barrier,
      cancelOnTouchOutside: cancelOnTouchOutside,
      lodingLottieAssetPath: _lodingLottieAssetPath,
    );
    _controller?.message = msg ?? '';
    _controller?.barrier = barrier;
    _controller?.cancelOnTouchOutside = cancelOnTouchOutside;

    if (_entry == null) {
      _entry = OverlayEntry(builder: (BuildContext context) {
        return MyLoadingWidget(controller: _controller, hide: hide);
      });

      try {
        Overlay.of(_context).insert(_entry!);
      } catch (e, stack) {
        log('$e', error: e, stackTrace: stack);
        _entry = null;
      }
    } else {
      _controller!.update(msg ?? '', barrier, cancelOnTouchOutside);
    }

    if (null != timeout && timeout.inSeconds > 0) {
      _timer?.cancel();
      _timer = Timer(timeout, hide);
    }

    _handling = false;
  }

  /// 隐藏loading
  static hide() {
    try {
      _controller?.update('', false, false);
      _timer?.cancel();
      _entry?.remove();
    } finally {
      _timer = null;
      _entry = null;
    }
  }
}

class MyLoadingWidgetController extends ChangeNotifier {
  String message;
  bool barrier;
  bool cancelOnTouchOutside = false;
  String? lodingLottieAssetPath;

  MyLoadingWidgetController({
    this.message = '',
    this.barrier = false,
    this.cancelOnTouchOutside = false,
    this.lodingLottieAssetPath,
  });

  void update(String message, bool barrier, bool cancelOnTouchOutside) {
    this.message = message;
    this.barrier = barrier;
    this.cancelOnTouchOutside = cancelOnTouchOutside;
    notifyListeners();
  }
}

class MyLoadingWidget extends StatefulWidget {
  final String message;
  final bool barrier;
  final bool cancelOnTouchOutside;
  final MyLoadingWidgetController? controller;
  final Function()? hide;
  const MyLoadingWidget({
    super.key,
    this.message = "",
    this.barrier = false,
    this.cancelOnTouchOutside = false,
    this.controller,
    this.hide,
  });

  @override
  State<MyLoadingWidget> createState() => _MyLoadingWidgetState();
}

class _MyLoadingWidgetState extends State<MyLoadingWidget> {
  late final MyLoadingWidgetController _controller;

  double opacity = 0;
  @override
  void initState() {
    _controller = widget.controller ??
        MyLoadingWidgetController(
          message: widget.message,
          barrier: widget.barrier,
          cancelOnTouchOutside: widget.cancelOnTouchOutside,
        );

    Future.microtask(() {
      opacity = 1;
      setState(() {});
    });
    super.initState();
    BackButtonInterceptor.add(_backButtonInterceptor, zIndex: 1000, name: "Loading");
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("Loading");
    super.dispose();
  }

  bool _backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo routeInfo) {
    if (!_controller.barrier) {
      widget.hide?.call();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: opacity,
      child: ChangeNotifierProvider.value(
          value: _controller,
          builder: (context, _) {
            final controller = Provider.of<MyLoadingWidgetController>(context, listen: true);
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (controller.cancelOnTouchOutside) {
                  widget.hide?.call();
                }
              },
              child: Container(
                alignment: Alignment.center,
                color: controller.barrier ? const Color(0x66000000) : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: BackdropFilter(
                    // filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          // color: const Color(0XC1000000),
                          color: Colors.transparent,
                          borderRadius: (BorderRadius.circular(9)),
                          //border: Border.all(width: 0.5, color: Colors.black87),
                          border: Border.all(width: 0.5, color: Colors.transparent)),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: (BorderRadius.circular(9)),
                          // border: Border.all(width: 1, color: Colors.white12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              // child: SizedBox(width: 32, height: 32, child: FlowerLoadingIndicator()),
                              //child: FlowerLoadingIndicator(),
                              child: controller.lodingLottieAssetPath != null
                                  ? SizedBox(
                                      width: 80,
                                      height: 40,
                                      child: Lottie.asset(
                                        controller.lodingLottieAssetPath!,
                                      ),
                                    )
                                  : const FlowerLoadingIndicator(),
                            ),
                            if (controller.message.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text(
                                  controller.message,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xffdfdfdf),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
