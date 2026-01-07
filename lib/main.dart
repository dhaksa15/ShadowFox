import 'dart:math';
import 'package:flutter/material.dart';

const double ln10 = 2.302585092994046;

void main() {
  runApp(const VibeCalcApp());
}

class VibeCalcApp extends StatefulWidget {
  const VibeCalcApp({super.key});
  @override
  State<VibeCalcApp> createState() => _VibeCalcAppState();
}

class _VibeCalcAppState extends State<VibeCalcApp> {
  ThemeMode themeMode = ThemeMode.dark;
  Color accent = Colors.deepOrange;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void setAccent(Color c) => setState(() => accent = c);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: accent,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: accent,
        useMaterial3: true,
      ),
      home: CalculatorHome(
        toggleTheme: toggleTheme,
        setAccent: setAccent,
        initialAccent: accent,
      ),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(Color) setAccent;
  final Color initialAccent;
  const CalculatorHome({
    super.key,
    required this.toggleTheme,
    required this.setAccent,
    required this.initialAccent,
  });

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  int pageIndex = 0;
  Color accent = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    accent = widget.initialAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vibe Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          PopupMenuButton<Color>(
            icon: const Icon(Icons.palette),
            onSelected: (c) => setState(() => accent = c),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Colors.deepOrange,
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.deepOrange, radius: 8),
                    const SizedBox(width: 6),
                    const Text("Orange"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Colors.blue,
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.blue, radius: 8),
                    const SizedBox(width: 6),
                    const Text("Blue"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Colors.purple,
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.purple, radius: 8),
                    const SizedBox(width: 6),
                    const Text("Purple"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: pageIndex == 0
          ? CalculatorScreen(accent: accent)
          : ConverterScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedItemColor: accent,
        onTap: (v) => setState(() => pageIndex = v),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Calculator",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Converters",
          ),
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final Color accent;
  const CalculatorScreen({super.key, required this.accent});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String output = "";
  bool scientific = false;
  bool shouldReset = false;
  bool isDegree = true;

  final List<String> basicButtons = [
    "C",
    "DEL",
    "(",
    ")",
    "7",
    "8",
    "9",
    "÷",
    "4",
    "5",
    "6",
    "×",
    "1",
    "2",
    "3",
    "-",
    "0",
    ".",
    "=",
    "+",
  ];

  final List<String> sciButtons = [
    "sin",
    "cos",
    "tan",
    "^",
    "ln",
    "log",
    "sqrt",
    "!",
    "pi",
    "e",
  ];

  //--------------------------------------------------------
  // BUTTON HANDLER
  //--------------------------------------------------------

  void onPress(String value) {
    setState(() {
      if (shouldReset && double.tryParse(value) != null) {
        input = value;
        output = "";
        shouldReset = false;
        return;
      }

      if (value == "C") {
        input = "";
        output = "";
        return;
      }
      if (value == "DEL") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
        return;
      }
      if (value == "=") {
        calculate();
        shouldReset = true;
        return;
      }

      if (value == "pi") {
        input += pi.toString();
        return;
      }
      if (value == "e") {
        input += e.toString();
        return;
      }
      if (value == "!") {
        input += "!";
        return;
      }

      input += value;
      shouldReset = false;
    });
  }

  //--------------------------------------------------------
  // CALCULATOR ENGINE
  //--------------------------------------------------------

  void calculate() {
    try {
      String expr = input.replaceAll("×", "*").replaceAll("÷", "/");
      double result = evaluateExpression(expr);
      output = (result % 1 == 0)
          ? result.toInt().toString()
          : result.toString();
    } catch (e) {
      output = "Error";
    }
    setState(() {});
  }

  double evaluateExpression(String expr) {
    final tokens = tokenize(expr);
    final postfix = toPostfix(tokens);
    return evalPostfix(postfix);
  }

  //--------------------------------------------------------
  // TOKENIZER
  //--------------------------------------------------------

  List<String> tokenize(String expr) {
    List<String> t = [];
    expr = expr.replaceAll(" ", "");
    int i = 0;

    final funcRegex = RegExp(r'^(sin|cos|tan|log|ln|sqrt)');

    while (i < expr.length) {
      String c = expr[i];

      if (RegExp(r'\d|\.').hasMatch(c)) {
        String num = "";
        while (i < expr.length && RegExp(r'[\d\.]').hasMatch(expr[i])) {
          num += expr[i];
          i++;
        }
        t.add(num);
        continue;
      }

      if ("()+-*/^%!".contains(c)) {
        t.add(c);
        i++;
        continue;
      }

      String rem = expr.substring(i);
      final m = funcRegex.firstMatch(rem);
      if (m != null) {
        t.add(m.group(0)!);
        i += m.group(0)!.length;
        continue;
      }

      if (rem.startsWith("pi")) {
        t.add(pi.toString());
        i += 2;
        continue;
      }
      if (rem.startsWith("e")) {
        t.add(e.toString());
        i++;
        continue;
      }

      t.add(c);
      i++;
    }

    return t;
  }

  //--------------------------------------------------------
  // INFIX → POSTFIX
  //--------------------------------------------------------

  List<String> toPostfix(List<String> tokens) {
    List<String> out = [];
    List<String> stack = [];

    final prec = {"+": 1, "-": 1, "*": 2, "/": 2, "%": 2, "^": 3};
    final right = {"^"};

    for (var t in tokens) {
      if (double.tryParse(t) != null) {
        out.add(t);
        continue;
      }
      if (_isFunc(t)) {
        stack.add(t);
        continue;
      }
      if (prec.containsKey(t)) {
        while (stack.isNotEmpty &&
            prec.containsKey(stack.last) &&
            ((right.contains(t) && prec[stack.last]! > prec[t]!) ||
                (!right.contains(t) && prec[stack.last]! >= prec[t]!))) {
          out.add(stack.removeLast());
        }
        stack.add(t);
        continue;
      }
      if (t == "(") {
        stack.add(t);
        continue;
      }
      if (t == ")") {
        while (stack.isNotEmpty && stack.last != "(") {
          out.add(stack.removeLast());
        }
        if (stack.isNotEmpty) stack.removeLast();
        if (stack.isNotEmpty && _isFunc(stack.last)) {
          out.add(stack.removeLast());
        }
        continue;
      }
      out.add(t);
    }

    while (stack.isNotEmpty) out.add(stack.removeLast());
    return out;
  }

  bool _isFunc(String t) =>
      {"sin", "cos", "tan", "log", "ln", "sqrt"}.contains(t);

  //--------------------------------------------------------
  // POSTFIX EVALUATION
  //--------------------------------------------------------

  double evalPostfix(List<String> p) {
    List<double> stack = [];

    for (var t in p) {
      if (double.tryParse(t) != null) {
        stack.add(double.parse(t));
        continue;
      }

      if (_isFunc(t)) {
        double a = stack.removeLast();
        double angle = isDegree ? a * pi / 180 : a;

        switch (t) {
          case "sin":
            stack.add(sin(angle));
            break;
          case "cos":
            stack.add(cos(angle));
            break;
          case "tan":
            stack.add(tan(angle));
            break;
          case "log":
            stack.add(log(a) / ln10);
            break;
          case "ln":
            stack.add(log(a));
            break;
          case "sqrt":
            stack.add(sqrt(a));
            break;
        }
        continue;
      }

      if (t == "!") {
        int n = stack.removeLast().toInt();
        stack.add(_fact(n).toDouble());
        continue;
      }

      double b = stack.removeLast();
      double a = stack.removeLast();

      switch (t) {
        case "+":
          stack.add(a + b);
          break;
        case "-":
          stack.add(a - b);
          break;
        case "*":
          stack.add(a * b);
          break;
        case "/":
          stack.add(a / b);
          break;
        case "%":
          stack.add(a % b);
          break;
        case "^":
          stack.add(pow(a, b).toDouble());
          break;
      }
    }
    return stack.last;
  }

  int _fact(int n) {
    if (n < 0) throw Exception("Negative factorial");
    int r = 1;
    for (int i = 1; i <= n; i++) r *= i;
    return r;
  }

  //--------------------------------------------------------
  // UI LAYOUT — FIXED VERSION
  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ------------------------------------
        // DISPLAY AREA
        // ------------------------------------
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomRight,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  input,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  output,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ------------------------------------
        // SCIENTIFIC SWITCH + DEG/RAD
        // ------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Switch(
                value: scientific,
                onChanged: (v) => setState(() => scientific = v),
              ),
              const Text("Scientific"),

              const Spacer(),

              _degRadButton("DEG", isDegree),
              const SizedBox(width: 6),
              _degRadButton("RAD", !isDegree),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // ------------------------------------
        // SCROLLABLE BODY (FIXED VERSION)
        // ------------------------------------
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (scientific) _buildScientific(),

              Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: basicButtons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (c, i) {
                    String label = basicButtons[i];
                    return CalculatorKey(
                      label: label,
                      onTap: () => onPress(label),
                      isOperator: "÷×+-=%".contains(label),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _degRadButton(String text, bool active) {
    return GestureDetector(
      onTap: () => setState(() => isDegree = text == "DEG"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.orange : Colors.grey[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildScientific() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: 1.3,
        physics: const NeverScrollableScrollPhysics(),
        children: sciButtons.map((b) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[850],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => onPress(b),
              child: Text(
                b,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CalculatorKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;

  const CalculatorKey({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isOperator
        ? Colors.orange
        : (Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[850]
              : Colors.white);
    final fg = isOperator
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87);

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 26, color: fg, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// SIMPLE PLACEHOLDER FOR CONVERTER SCREEN
// --- Replace existing ConverterScreen with this code ---

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});
  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Categories
  final List<String> categories = [
    'Length',
    'Weight',
    'Volume',
    'Temperature',
    'Speed',
    'Data',
  ];
  String selectedCategory = 'Length';

  // Units per category
  final Map<String, List<String>> units = {
    'Length': ['m', 'km', 'cm', 'mm', 'mi', 'yd', 'ft', 'in'],
    'Weight': ['kg', 'g', 'mg', 'lb', 'oz'],
    'Volume': ['L', 'mL', 'm³', 'cm³', 'gal(US)', 'fl oz'],
    'Temperature': ['°C', '°F', 'K'],
    'Speed': ['m/s', 'km/h', 'mph', 'knots'],
    'Data': ['B', 'KB', 'MB', 'GB', 'TB'],
  };

  // Conversion factors to base units (Length: meter, Weight: kg, Volume: liter, Speed: m/s, Data: bytes)
  final Map<String, Map<String, double>> factor = {
    'Length': {
      'm': 1.0,
      'km': 1000.0,
      'cm': 0.01,
      'mm': 0.001,
      'mi': 1609.344,
      'yd': 0.9144,
      'ft': 0.3048,
      'in': 0.0254,
    },
    'Weight': {
      'kg': 1.0,
      'g': 0.001,
      'mg': 1e-6,
      'lb': 0.45359237,
      'oz': 0.028349523125,
    },
    'Volume': {
      'L': 1.0,
      'mL': 0.001,
      'm³': 1000.0,
      'cm³': 0.001, // 1 cm³ = 1 mL
      'gal(US)': 3.785411784,
      'fl oz': 0.0295735295625,
    },
    // Temperature handled specially
    'Speed': {
      'm/s': 1.0,
      'km/h': 0.27777777777778,
      'mph': 0.44704,
      'knots': 0.51444444444444,
    },
    'Data': {
      'B': 1.0,
      'KB': 1024.0,
      'MB': 1024.0 * 1024.0,
      'GB': 1024.0 * 1024.0 * 1024.0,
      'TB': 1024.0 * 1024.0 * 1024.0 * 1024.0,
    },
  };

  String fromUnit = '';
  String toUnit = '';
  final TextEditingController _valueCtl = TextEditingController(text: '1');
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _setDefaultUnits();
    _valueCtl.addListener(_onValueChanged);
    _compute(); // initial compute
  }

  void _setDefaultUnits() {
    final list = units[selectedCategory]!;
    fromUnit = list[0];
    toUnit = list.length > 1 ? list[1] : list[0];
  }

  void _onValueChanged() {
    _compute();
  }

  void _onCategoryChanged(String cat) {
    setState(() {
      selectedCategory = cat;
      _setDefaultUnits();
      _compute();
    });
  }

  void _swapUnits() {
    setState(() {
      final a = fromUnit;
      fromUnit = toUnit;
      toUnit = a;
      _compute();
    });
  }

  void _compute() {
    final inputStr = _valueCtl.text.trim();
    if (inputStr.isEmpty) {
      setState(() => resultText = '');
      return;
    }

    final value = double.tryParse(inputStr.replaceAll(',', ''));
    if (value == null) {
      setState(() => resultText = 'Invalid input');
      return;
    }

    double out = 0.0;
    try {
      if (selectedCategory == 'Temperature') {
        out = _convertTemperature(value, fromUnit, toUnit);
      } else {
        final Map<String, double> map = factor[selectedCategory]!;
        final double base = value * map[fromUnit]!; // convert to base
        out = base / map[toUnit]!; // convert base to target
      }
      // pretty formatting: if integer show without decimal
      final s = (out % 1 == 0) ? out.toInt().toString() : out.toString();
      setState(() => resultText = s);
    } catch (e) {
      setState(() => resultText = 'Error');
    }
  }

  double _convertTemperature(double v, String f, String t) {
    // Convert f -> Celsius -> t
    double c;
    if (f == '°C') {
      c = v;
    } else if (f == '°F') {
      c = (v - 32) * 5 / 9;
    } else {
      // K
      c = v - 273.15;
    }

    if (t == '°C') return c;
    if (t == '°F') return c * 9 / 5 + 32;
    return c + 273.15; // K
  }

  @override
  void dispose() {
    _valueCtl.removeListener(_onValueChanged);
    _valueCtl.dispose();
    super.dispose();
  }

  Widget _categoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: categories.map((c) {
          final active = c == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(c),
              selected: active,
              onSelected: (_) => _onCategoryChanged(c),
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
              labelStyle: TextStyle(
                color: active
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black87),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _unitDropdown(
    String value,
    ValueChanged<String?> onChanged,
    List<String> items,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableUnits = units[selectedCategory]!;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _categoryChips(),
          const SizedBox(height: 16),

          // input + swap
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _valueCtl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Value',
                    hintText: 'Enter value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  IconButton(
                    onPressed: _swapUnits,
                    icon: const Icon(Icons.swap_vert, size: 28),
                    tooltip: 'Swap units',
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    onPressed: () {
                      _valueCtl.text = '';
                      setState(() => resultText = '');
                    },
                    icon: const Icon(Icons.clear, size: 22),
                    tooltip: 'Clear',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // From / To dropdowns
          Row(
            children: [
              Expanded(
                child: _unitDropdown(fromUnit, (v) {
                  if (v == null) return;
                  setState(() {
                    fromUnit = v;
                    _compute();
                  });
                }, availableUnits),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: _unitDropdown(toUnit, (v) {
                  if (v == null) return;
                  setState(() {
                    toUnit = v;
                    _compute();
                  });
                }, availableUnits),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Result',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  resultText.isEmpty ? '-' : resultText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                if (resultText.isNotEmpty)
                  Text(
                    '= $resultText $toUnit',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Helpful quick examples / presets
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Quick presets',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: _quickButtons()),
        ],
      ),
    );
  }

  List<Widget> _quickButtons() {
    if (selectedCategory == 'Length') {
      return [
        _preset('1 km → m', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'km';
            toUnit = 'm';
            _compute();
          });
        }),
        _preset('100 cm → m', () {
          setState(() {
            _valueCtl.text = '100';
            fromUnit = 'cm';
            toUnit = 'm';
            _compute();
          });
        }),
        _preset('1 mi → km', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'mi';
            toUnit = 'km';
            _compute();
          });
        }),
      ];
    } else if (selectedCategory == 'Temperature') {
      return [
        _preset('0 °C → °F', () {
          setState(() {
            _valueCtl.text = '0';
            fromUnit = '°C';
            toUnit = '°F';
            _compute();
          });
        }),
        _preset('100 °C → K', () {
          setState(() {
            _valueCtl.text = '100';
            fromUnit = '°C';
            toUnit = 'K';
            _compute();
          });
        }),
      ];
    } else if (selectedCategory == 'Weight') {
      return [
        _preset('1 kg → g', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'kg';
            toUnit = 'g';
            _compute();
          });
        }),
        _preset('1 lb → kg', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'lb';
            toUnit = 'kg';
            _compute();
          });
        }),
      ];
    } else if (selectedCategory == 'Speed') {
      return [
        _preset('100 km/h → m/s', () {
          setState(() {
            _valueCtl.text = '100';
            fromUnit = 'km/h';
            toUnit = 'm/s';
            _compute();
          });
        }),
        _preset('60 mph → km/h', () {
          setState(() {
            _valueCtl.text = '60';
            fromUnit = 'mph';
            toUnit = 'km/h';
            _compute();
          });
        }),
      ];
    } else if (selectedCategory == 'Data') {
      return [
        _preset('1 GB → MB', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'GB';
            toUnit = 'MB';
            _compute();
          });
        }),
        _preset('1024 KB → MB', () {
          setState(() {
            _valueCtl.text = '1024';
            fromUnit = 'KB';
            toUnit = 'MB';
            _compute();
          });
        }),
      ];
    } else {
      return [
        _preset('1 L → mL', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'L';
            toUnit = 'mL';
            _compute();
          });
        }),
        _preset('1 gal → L', () {
          setState(() {
            _valueCtl.text = '1';
            fromUnit = 'gal(US)';
            toUnit = 'L';
            _compute();
          });
        }),
      ];
    }
  }

  Widget _preset(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.04),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
