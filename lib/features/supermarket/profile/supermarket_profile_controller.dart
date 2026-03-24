import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_link.dart';
import '../../auth/auth_controller.dart';

class SupermarketProfileController extends GetxController {
  final AuthController authController = Get.find();

  var isEdit = false.obs;
  Rxn<Uint8List> imageBytes = Rxn<Uint8List>();
  String? imageName;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameArController = TextEditingController();
  final locationController = TextEditingController();
  final timeOpenController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  var imageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  // تحميل البيانات الأصلية من الـ AuthController
  void _loadUser() {
    final user = authController.currentUser.value;
    if (user == null) return;

    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email;
    nameArController.text = user.nameAr ?? "";
    locationController.text = user.location ?? "";
    timeOpenController.text = user.timeOpen ?? "";
    latController.text = user.lat?.toString() ?? "24.7136";
    lngController.text = user.lng?.toString() ?? "46.6753";

    if (user.image != null && user.image!.isNotEmpty) {
      imageUrl.value = "${AppLink.image}${user.image}";
    }
    imageBytes.value = null;
  }

  void toggleEdit() {
    if (isEdit.value) {
      _loadUser();
    }
    isEdit.value = !isEdit.value;
  }

  void openMapPicker(BuildContext context) async {
    if (!isEdit.value) return;

    double currentLat = double.tryParse(latController.text) ?? 24.7136;
    double currentLng = double.tryParse(lngController.text) ?? 46.6753;

    LatLng? pickedLocation = await showGeneralDialog<LatLng>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Map",
      pageBuilder: (context, anim1, anim2) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.width > 800 ? 0.5 : 0.9),
          height: MediaQuery.of(context).size.height * 0.7,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: MapPickerWidget(initialLocation: LatLng(currentLat, currentLng)),
        ),
      ),
    );

    if (pickedLocation != null) {
      latController.text = pickedLocation.latitude.toString();
      lngController.text = pickedLocation.longitude.toString();
      update();
    }
  }

  Future<void> saveProfile() async {
    final user = authController.currentUser.value;
    if (user == null) return;

    bool isChanged =
        nameController.text != user.name ||
            nameArController.text != (user.nameAr ?? "") ||
            emailController.text != user.email ||
            phoneController.text != user.phone ||
            locationController.text != (user.location ?? "") ||
            timeOpenController.text != (user.timeOpen ?? "") ||
            latController.text != (user.lat?.toString() ?? "") ||
            lngController.text != (user.lng?.toString() ?? "") ||
            imageBytes.value != null;

    if (!isChanged) {
      isEdit.value = false;
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator(color: Colors.green)), barrierDismissible: false);

      var request = http.MultipartRequest("POST", Uri.parse(AppLink.updateSupermarketProfile));
      request.fields["id"] = user.id.toString();
      request.fields["name"] = nameController.text;
      request.fields["name_ar"] = nameArController.text;
      request.fields["email"] = emailController.text;
      request.fields["phone"] = phoneController.text;
      request.fields["location"] = locationController.text;
      request.fields["time_open"] = timeOpenController.text;
      request.fields["lat"] = latController.text;
      request.fields["lng"] = lngController.text;

      if (imageBytes.value != null) {
        request.files.add(http.MultipartFile.fromBytes("image", imageBytes.value!, filename: imageName));
      }

      var response = await request.send();
      Get.back();

      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (data["status"] == "success") {
        Get.snackbar("نجاح", "تم تحديث البيانات بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        isEdit.value = false;
        // ملاحظة: يفضل هنا تحديث بيانات الـ User في AuthController ببيانات الرد الجديدة
      } else {
        Get.snackbar("تنبيه", data["message"] ?? "حدث خطأ ما", backgroundColor: Colors.orange);
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      Get.snackbar("خطأ", "حدث خطأ أثناء الحفظ", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      imageBytes.value = result.files.single.bytes;
      imageName = result.files.single.name;
    }
  }
}

class MapPickerWidget extends StatefulWidget {
  final LatLng initialLocation;
  const MapPickerWidget({super.key, required this.initialLocation});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  late LatLng _currentPosition;
  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اسحب الخريطة لتحديد الموقع", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _currentPosition),
            child: const Text("تأكيد", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 15),
        onTap: (pos) => setState(() => _currentPosition = pos),
        onCameraMove: (pos) => _currentPosition = pos.target,
        markers: { Marker(markerId: const MarkerId("1"), position: _currentPosition) },
      ),
    );
  }
}