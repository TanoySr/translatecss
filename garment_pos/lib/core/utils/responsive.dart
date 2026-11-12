import 'package:flutter/widgets.dart';

/// Device classes used by every screen in Garment POS.
///
/// - [DeviceClass.mobile]: single column layout (Android phones)
/// - [DeviceClass.tablet]: two/three panel layout (Android tablets)
/// - [DeviceClass.desktop]: multi-panel layout (Windows desktop)
enum DeviceClass { mobile, tablet, desktop }

/// Breakpoints (logical pixels) for [DeviceClass].
class AppBreakpoints {
  const AppBreakpoints._();

  /// Width below which a device is treated as a phone.
  static const double tabletMinWidth = 600;

  /// Width below which a device is treated as a tablet.
  static const double desktopMinWidth = 1024;
}

/// Returns the [DeviceClass] for a window [width]. Pure function so it
/// can be unit-tested without a widget tree.
DeviceClass deviceClassForWidth(double width) {
  if (width < AppBreakpoints.tabletMinWidth) return DeviceClass.mobile;
  if (width < AppBreakpoints.desktopMinWidth) return DeviceClass.tablet;
  return DeviceClass.desktop;
}

/// Convenience accessors on [BuildContext].
extension ResponsiveContext on BuildContext {
  DeviceClass get deviceClass =>
      deviceClassForWidth(MediaQuery.sizeOf(this).width);

  bool get isMobile => deviceClass == DeviceClass.mobile;
  bool get isTablet => deviceClass == DeviceClass.tablet;
  bool get isDesktop => deviceClass == DeviceClass.desktop;

  /// True for tablet and desktop (wide layouts with side panels).
  bool get isWide => !isMobile;
}

/// Builds one of up to three layouts depending on the window width.
///
/// [mobile] is required; [tablet] falls back to [mobile] and [desktop]
/// falls back to [tablet] (or [mobile]) when not provided.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return switch (context.deviceClass) {
      DeviceClass.mobile => mobile(context),
      DeviceClass.tablet => (tablet ?? mobile)(context),
      DeviceClass.desktop => (desktop ?? tablet ?? mobile)(context),
    };
  }
}
