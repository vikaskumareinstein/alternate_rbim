import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Invitation extends StatefulWidget {
  @override
  _InvitationState createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(); // Controller for date field

  String? _selectedValue;
  final List<String> _dropdownItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Formatting date
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String feedback = _feedbackController.text;
      String expectedDate = _dateController.text;

      await FirebaseFirestore.instance.collection('feedback').add({
        'name': name,
        'email': email,
        'phone': phone,
        'feedback': feedback,
        'selected_option': _selectedValue,
        'expected_date': expectedDate, // Store the expected date
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );

      _formKey.currentState!.reset();
      _selectedValue = null;
      _dateController.clear(); // Clear date field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final phoneRegex = RegExp(r'^\d{10}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedValue,
                decoration: InputDecoration(
                  labelText: 'Select Option',
                  prefixIcon: Icon(Icons.list),
                ),
                items: _dropdownItems.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Expected Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Make it read-only to prevent manual input
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an expected date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  prefixIcon: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.feedback),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Invitation extends StatefulWidget {
//   @override
//   _InvitationState createState() => _InvitationState();
// }
//
// // address
// // church_name
// // church_website
// // city
// // country
// // cover_expense
// // email
// // event_type
// // expected_attendance
// // message_desc
// // mobile_phone
// // name
// // organized_event_desc
// // pincode
// // state
// // telephone
// // tentative_date
// // venue_capacity
//
// class _InvitationState extends State<Invitation> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _church_nameController = TextEditingController();
//   final TextEditingController _church_websiteController =
//       TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _cover_expenseController =
//       TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _event_typeController = TextEditingController();
//   final TextEditingController _expected_attendanceController =
//       TextEditingController();
//   final TextEditingController _message_descController = TextEditingController();
//   final TextEditingController _mobile_phoneController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _organized_event_descController =
//       TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _telephoneController = TextEditingController();
//   final TextEditingController _tentative_dateController =
//       TextEditingController();
//   final TextEditingController _venue_capacityController =
//       TextEditingController();
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       String address = _addressController.text;
//       String church_name = _church_nameController.text;
//       String church_website = _church_websiteController.text;
//       String city = _cityController.text;
//       String country = _countryController.text;
//       String cover_expense = _cover_expenseController.text;
//       String email = _emailController.text;
//       String event_type = _event_typeController.text;
//       String expected_attendance = _expected_attendanceController.text;
//       String message_desc = _message_descController.text;
//       String mobile_phone = _mobile_phoneController.text;
//       String name = _nameController.text;
//       String organized_event_desc = _organized_event_descController.text;
//       String pincode = _pincodeController.text;
//       String state = _stateController.text;
//       String telephone = _telephoneController.text;
//       String tentative_date = _tentative_dateController.text;
//       String venue_capacity = _venue_capacityController.text;
//
//       await FirebaseFirestore.instance.collection('feedback').add({
//         'address': address,
//         'church_name': church_name,
//         'church_website': church_website,
//         'city': city,
//         'country': country,
//         'cover_expense': cover_expense,
//         'email': email,
//         'event_type': event_type,
//         'expected_attendance': expected_attendance,
//         'message_desc': message_desc,
//         'mobile_phone': mobile_phone,
//         'name': name,
//         'organized_event_desc': organized_event_desc,
//         'pincode': pincode,
//         'state': state,
//         'telephone': telephone,
//         'tentative_date': tentative_date,
//         'venue_capacity': venue_capacity,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Feedback submitted successfully!')),
//       );
//
//       _formKey.currentState!.reset();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Feedback Form'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _feedbackController,
//                 decoration: InputDecoration(labelText: 'Feedback'),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your feedback';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
