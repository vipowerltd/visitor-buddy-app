import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';
import 'package:visitor_power_buddy/resources/styles/textstyles.dart';

InputDecoration textFormStyle(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: formHintText,
    filled: true,
    fillColor: Colors.white,
    focusColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: fadedColour)
    )
  );
}

InputDecoration visitorSearchStyle(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: formHintText,
      suffixIcon: Icon(Icons.search, color: fadedColour,),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: fadedColour)
      )
  );
}

InputDecoration calendarForm() {
  return InputDecoration(
      hintText: 'Today',
      hintStyle: formHintText,
      suffixIcon: Icon(Icons.calendar_month, color: fadedColour,),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: fadedColour)
      )
  );
}

InputDecoration timeForm() {
  return InputDecoration(
      hintText: '12:00 AM',
      hintStyle: formHintText,
      suffixIcon: Icon(Icons.access_time_rounded, color: fadedColour,),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: fadedColour)
      )
  );
}

InputDecoration uploadForm() {
  return InputDecoration(
      hintText: 'Select an image to upload...',
      hintStyle: formHintText,
      suffixIcon: Icon(Icons.upload, color: fadedColour,),
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: fadedColour)
      )
  );
}