import 'package:flutter/material.dart';

import 'dart:math';

void main() {
  runApp(const SimuladorInvestimentosApp());
}

class SimuladorInvestimentosApp extends StatelessWidget {
  const SimuladorInvestimentosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Investimentos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.teal,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const FormularioScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _capInicial1Ctrl = TextEditingController();
  final _aporteMensal1Ctrl = TextEditingController();
  final _taxaJuros1Ctrl = TextEditingController();

  final _capInicial2Ctrl = TextEditingController();
  final _aporteMensal2Ctrl = TextEditingController();
  final _taxaJuros2Ctrl = TextEditingController();

  final _mesesCtrl = TextEditingController();

  void _simular() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadosScreen(
            capInicial1: double.parse(_capInicial1Ctrl.text),
            aporteMensal1: double.parse(_aporteMensal1Ctrl.text),
            taxaJuros1: double.parse(_taxaJuros1Ctrl.text),
            capInicial2: double.parse(_capInicial2Ctrl.text),
            aporteMensal2: double.parse(_aporteMensal2Ctrl.text),
            taxaJuros2: double.parse(_taxaJuros2Ctrl.text),
            meses: int.parse(_mesesCtrl.text),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Simulador de Investimentos')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionCard('Período de Investimento', Colors.black87, [
                _buildTextField(
                  _mesesCtrl,
                  'Período (Meses)',
                  Icons.calendar_month,
                ),
              ]),
              const SizedBox(height: 12),

              _buildSectionCard('Investimento 1 (Roxo)', Colors.deepPurple, [
                _buildTextField(
                  _capInicial1Ctrl,
                  'Capital Inicial (R\$)',
                  Icons.monetization_on,
                ),
                _buildTextField(
                  _aporteMensal1Ctrl,
                  'Aporte Mensal (R\$)',
                  Icons.add_circle_outline,
                ),
                _buildTextField(
                  _taxaJuros1Ctrl,
                  'Taxa de Juros Mensal (%)',
                  Icons.percent,
                ),
              ]),
              const SizedBox(height: 12),

              _buildSectionCard('Investimento 2 (Teal)', Colors.teal, [
                _buildTextField(
                  _capInicial2Ctrl,
                  'Capital Inicial (R\$)',
                  Icons.monetization_on,
                ),
                _buildTextField(
                  _aporteMensal2Ctrl,
                  'Aporte Mensal (R\$)',
                  Icons.add_circle_outline,
                ),
                _buildTextField(
                  _taxaJuros2Ctrl,
                  'Taxa de Juros Mensal (%)',
                  Icons.percent,
                ),
              ]),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _simular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('COMPARAR RESULTADOS'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    Color titleColor,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Obrigatório';
          }
          if (double.tryParse(value) == null) {
            return 'Inválido';
          }
          return null;
        },
      ),
    );
  }
}

class ResultadosScreen extends StatefulWidget {
  final double capInicial1, aporteMensal1, taxaJuros1;
  final double capInicial2, aporteMensal2, taxaJuros2;
  final int meses;

  const ResultadosScreen({
    super.key,
    required this.capInicial1,
    required this.aporteMensal1,
    required this.taxaJuros1,
    required this.capInicial2,
    required this.aporteMensal2,
    required this.taxaJuros2,
    required this.meses,
  });

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  List<Map<String, dynamic>> _evolucao = [];
  double _montanteFinal1 = 0, _rendimentoTotal1 = 0;
  double _montanteFinal2 = 0, _rendimentoTotal2 = 0;

  @override
  void initState() {
    super.initState();
    _calcularInvestimentos();
  }

  void _calcularInvestimentos() {
    double saldo1 = widget.capInicial1;
    double saldo2 = widget.capInicial2;

    double taxa1 = widget.taxaJuros1 / 100;
    double taxa2 = widget.taxaJuros2 / 100;

    List<Map<String, dynamic>> evolucaoTemp = [];

    for (int i = 1; i <= widget.meses; i++) {
      saldo1 = (saldo1 + (i > 1 ? widget.aporteMensal1 : 0)) * (1 + taxa1);
      saldo2 = (saldo2 + (i > 1 ? widget.aporteMensal2 : 0)) * (1 + taxa2);

      evolucaoTemp.add({'mes': i, 'saldo1': saldo1, 'saldo2': saldo2});
    }

    setState(() {
      _evolucao = evolucaoTemp;

      _montanteFinal1 = saldo1;
      _rendimentoTotal1 =
          saldo1 -
          widget.capInicial1 -
          (widget.aporteMensal1 * (widget.meses - 1));

      _montanteFinal2 = saldo2;
      _rendimentoTotal2 =
          saldo2 -
          widget.capInicial2 -
          (widget.aporteMensal2 * (widget.meses - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Resultados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildCardResumo(
                    'Investimento 1',
                    _montanteFinal1,
                    _rendimentoTotal1,
                    Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCardResumo(
                    'Investimento 2',
                    _montanteFinal2,
                    _rendimentoTotal2,
                    Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mês',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Inv 1 (R\$)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Inv 2 (R\$)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _evolucao.length,
              itemBuilder: (context, index) {
                final dado = _evolucao[index];
                final isEven = index % 2 == 0;

                return Container(
                  color: isEven
                      ? Colors.white
                      : Colors.deepPurple.withOpacity(0.03),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dado['mes']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        dado['saldo1'].toStringAsFixed(2),
                        style: TextStyle(color: Colors.deepPurple.shade700),
                      ),
                      Text(
                        dado['saldo2'].toStringAsFixed(2),
                        style: TextStyle(color: Colors.teal.shade700),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: const BorderSide(color: Colors.deepPurple, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'NOVA SIMULAÇÃO',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResumo(
    String titulo,
    double montante,
    double rendimento,
    Color cor,
  ) {
    return Card(
      color: cor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Montante Final:',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              'R\$ ${montante.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Rendimento Acumulado:',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              'R\$ ${rendimento.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
