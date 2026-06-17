import 'produto_model.dart';

class CarrinhoItemModel {
  final int id;
  final String userId;
  final int produtoId;
  final int quantidade;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProdutoModel? produto;

  CarrinhoItemModel({
    required this.id,
    required this.userId,
    required this.produtoId,
    required this.quantidade,
    required this.createdAt,
    required this.updatedAt,
    this.produto,
  });

  factory CarrinhoItemModel.fromJson(Map<String, dynamic> json) {
    return CarrinhoItemModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      produtoId: json['produto_id'] as int,
      quantidade: json['quantidade'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      produto: json['produtos'] != null
          ? ProdutoModel.fromJson(json['produtos'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get subtotal {
    if (produto == null) return 0;
    return produto!.precoFinal * quantidade;
  }

  CarrinhoItemModel copyWith({
    int? id,
    String? userId,
    int? produtoId,
    int? quantidade,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProdutoModel? produto,
  }) {
    return CarrinhoItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      produtoId: produtoId ?? this.produtoId,
      quantidade: quantidade ?? this.quantidade,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      produto: produto ?? this.produto,
    );
  }
}
