class ProdutoModel {
  final int id;
  final int funerariaId;
  final String nome;
  final String? descricao;
  final double preco;
  final double? precoPromocional;
  final String categoria;
  final String? imagem;
  final int estoque;
  final bool ativo;
  final bool destaque;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProdutoModel({
    required this.id,
    required this.funerariaId,
    required this.nome,
    this.descricao,
    required this.preco,
    this.precoPromocional,
    required this.categoria,
    this.imagem,
    required this.estoque,
    required this.ativo,
    required this.destaque,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json['id'] as int,
      funerariaId: json['funeraria_id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      preco: (json['preco'] as num).toDouble(),
      precoPromocional: json['preco_promocional'] != null
          ? (json['preco_promocional'] as num).toDouble()
          : null,
      categoria: json['categoria'] as String,
      imagem: json['imagem'] as String?,
      estoque: json['estoque'] as int? ?? 0,
      ativo: json['ativo'] as bool? ?? true,
      destaque: json['destaque'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'funeraria_id': funerariaId,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'preco_promocional': precoPromocional,
      'categoria': categoria,
      'imagem': imagem,
      'estoque': estoque,
      'ativo': ativo,
      'destaque': destaque,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get precoFinal => precoPromocional ?? preco;

  bool get temPromocao => precoPromocional != null && precoPromocional! < preco;

  double get percentualDesconto {
    if (!temPromocao) return 0;
    return ((preco - precoPromocional!) / preco) * 100;
  }

  bool get emEstoque => estoque > 0;

  String get categoriaNome {
    switch (categoria) {
      case 'caixao':
        return 'Caixão';
      case 'urna':
        return 'Urna';
      case 'flores':
        return 'Flores';
      case 'servico':
        return 'Serviço';
      case 'acessorio':
        return 'Acessório';
      default:
        return categoria;
    }
  }

  ProdutoModel copyWith({
    int? id,
    int? funerariaId,
    String? nome,
    String? descricao,
    double? preco,
    double? precoPromocional,
    String? categoria,
    String? imagem,
    int? estoque,
    bool? ativo,
    bool? destaque,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      funerariaId: funerariaId ?? this.funerariaId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      precoPromocional: precoPromocional ?? this.precoPromocional,
      categoria: categoria ?? this.categoria,
      imagem: imagem ?? this.imagem,
      estoque: estoque ?? this.estoque,
      ativo: ativo ?? this.ativo,
      destaque: destaque ?? this.destaque,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
