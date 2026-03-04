import 'package:flutter/material.dart';
import '../controllers/pagamento_controller.dart';

class CardCartaoCredito extends StatefulWidget {
  final double valor;
  final bool processando;
  final Function(Map<String, String>) aoProcessar;

  const CardCartaoCredito({
    Key? key,
    required this.valor,
    required this.processando,
    required this.aoProcessar,
  }) : super(key: key);

  @override
  State<CardCartaoCredito> createState() => _CardCartaoCreditoState();
}

class _CardCartaoCreditoState extends State<CardCartaoCredito> {
  final _formKey = GlobalKey<FormState>();
  final _controller = PagamentoController();

  String numeroCartao = '';
  String nomeCartao = '';
  String validade = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Número do Cartão
              TextFormField(
                initialValue: numeroCartao,
                keyboardType: TextInputType.number,
                maxLength: 19,
                decoration: InputDecoration(
                  labelText: 'Número do Cartão',
                  hintText: '0000 0000 0000 0000',
                  prefixIcon: const Icon(Icons.credit_card, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    numeroCartao = _controller.formatarNumeroCartao(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Número do cartão é obrigatório';
                  }
                  if (!_controller.validarCartao(value)) {
                    return 'Número de cartão inválido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Nome no Cartão
              TextFormField(
                initialValue: nomeCartao,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Nome no Cartão',
                  hintText: 'NOME COMO ESTÁ NO CARTÃO',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    nomeCartao = value.toUpperCase();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome no cartão é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Validade e CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: validade,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      decoration: InputDecoration(
                        labelText: 'Validade',
                        hintText: 'MM/AA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          validade = _controller.formatarValidade(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Validade obrigatória';
                        }
                        if (!_controller.validarValidade(value)) {
                          return 'Data inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: cvv,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cvv = value.replaceAll(RegExp(r'[^0-9]'), '');
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'CVV obrigatório';
                        }
                        if (!_controller.validarCVV(value)) {
                          return 'CVV inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Botão de pagamento
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: widget.processando
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            widget.aoProcessar({
                              'numeroCartao': numeroCartao,
                              'nomeCartao': nomeCartao,
                              'validade': validade,
                              'cvv': cvv,
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: widget.processando
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Processando...'),
                          ],
                        )
                      : Text(
                          'Pagar R\$ ${widget.valor.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
