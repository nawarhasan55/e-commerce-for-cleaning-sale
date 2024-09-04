import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/components/textformfieldadd.dart';
import 'package:untitled2/home_page.dart';
import '../components/custombuttonupload.dart';

class EditCategories extends StatefulWidget {
  final String docId;

  final String oldName;

  EditCategories({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  TextEditingController name = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

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

  bool isLoading = false;

  Future<void> editCategory() async {
    // Call the category's CollectionReference to update a new category
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      Get.offAll(() => HomePage());
      return await categories
          .doc(widget.docId)
          .update({"name": name.text, "url": "${myUrlCamera}"})
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
    name.text = widget.oldName;
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
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
                        hinttext: "Enter name",
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be empty";
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
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
                            editCategory();
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
