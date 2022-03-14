import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.indigoAccent,
        ),
      ),
      title: 'Simple Interest Calculator',
      home: const SIForm(),
    );
  }
}

class SIForm extends StatefulWidget {
  const SIForm({Key? key}) : super(key: key);

  @override
  State<SIForm> createState() => _SIFormState();
}

class _SIFormState extends State<SIForm> {
  final _formKey = GlobalKey<FormState>();
  final double _whiteSpaces = 5.0;
  final List<String> _currencies = ['Rupees', 'Pounds', 'Dollars', 'Euro'];
  String _selectedItem = '';
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String displayResult = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _selectedItem = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_whiteSpaces * 2),
          child: ListView(
            children: <Widget>[
              const Image(
                width: 125.0,
                height: 125.0,
                image: AssetImage('images/money.png'),
              ),
              SizedBox(height: _whiteSpaces * 2),
              _textField('Principal', 'Enter Principal e.g. 12000',
                  principalController, 'Please enter the principal'),
              SizedBox(height: _whiteSpaces * 2),
              _textField('Rate of Interest', 'In percent', roiController,
                  'Please enter the interest'),
              SizedBox(height: _whiteSpaces * 2),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _textField('Term', 'Time in years', termController,
                        'Please enter the years'),
                  ),
                  SizedBox(width: _whiteSpaces * 2),
                  Expanded(
                    child: DropdownButton<String>(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? userSelectedItem) {
                        setState(() {
                          _selectedItem = userSelectedItem!;
                        });
                      },
                      value: _selectedItem,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _whiteSpaces * 2),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                        onPrimary: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            displayResult = calculateReturns();
                          }
                        });
                      },
                      child: const Text(
                        'Calculate',
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColorDark,
                        onPrimary: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                      child: const Text(
                        'Reset',
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _whiteSpaces * 2),
              Text(displayResult),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, String hint,
      [TextEditingController? control, String? validateIt]) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    return TextFormField(
      keyboardType: TextInputType.number,
      style: textStyle,
      controller: control,
      validator: (String? value) {
        if (value!.isEmpty) {
          return validateIt;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: textStyle,
        errorStyle: const TextStyle(
          color: Colors.yellowAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_whiteSpaces),
        ),
      ),
    );
  }

  String calculateReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double result = principal + (principal * roi * term) / 100;
    return 'Your returns after $term years is $result $_selectedItem';
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _selectedItem = _currencies[0];
  }
}
