import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/components/textformfieldadd.dart';
import 'package:untitled2/home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../components/custombuttonupload.dart';

class EditGoods extends StatefulWidget {
  final String goodsId;
  final String categoriesId;
  final String oldName;
  final String oldPrice;
  final String oldDetails;

  EditGoods(
      {super.key,
      required this.goodsId,
      required this.categoriesId,
      required this.oldName,
      required this.oldPrice,
      required this.oldDetails});

  @override
  State<EditGoods> createState() => _EditGoodsState();
}

class _EditGoodsState extends State<EditGoods> {
  TextEditingController goods = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController details = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey();

  bool isLoading = false;

  bool isLoadingImage = false;

  // variables for camera
  final ImagePicker _pickerCamera = ImagePicker();
  XFile? _imageCamera;
  File? fileCamera;

  var myUrlCamera;

  //variable for gallery
  final ImagePicker _pickerGallery = ImagePicker();
  XFile? _imageGallery;
  File? fileGallery;

  //function for get image from camera
  Future<String> _pickImageCamera() async {
    try {
      _imageCamera = await _pickerCamera.pickImage(source: ImageSource.camera);
      isLoadingImage = true;
      setState(() {});
      var imageName = basename(_imageCamera!.path);
      print("name================ $imageName");
      fileCamera = await File(_imageCamera!.path);
      print("name================ ${fileCamera!.path}");
      var refStorage = FirebaseStorage.instance.ref(imageName);
      await refStorage.putFile(fileCamera!);
      myUrlCamera = await refStorage.getDownloadURL();
      setState(() {});
    } on PlatformException catch (e) {
      print('===============Error: $e');
    }
    isLoadingImage = false;
    setState(() {});
    return myUrlCamera;
  }

  //function for get image from gallery
  Future<String> _pickImageGallery() async {
    try {
      _imageGallery =
          await _pickerGallery.pickImage(source: ImageSource.gallery);
      isLoadingImage = true;
      setState(() {});
      var imageName = basename(_imageGallery!.path);
      print("name================ $imageName");
      fileGallery = File(_imageGallery!.path);
      print("name================ ${fileGallery!.path}");
      var refStorage = FirebaseStorage.instance.ref(imageName);
      await refStorage.putFile(fileGallery!);
      myUrlCamera = await refStorage.getDownloadURL();

      setState(() {});
    } on PlatformException catch (e) {
      print('===============Error: $e');
    }
    isLoadingImage = false;
    setState(() {});
    return myUrlCamera;
  }

  Future<void> editGoods() async {
    // Call the user's CollectionReference to add a new user
    CollectionReference collectiongoods = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoriesId)
        .collection("goods");
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      Get.off(() => HomePage());
      return await collectiongoods
          .doc(widget.goodsId)
          .update({
            "name": goods.text,
            "price": price.text,
            "details": details.text,
            "url": "${myUrlCamera}"
          })
          .then((value) => print("User Added"))
          .catchError((error) {
            print("Failed to add user: $error");
            isLoading = false;
            setState(() {});
          });
    }
  }

  @override
  void initState() {
    super.initState();
    goods.text = widget.oldName;
    price.text = widget.oldPrice;
    details.text = widget.oldDetails;
  }

  @override
  void dispose() {
    super.dispose();
    goods.dispose();
    price.dispose();
    details.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Goods"),
      ),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TestTextFormFieldAdd(
                        hinttext: "Enter Your Goods",
                        mycontroller: goods,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be empty";
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TestTextFormFieldAdd(
                        hinttext: "Enter Your Price",
                        mycontroller: price,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be empty";
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TestTextFormFieldAdd(
                        hinttext: "Enter Details",
                        mycontroller: details,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be empty";
                          }
                        }),
                  ),
                  isLoadingImage
                      ? CircularProgressIndicator()
                      : CustomBottonUpload(
                          title: 'Enter Image',
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.topSlide,
                              title: 'Choose Image',
                              btnCancelText: "Gallery",
                              btnOkText: "Camera",
                              desc: 'Choose the image you want from :',
                              btnOkOnPress: () async {
                                await _pickImageCamera();
                                setState(() {});
                              },
                              btnCancelOnPress: () async {
                                await _pickImageGallery();
                                setState(() {});
                              },
                            ).show();
                          },
                        ),
                  myUrlCamera == null
                      ? SizedBox()
                      : MaterialButton(
                          onPressed: () {
                            editGoods();
                          },
                          child: Text("Save"),
                          color: Colors.purple.shade200,
                        ),
                ],
              ),
      ),
    );
  }
}
