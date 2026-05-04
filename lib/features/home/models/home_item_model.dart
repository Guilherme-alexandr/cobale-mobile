// lib/features/home/models/home_item_model.dart

import '../../detalhes/models/bill_model.dart';
import '../models/contrato_model.dart';

class HomeItem {
  final int id;
  final String contratoId;
  final String clientName;
  final String filial;
  final double value;
  final DateTime dueDate;
  final String status;
  final Bill? acordo;

  HomeItem({
    required this.id,
    required this.contratoId,
    required this.clientName,
    required this.filial,
    required this.value,
    required this.dueDate,
    required this.status,
    this.acordo,
  });

  factory HomeItem.fromContrato(Contrato contrato, String clientName) {
    return HomeItem(
      id: int.tryParse(contrato.numeroContrato) ?? 0,
      contratoId: contrato.numeroContrato,
      clientName: clientName,
      filial: contrato.filial,
      value: contrato.valorTotal,
      dueDate: contrato.vencimento,
      status: 'pending',
      acordo: null,
    );
  }

  factory HomeItem.fromAcordo(Bill acordo, String clientName) {
    return HomeItem(
      id: acordo.id,
      contratoId: acordo.contratoId,
      clientName: clientName,
      filial: '',
      value: acordo.value,
      dueDate: acordo.dueDate,
      status: acordo.appStatus,
      acordo: acordo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contratoId': contratoId,
      'clientName': clientName,
      'filial': filial,
      'value': value,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'acordo': acordo?.toJson(),
    };
  }

  factory HomeItem.fromJson(Map<String, dynamic> json) {
    return HomeItem(
      id: json['id'],
      contratoId: json['contratoId'],
      clientName: json['clientName'],
      filial: json['filial'],
      value: (json['value'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      acordo: json['acordo'] != null ? Bill.fromJson(json['acordo']) : null,
    );
  }
}
