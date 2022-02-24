import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';

class Comment extends StatelessWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          text: 'Ulices Julca Huancas',
                          style: GoogleFonts.montserrat(
                              color: ColorsApp.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Excelente fotografia. Esto es un comentario de prueba 1.',
                                style: GoogleFonts.montserrat(
                                    color: ColorsApp.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text('8h')
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          text: 'Ulices Julca Huancas',
                          style: GoogleFonts.montserrat(
                              color: ColorsApp.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Excelente fotografia. Esto es un comentario de prueba 2.',
                                style: GoogleFonts.montserrat(
                                    color: ColorsApp.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text('8h')
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    icon: Icon(Icons.person),
                    labelStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500, color: ColorsApp.primary),
                    labelText: 'Escribir comentario',
                    hintText: 'Escribir comentario...',
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.only(bottom: 12.0)),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500, color: ColorsApp.primary),
              ),
            ),
            Flexible(child: TextButton(onPressed: () {}, child: Text('Enviar')))
          ],
        ),
      ),
    );
  }
}
