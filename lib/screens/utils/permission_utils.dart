import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xln2026/services/navigationservices.dart';

class PermissionUtils {
  static Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
  // ignore_for_file: unused_element

  ///
  ///
  ///Get Android Version
  ///

  /// Retrieves the Android SDK version of the device.
  ///
  /// This function checks if the current platform is Android. If it is,
  /// it uses the `DeviceInfoPlugin` to obtain the Android device information
  /// and returns the SDK version as an integer.
  ///
  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // platFormVersion = androidInfo.version.sdkInt;
      debugPrint('versionSdk: ${androidInfo.version.sdkInt}');
      return androidInfo.version.sdkInt;
    }
    throw UnsupportedError("Platform is not Android");
  }

  static int intent = 0;

  /// Requests a specific permission from the user.
  ///
  /// This function checks the platform version and requests the appropriate
  /// permission based on the provided `permissionName` or `imageSource`.
  /// It handles different permissions such as camera, gallery, notifications,
  /// messages, and phone access.
  ///
  /// If a dialog is open, it will be closed before proceeding with the permission request.
  ///
  /// Parameters:
  /// - [context]: The build context to use for displaying dialogs.
  /// - [permissionName]: The name of the permission to request.
  /// - [imageSource]: (Optional) The source of the image, used to determine the permission type.
  /// - [onCancel]: (Optional) Callback function to execute if the permission request is canceled.
  ///  if not passed it will navigate to first route.
  /// - [onGranted]: Callback function to execute if the permission is granted.
  /// - [onForegroundGained]: (Optional) Callback function to execute if the app gains foreground access.
  /// - [permission]: (Optional) Specific permission to request, overrides `permissionName` and `imageSource`.
  ///
  /// Throws:
  /// - An error if the platform is not supported.
  static Future<void> getPermission(
    BuildContext context,
    String permissionName, {
    ImageSource? imageSource,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
    Permission? permission,
    bool? isDissmissable,
  }) async {
    late final int platFormVersion;
    if (Platform.isAndroid) {
      platFormVersion = await getAndroidVersion();
    }
    Get.isDialogOpen ?? false ? Get.back() : null;

    final permissionMap = {
      ImageSource.camera: {
        'permission': Permission.camera,
        'icon': CupertinoIcons.camera,
        'name': 'camera',
      },
      ImageSource.gallery: {
        'permission': Platform.isAndroid
            ? platFormVersion >= 33
                  ? Permission.photos
                  : Permission.storage
            : Permission.photos,
        'icon': CupertinoIcons.photo,
        'name': 'photos',
      },
      'notification': {
        'permission': Permission.notification,
        'icon': CupertinoIcons.bell,
        'name': 'notification',
      },
      'message': {
        'permission': Permission.sms,
        'icon': CupertinoIcons.chat_bubble,
        'name': 'message',
      },
      'camera': {
        'permission': Permission.camera,
        'icon': CupertinoIcons.camera,
        'name': 'camera',
      },
      'photos': {
        'permission': Platform.isAndroid
            ? platFormVersion >= 33
                  ? Permission.photos
                  : Permission.storage
            : Permission.photos,
        'icon': CupertinoIcons.photo,
        'name': 'photos',
      },
      'storage': {
        'permission': Platform.isAndroid
            ? platFormVersion >= 33
                  ? Permission.photos
                  : Permission.storage
            : Permission.photos,
        'icon': CupertinoIcons.floppy_disk,
        'name': 'storage',
      },
      'phone': {
        'permission': Permission.phone,
        'icon': CupertinoIcons.phone,
        'name': 'phone',
      },
      // 'downlaod': {
      //   'permission': Permission.pho,
      //   'icon': CupertinoIcons.phone,
      //   'name': 'phone'
      // }
    };

    final permissionDetails =
        permissionMap[imageSource] ??
        permissionMap[permissionName] ??
        {
          'permission': '',
          'icon': CupertinoIcons.question,
          'name': permissionName,
        };

    await _checkAndRequestPermission(
      // imageSource,
      permissionDetails['permission'] as Permission,
      context,
      permissionDetails['icon'] as IconData,
      imageSource: imageSource,
      permissionDetails['name'] as String,
      onCancel: onCancel,
      onGranted: onGranted,
      onForegroundGained: onForegroundGained,
      isDissmissable: isDissmissable,
    );
  }

  static Future<void> _checkAndRequestPermission(
    Permission permission,
    BuildContext context,
    IconData icon,
    String permissionName, {
    ImageSource? imageSource,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
    bool? isDissmissable,
  }) async {
    await _requestPermission(
      permission,
      permissionName,
      context,
      icon,
      imageSource: imageSource,
      onCancel: onCancel,
      onForegroundGained: onForegroundGained,
      onGranted: onGranted,
      isDissmissable: isDissmissable,
    );
  }

  /// Requests a specific permission from the user and handles the response.
  ///
  /// This function checks if the specified permission is already granted or limited
  /// (for Apple devices) and executes the `onGranted` callback if so. If the permission
  /// is not granted, it requests the permission and handles the response accordingly.
  /// If the permission is denied or permanently denied, it displays a dialog to the user
  /// with options to handle the denial.
  static Future<void> _requestPermission1(
    Permission permission,
    String permissionName,
    BuildContext context,
    IconData icon, {
    ImageSource? imageSource,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
    bool? isDissmissable,
  }) async {
    if (await permission.isGranted && context.mounted) {
      onGranted();
      return;
    } else if (Platform.isIOS &&
        permission == Permission.photos &&
        await permission.isLimited &&
        context.mounted) {
      onGranted();
      return;
      //   }
      //   else if(Platform.isIOS&& await permission.isRestricted){
      // onGranted();
    } else {
      var result = await permission.request();
      intent++;
      if (result.isGranted && context.mounted) {
        onGranted();
        return;
      } else if (result.isPermanentlyDenied ||
          result.isDenied ||
          result.isRestricted) {
        if (Platform.isIOS) {
          Get.dialog(
            barrierDismissible: isDissmissable ?? false,
            showPermissionDialog(
              icon: icon,
              permissionType: permissionName,
              onCancel:
                  onCancel ??
                  () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
              onForegroundGained:
                  onForegroundGained ??
                  () {
                    debugPrint('brought up');
                    getPermission(
                      context,
                      permissionName,
                      onGranted: onGranted,
                      imageSource: imageSource,
                    );
                  },
            ),
          );
        } else {
          Get.dialog(
            barrierDismissible: isDissmissable ?? false,
            androidDialog(
              permissionName,
              // permissionType: permissionName,
              icon: icon,
              onCancel:
                  onCancel ??
                  () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
              onForegroundGained:
                  onForegroundGained ??
                  () {
                    debugPrint('brought up');
                    getPermission(
                      context,
                      permissionName,
                      onGranted: onGranted,
                      imageSource: imageSource,
                    );
                  },
            ),
          );
        }
      }
    }
  }

  ///
  static Future<void> _requestPermission(
    Permission permission,
    String permissionName,
    BuildContext context,
    IconData icon, {
    ImageSource? imageSource,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
    bool? isDissmissable,
  }) async {
    // Check if permission is granted
    if (await permission.isGranted && context.mounted) {
      onGranted();
      return;
    }

    // Handle iOS-specific scenarios
    if (Platform.isIOS) {
      // Handle Limited Access for Photos
      if (permission == Permission.photos &&
          await permission.isLimited &&
          context.mounted) {
        onGranted();
        return;
      }

      // Handle Restricted Access
      if (await permission.isRestricted && context.mounted) {
        Get.dialog(
          barrierDismissible: isDissmissable ?? false,
          _buildPermissionDialog(
            context: context,
            permissionName: permissionName,
            icon: icon,
            onCancel: onCancel,
            onGranted: onGranted,
            onForegroundGained: onForegroundGained,
            restrictedAccess: true,
          ),
        );
        return;
      }
    }

    // Request permission
    var result = await permission.request();

    if (result.isGranted && context.mounted) {
      onGranted();
    } else if ((result.isPermanentlyDenied || result.isDenied)) {
      // Show a dialog to explain permission or guide to settings
      Get.dialog(
        barrierDismissible: isDissmissable ?? false,
        _buildPermissionDialog(
          context: NavigationService.navigatorKey.currentContext!,
          permissionName: permissionName,
          icon: icon,
          onCancel: onCancel,
          onGranted: onGranted,
          onForegroundGained: onForegroundGained,
        ),
      );
    }
  }

  // Apple-specific permission dialog
  static Widget _buildPermissionDialog({
    required BuildContext context,
    required String permissionName,
    required IconData icon,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
    bool restrictedAccess = false,
  }) {
    return showPermissionDialog(
      icon: icon,
      content: restrictedAccess
          ? '$permissionName access is restricted. You need to update this in app Settings.'
          : null,
      permissionType: permissionName,
      onCancel:
          onCancel ??
          () {
            try {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } catch (e) {
              Get.back();
            }
          },
      onForegroundGained:
          onForegroundGained ??
          () {
            // debugPrint('Permission regained for iOS');
            getPermission(context, permissionName, onGranted: onGranted);
          },
    );
  }

  // Android-specific permission dialog
  static Widget _buildAndroidPermissionDialog({
    required BuildContext context,
    required String permissionName,
    required IconData icon,
    VoidCallback? onCancel,
    required VoidCallback onGranted,
    VoidCallback? onForegroundGained,
  }) {
    return androidDialog(
      permissionName,
      icon: icon,
      onCancel:
          onCancel ??
          () => Navigator.of(context).popUntil((route) => route.isFirst),
      onForegroundGained:
          onForegroundGained ??
          () {
            // debugPrint('Permission regained for Android');
            getPermission(context, permissionName, onGranted: onGranted);
          },
    );
  }

  static Widget showPermissionDialog({
    String? title,
    String? content,
    IconData? icon,
    Color? iconColor,
    String? permissionType,
    required dynamic Function() onCancel,
    void Function()? onForegroundGained,
    AppSettingsType? type,
  }) {
    return AlertDialog(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: iconColor ?? Colors.black),
            const SizedBox(width: 10),
            Text(
              title ?? "Permission Required",
              // style: Properties.textsStyles.text18_700,
            ),
          ],
        ),
      ),
      content: Text(
        content ??
            "${permissionType ?? ''} permission is required to use this feature. you can grant in app settings",
        style: const TextStyle(fontSize: 18),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: [
        ElevatedButton(
          // width: Get.width * 0.8,
          // backgrounColor: Colors.grey.shade300,
          onPressed: onCancel,
          child: const Text('cancel', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 20, height: 10),
        ElevatedButton(
          // style: ButtonStyle(
          // width: Get.width * 0.8,
          // backgrounColor: Properties.themeColor.darkBlue1,
          onPressed: () async {
            await AppSettings.openAppSettings(
              type: type ?? AppSettingsType.settings,
            );
          },
          child: const Text(
            'Open settings',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(
          // width: 10,
          height: 10,
        ),
      ],
    );
  }

  static Widget androidDialog(
    String permissionType, {
    AppSettingsType? type,
    required dynamic Function() onCancel,
    String? title,
    String? content,
    IconData? icon,
    Color? iconColor,
    void Function()? onForegroundGained,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      title: Row(
        children: [
          if (icon != null) Icon(icon, color: iconColor ?? Colors.black),
          const SizedBox(width: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Permission Required',
              // style: Properties.textsStyles.text16_700,
              softWrap: false,
            ),
          ),
        ],
      ),
      // titleTextStyle: titleStyle.copyWith(color: Colors.black),
      content: Text(
        content ??
            '$permissionType permission is required to use this feature. you can grant in app settings.',
      ),
      // contentTextStyle: contentStyle.copyWith(color: Colors.black),
      actions: [
        ElevatedButton(
          // onTap: onCancel,
          // width: 100,
          // backgrounColor: Colors.grey,
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await AppSettings.openAppSettings(
              type: type ?? AppSettingsType.settings,
            );
          },
          // width: 160,
          // backgrounColor: Properties.themeColor.darkBlue1,
          child: const Text(
            'open settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  //   final titleStyle = GoogleFonts.roboto(
  //   color: Colors.black,
  //   fontSize: 20,
  //   fontWeight: FontWeight.w500,
  // );
  // final contentStyle = GoogleFonts.poppins(
  //     // color: Properties.themeColor.primaryColor,
  //     fontSize: 18,
  //     textStyle: const TextStyle(color: Colors.black)
  //     // fontWeight: FontWeight.w400,
  //     );
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'name': build.name,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'freeDiskSize': build.freeDiskSize,
      'totalDiskSize': build.totalDiskSize,
      'systemFeatures': build.systemFeatures,
      'isLowRamDevice': build.isLowRamDevice,
      'physicalRamSize': build.physicalRamSize,
      'availableRamSize': build.availableRamSize,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'modelName': data.modelName,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'isiOSAppOnMac': data.isiOSAppOnMac,
      'freeDiskSize': data.freeDiskSize,
      'totalDiskSize': data.totalDiskSize,
      'physicalRamSize': data.physicalRamSize,
      'availableRamSize': data.availableRamSize,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
