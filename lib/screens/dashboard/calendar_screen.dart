import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, 
            color: isDarkMode ? Colors.white : Colors.black
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calendar',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              firstDayOfWeek: 1,
              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                agendaStyle: AgendaStyle(
                  backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  appointmentTextStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                  dateTextStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                  dayTextStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              headerStyle: CalendarHeaderStyle(
                textStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              todayHighlightColor: Colors.black,
              selectionDecoration: BoxDecoration(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                border: Border.all(
                  color: isDarkMode ? Colors.white38 : Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              dataSource: _getCalendarDataSource(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add event modal
        },
        backgroundColor: isDarkMode ? Colors.white : Colors.black,
        child: Icon(
          Icons.add,
          color: isDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        subject: 'Team Meeting',
        color: Colors.blue,
      ),
    );
    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
