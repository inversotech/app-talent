import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';

class YearMonthPicker extends StatefulWidget {
  final DateTime selectedDate;
  const YearMonthPicker({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  YearMonthPickerState createState() =>
      // ignore: no_logic_in_create_state
      YearMonthPickerState(selectedDate: selectedDate);
}

class YearMonthPickerState extends State<YearMonthPicker> {
  DateTime selectedDate;
  YearMonthPickerState({required this.selectedDate});
  PageController pageController = PageController();
  int displayedYear = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedDate.year);
    selectedDate = selectedDate;
    displayedYear = selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return yearMonthPicker();
  }

  Widget yearMonthPicker() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(builder: (context) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return IntrinsicWidth(
                child: Column(children: [
                  buildHeader(),
                  Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [buildPager()],
                    ),
                  )
                ]),
              );
            }
            return IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [buildPager()],
                      ),
                    )
                  ]),
            );
          }),
        ],
      );

  buildHeader() {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  capitalize(DateFormat.yMMMM('es').format(selectedDate)),
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(selectedDate);
                      },
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(DateFormat.y('es').format(DateTime(displayedYear)),
                    style: const TextStyle(color: Colors.white)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up,
                          color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear + 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPager() => Container(
        color: Colors.white,
        height: 210.0,
        width: 500.0,
        child: Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: const ButtonThemeData(
                    padding: EdgeInsets.all(0.0),
                    shape: CircleBorder(),
                    minWidth: 1.0)),
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  displayedYear = index;
                });
              },
              itemBuilder: (context, year) {
                return GridView.count(
                  padding: const EdgeInsets.all(12.0),
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 5,
                  children: List<int>.generate(12, (i) => i + 1)
                      .map((month) => DateTime(year, month))
                      .map(
                        (date) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextButton(
                            onPressed: () => setState(() {
                              selectedDate = DateTime(date.year, date.month);
                            }),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  date.month == selectedDate.month &&
                                          date.year == selectedDate.year
                                      ? ColorsApp.primary
                                      : null),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )),
                            ),
                            child: Text(
                              capitalize(DateFormat.MMM('es').format(date)),
                              style: TextStyle(
                                color: date.month == selectedDate.month &&
                                        date.year == selectedDate.year
                                    ? Colors.white
                                    : date.month == DateTime.now().month &&
                                            date.year == DateTime.now().year
                                        ? ColorsApp.primary
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )),
      );
}
