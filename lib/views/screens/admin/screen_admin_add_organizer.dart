import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xlife/controllers/controller_admin_new_organizer.dart';
import 'package:xlife/widgets/custom_progress_widget.dart';

import '../../../helpers/styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_field.dart';

class ScreenAdminAddOrganizer extends StatelessWidget {
  ScreenAdminAddOrganizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Organizer"),
      ),
      body: SafeArea(
        child: GetBuilder<ControllerAdminNewOrganizer>(
          init: ControllerAdminNewOrganizer(),
          builder: (controller) {
            return CustomProgressWidget(
              loading: controller.showLoading,
              child: Form(
                key: controller.newOrganizerFormKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeading("Name", false),
                        CustomInputField(
                            hint: "Organizer name",
                            isPasswordField: false,
                            controller: controller.name_controller,
                            validator: (value) => controller.validateName(value.toString()),
                            keyboardType: TextInputType.emailAddress),
                        _buildHeading("Email Address", false),
                        CustomInputField(
                            hint: "organizer@test.com",
                            isPasswordField: false,
                            controller: controller.email_controller,
                            asyncValidator: (value) => controller.validateLoginEmail(value.toString()),
                            keyboardType: TextInputType.emailAddress),
                        _buildHeading("Password", false),
                        CustomInputField(
                            hint: "Password",
                            isPasswordField: false,
                            controller: controller.password_controller,
                            validator: (value) => controller.validatePassword(value.toString()),
                            keyboardType: TextInputType.text),
                        _buildHeading("Insert image", true),
                        GestureDetector(
                          child: Container(
                            width: Get.width * .3,
                            margin: EdgeInsets.all(5),
                            height: Get.height * 0.1,
                            child: controller.postImage.path != "" ? Container() : Icon(Icons.add),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                image: controller.postImage.path != ""
                                    ? DecorationImage(
                                        image: FileImage(File(controller.postImage.path)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                boxShadow: [BoxShadow(blurRadius: 2, offset: Offset(0, 1))]),
                          ),
                          onTap: () {
                            controller.pickImage();
                          },
                        ),
                        CustomButton(
                            text: "Add",
                            onPressed: () async {
                              String response = await controller.addOrganizer();
                              print(response);
                              controller.update();
                              if (response == "success") {
                                Get.back();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeading(String title, bool optional) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            title,
            style: (GetPlatform.isWeb ? normal_h2Style_bold_web : normal_h2Style_bold),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            optional ? "(optional)" : "*",
            style: (GetPlatform.isWeb ? normal_h2Style_bold_web : normal_h2Style_bold).copyWith(
              color: optional ? Colors.grey : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}