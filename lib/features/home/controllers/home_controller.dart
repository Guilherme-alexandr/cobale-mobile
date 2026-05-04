// lib/features/home/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../../../core/services/login_servico.dart';
import '../../../core/services/acordo_service.dart';
import '../../../core/services/contrato_service.dart';
import '../models/home_item_model.dart';
import '../../detalhes/models/bill_model.dart';
import '../models/contrato_model.dart';

class HomeController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AcordoService _acordoService = AcordoService();
  final ContratoService _contratoService = ContratoService();

  List<HomeItem> _itens = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  List<HomeItem> get itens => _itens;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;

  // Estatísticas
  int get pendingCount => _itens.where((i) => i.status == 'pending').length;
  int get inProgressCount =>
      _itens.where((i) => i.status == 'in_progress').length;
  int get completedCount => _itens.where((i) => i.status == 'completed').length;

  Future<void> carregarDados({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final stopwatch = Stopwatch()..start();
      debugPrint('⏱️ Iniciando carregamento...');

      final cliente = await _authService.getCliente();
      final clienteId = int.tryParse(cliente['id'] ?? '0');

      if (clienteId == null || clienteId == 0) {
        throw Exception('Cliente não identificado');
      }

      debugPrint('👤 Cliente ID: $clienteId');
      debugPrint('👤 Cliente Nome: ${cliente['nome']}');

      final results = await Future.wait([
        _acordoService.buscarAcordosPorCliente(clienteId),
        _contratoService.buscarContratosPorCliente(clienteId),
      ]);

      final acordos = results[0] as List<Bill>;
      final contratos = results[1] as List<Contrato>;

      debugPrint('⏱️ Buscas concluídas em ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('📦 Acordos encontrados: ${acordos.length}');
      debugPrint('📄 Contratos encontrados: ${contratos.length}');

      final contratosComAcordo = acordos.map((a) => a.contratoId).toSet();
      debugPrint('🔗 Contratos com acordo: $contratosComAcordo');

      final contratosSemAcordo = contratos
          .where((c) => !contratosComAcordo.contains(c.numeroContrato))
          .toList();
      debugPrint('📋 Contratos sem acordo: ${contratosSemAcordo.length}');

      final List<HomeItem> itensTemp = [];

      for (var acordo in acordos) {
        itensTemp.add(
          HomeItem.fromAcordo(acordo, cliente['nome'] ?? 'Cliente'),
        );
      }

      // Adicionar contratos sem acordo (pendentes)
      for (var contrato in contratosSemAcordo) {
        itensTemp.add(
          HomeItem.fromContrato(contrato, cliente['nome'] ?? 'Cliente'),
        );
      }

      itensTemp.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      _itens = itensTemp;

      debugPrint('✅ Total de itens na home: ${_itens.length}');
      debugPrint('   - Pendentes: $pendingCount');
      debugPrint('   - Em andamento: $inProgressCount');
      debugPrint('   - Finalizados: $completedCount');
      debugPrint('⏱️ Carregamento total: ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      debugPrint('❌ Erro ao carregar dados: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      _errorMessage = 'Erro ao carregar suas cobranças. Tente novamente.';
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await carregarDados(isRefresh: true);
  }
}
