import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = "camera";
  static const routeUrl = "/camera";

  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late TabController _tabController;
  late FlashMode _flashMode;

  bool _hasPermission = false;
  bool _isSelfieMode = false;

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.veryHigh,
    );

    await _cameraController.initialize();
    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> _initPermissions() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    if (cameraPermission.isDenied) {
      cameraPermission = await Permission.camera.request();
    }
    if (!cameraPermission.isDenied && !cameraPermission.isPermanentlyDenied) {
      _hasPermission = true;
      await _initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initPermissions();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        if (_hasPermission && !_cameraController.value.isInitialized) {
          _initCamera();
        }
      }
    });
  }

  void _toggleSelfieMode() {
    _isSelfieMode = !_isSelfieMode;
    _initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode flashMode) async {
    var flashModes = [
      FlashMode.auto,
      FlashMode.always,
      FlashMode.torch,
      FlashMode.off,
    ];

    var flashModeIndex = flashModes.indexOf(flashMode);
    FlashMode newFlashMode =
        flashModes[flashModeIndex == 3 ? 0 : flashModeIndex + 1];

    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_cameraController.value.isTakingPicture || !mounted) return;

    final picture = await _cameraController.takePicture();

    if (!mounted) return;
    Navigator.pop(context, picture);
  }

  Future<void> _openGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    Navigator.pop(context, picture);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onPopPressed() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: _hasPermission && _cameraController.value.isInitialized
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: CameraPreview(_cameraController),
                      ),
                      Positioned(
                        top: Sizes.d60,
                        left: Sizes.d24,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _onPopPressed,
                          icon: FaIcon(FontAwesomeIcons.chevronLeft),
                        ),
                      ),
                      Positioned(
                        bottom: Sizes.d40,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: IconButton(
                                  onPressed: () => _setFlashMode(_flashMode),
                                  icon: Icon(
                                    _flashMode == FlashMode.auto
                                        ? Icons.flash_auto_rounded
                                        : _flashMode == FlashMode.always
                                            ? Icons.flash_on_rounded
                                            : _flashMode == FlashMode.torch
                                                ? Icons.flashlight_on_rounded
                                                : Icons.flash_off_rounded,
                                    color: Colors.white,
                                    size: Sizes.d24,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                width: Sizes.d60,
                                height: Sizes.d60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: IconButton(
                                  onPressed: _toggleSelfieMode,
                                  icon: Icon(
                                    Icons.cameraswitch_rounded,
                                    color: Colors.white,
                                    size: Sizes.d24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator.adaptive(),
          ),
          Builder(
            builder: (context) {
              Future.microtask(() => _openGallery());
              return Container(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Camera"), Tab(text: "Library")],
        ),
      ),
    );
  }
}
