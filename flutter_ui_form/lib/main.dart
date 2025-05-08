import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Flutter',
      home: Scaffold(
        appBar: AppBar(title: const Text('Coding Flutter')),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: MyForm(),
          ),
        ),
      ),
    );
  }
}

class MyForm extends StatelessWidget {
  const MyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        MyTextField(),
        SizedBox(height: 16),
        MyDropDown(),
        SizedBox(height: 16),
        MySwitch(),
        SizedBox(height: 16),
        MyRadio(),
        SizedBox(height: 16),
        MyCheckbox(),
        SizedBox(height: 16),
        MyDatePicker(),
        SizedBox(height: 16),
        MyDialog(),
        SizedBox(height: 16),
        MyBottomSheet(),
        SizedBox(height: 16),
        MySnackbarButton(),
        SizedBox(height: 16), // Extra space at the bottom
      ],
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 20,
      controller: textController,
      decoration: const InputDecoration(
        labelText: "Nama",
        labelStyle: TextStyle(color: Colors.blueGrey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        helperText: "Masukkan nama",
      ),
    );
  }
}

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String selected = "Dart";

  final List<String> dropDownList = const [
    "Dart",
    "Kotlin",
    "Java",
    "Javascript",
    "PHP",
    "Python",
    "Ruby",
    "Swift",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Bahasa favorit:"),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: selected,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 20,
          style: TextStyle(color: Colors.blue[600]),
          underline: Container(height: 2, color: Colors.grey),
          items:
              dropDownList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                selected = val;
              });
              if (kDebugMode) {
                print("Selected: $val");
              }
            }
          },
        ),
      ],
    );
  }
}

class MySwitch extends StatefulWidget {
  const MySwitch({super.key});

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Connect Instagram"),
        Switch(
          value: isOn,
          onChanged: (bool val) {
            setState(() {
              isOn = val;
              if (kDebugMode) {
                print("Switch: $isOn");
              }
            });
          },
        ),
      ],
    );
  }
}

class MyRadio extends StatefulWidget {
  const MyRadio({super.key});

  @override
  State<MyRadio> createState() => _MyRadioState();
}

class _MyRadioState extends State<MyRadio> {
  String sex = "pria";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jenis Kelamin:"),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Pria"),
                value: 'pria',
                groupValue: sex,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      sex = value;
                      if (kDebugMode) {
                        print("sex: $sex");
                      }
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Wanita"),
                value: "wanita",
                groupValue: sex,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      sex = value;
                      if (kDebugMode) {
                        print("sex: $sex");
                      }
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  State<MyCheckbox> createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              if (value != null) {
                isChecked = value;
                if (kDebugMode) {
                  print("setuju: $isChecked");
                }
              }
            });
          },
        ),
        const SizedBox(width: 4),
        const Expanded(
          child: Text(
            "Setuju syarat dan ketentuan.",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );
        setState(() {
          if (pickedDate != null) {
            dateController.text = pickedDate.toString();
          }
        });
        debugPrint("Date Picker: $pickedDate");
      },
      child: IgnorePointer(
        child: TextFormField(
          initialValue: "2023-12-11",
          maxLength: 20,
          decoration: const InputDecoration(
            labelText: "Tanggal Lahir",
            labelStyle: TextStyle(color: Colors.blueGrey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey),
            ),
            suffixIcon: Icon(Icons.date_range),
            helperText: "Pilih tanggal lahir anda",
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Info'),
                content: const SingleChildScrollView(
                  child: ListBody(children: [Text('Your order was placed.')]),
                ),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Open Dialog'),
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Your order was placed!'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Text('Open BottomSheet'),
      ),
    );
  }
}

class MySnackbarButton extends StatelessWidget {
  const MySnackbarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your request is successful'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        child: const Text('Open SnackBar'),
      ),
    );
  }
}
