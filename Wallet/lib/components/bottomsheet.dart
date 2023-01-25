import 'package:flutter/material.dart';

showSheet(context){
  showModalBottomSheet(
      context: context,
      builder: (builder){
        return  Container(
          height: 50.0,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(
                      topLeft:  Radius.circular(10.0),
                      topRight:  Radius.circular(10.0))),
              child:const  Center(
                child:  Text("Successfully created"),
              )),
        );
      }
  );
}


