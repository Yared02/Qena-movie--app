import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qena_movie/common/Color.dart';

// import '../util/color/color.dart';

Widget passwordField(icon, lable, controller, obs, setState, isEmpty) {
  return TextField(
    controller: controller,
    obscureText: obs,
    decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        suffixIcon: IconButton(
            onPressed: () {
              setState();
            },
            icon: Icon(obs ? Icons.visibility : Icons.visibility_off)),
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(gapPadding: 5),
        focusColor: Colors.amberAccent,
        labelText: lable,
        errorText: isEmpty ? "Empty Field!" : null
        // errorText: validate ? 'Value Can\'t Be Empty' : null,
        ),
  );
}

Widget textField(icon, lable, controller, isEmpty) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      labelText: lable,
      errorText: isEmpty ? "Empty Field!" : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
    ),
  );
}

Widget submitButton(submit) {
  return InkWell(
    onTap: () {
      submit();
    },
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: CustomColors.testColor1,
          borderRadius: BorderRadius.circular(5)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

Widget dateField(context, icon, dateinput, label, isEmpty) {
  return TextField(
    controller: dateinput, //editing controller of this TextField
    decoration: InputDecoration(
        errorText: isEmpty ? "Empty Field!" : null,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon), //icon of text field
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4)),

    readOnly: true, //set it true, so that user will not able to edit text
    onTap: () async {
      var pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(
              2000), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));

      if (pickedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        dateinput.text = formattedDate; //set output date to TextField value.
      } else {
        print("Date is not selected");
      }
    },
  );
}
