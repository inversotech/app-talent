import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/justification/schedule_worker.dart';
import 'package:intl/intl.dart';

class ScheduleWorkerPage extends StatelessWidget {
  final ScheduleWorkerModel scheduleData;
  final String title;
  ScheduleWorkerPage(
      {Key? key, this.title = 'Mi horario', required this.scheduleData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Entrada:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(DateFormat('d/M/y hh:mm a')
                  .format(
                      DateTime.parse(scheduleData.fechahoraEntrada.toString()))
                  .toLowerCase()),
              SizedBox(height: 8),
              scheduleData.fechahoraSalidaRef != null
                  ? Column(
                      children: [
                        Text(
                          'Salida al refrigerio:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(DateFormat('d/M/y hh:mm a')
                            .format(DateTime.parse(
                                scheduleData.fechahoraSalidaRef.toString()))
                            .toLowerCase())
                      ],
                    )
                  : Container(),
              SizedBox(height: 8),
              scheduleData.fechahoraEntradaRef != null
                  ? Column(
                      children: [
                        Text(
                          'Regreso del refrigerio:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(DateFormat('d/M/y hh:mm a')
                            .format(DateTime.parse(
                                scheduleData.fechahoraEntradaRef.toString()))
                            .toLowerCase()),
                      ],
                    )
                  : Container(),
              SizedBox(height: 8),
              Text(
                'Salida:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(DateFormat('d/M/y hh:mm a')
                  .format(
                      DateTime.parse(scheduleData.fechahoraSalida.toString()))
                  .toLowerCase()),
              SizedBox(height: 8),
            ],
          ),
        ));
  }
}
