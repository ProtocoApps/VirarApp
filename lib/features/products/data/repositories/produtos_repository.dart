import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/produto_model.dart';
import '../../domain/models/carrinho_item_model.dart';

class ProdutosRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Buscar produtos de uma funerária
  Future<List<ProdutoModel>> getProdutosByFuneraria(int funerariaId) async {
    try {
      final response = await _supabase
          .from('produtos')
          .select()
          .eq('funeraria_id', funerariaId)
          .eq('ativo', true)
          .order('destaque', ascending: false)
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => ProdutoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  // Buscar produtos por categoria
  Future<List<ProdutoModel>> getProdutosByCategoria(
    int funerariaId,
    String categoria,
  ) async {
    try {
      final response = await _supabase
          .from('produtos')
          .select()
          .eq('funeraria_id', funerariaId)
          .eq('categoria', categoria)
          .eq('ativo', true)
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => ProdutoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos por categoria: $e');
    }
  }

  // Buscar produtos em destaque
  Future<List<ProdutoModel>> getProdutosDestaque(int funerariaId) async {
    try {
      final response = await _supabase
          .from('produtos')
          .select()
          .eq('funeraria_id', funerariaId)
          .eq('destaque', true)
          .eq('ativo', true)
          .order('nome', ascending: true);

      return (response as List)
          .map((json) => ProdutoModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos em destaque: $e');
    }
  }

  // Buscar produto por ID
  Future<ProdutoModel?> getProdutoById(int id) async {
    try {
      final response = await _supabase
          .from('produtos')
          .select()
          .eq('id', id)
          .single();

      return ProdutoModel.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }

  // Buscar itens do carrinho do usuário
  Future<List<CarrinhoItemModel>> getCarrinho() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _supabase
          .from('carrinho')
          .select('*, produtos(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CarrinhoItemModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar carrinho: $e');
    }
  }

  // Adicionar produto ao carrinho
  Future<void> adicionarAoCarrinho(int produtoId, int quantidade) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verificar se o produto já está no carrinho
      final existing = await _supabase
          .from('carrinho')
          .select()
          .eq('user_id', userId)
          .eq('produto_id', produtoId)
          .maybeSingle();

      if (existing != null) {
        // Atualizar quantidade
        final novaQuantidade = (existing['quantidade'] as int) + quantidade;
        await _supabase
            .from('carrinho')
            .update({'quantidade': novaQuantidade})
            .eq('id', existing['id']);
      } else {
        // Inserir novo item
        await _supabase.from('carrinho').insert({
          'user_id': userId,
          'produto_id': produtoId,
          'quantidade': quantidade,
        });
      }
    } catch (e) {
      throw Exception('Erro ao adicionar ao carrinho: $e');
    }
  }

  // Atualizar quantidade no carrinho
  Future<void> atualizarQuantidade(int carrinhoId, int quantidade) async {
    try {
      if (quantidade <= 0) {
        await removerDoCarrinho(carrinhoId);
        return;
      }

      await _supabase
          .from('carrinho')
          .update({'quantidade': quantidade})
          .eq('id', carrinhoId);
    } catch (e) {
      throw Exception('Erro ao atualizar quantidade: $e');
    }
  }

  // Remover item do carrinho
  Future<void> removerDoCarrinho(int carrinhoId) async {
    try {
      await _supabase.from('carrinho').delete().eq('id', carrinhoId);
    } catch (e) {
      throw Exception('Erro ao remover do carrinho: $e');
    }
  }

  // Limpar carrinho
  Future<void> limparCarrinho() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _supabase.from('carrinho').delete().eq('user_id', userId);
    } catch (e) {
      throw Exception('Erro ao limpar carrinho: $e');
    }
  }

  // Criar pedido
  Future<int> criarPedido({
    required int funerariaId,
    required double total,
    required String formaPagamento,
    String? observacoes,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Criar pedido
      final pedidoResponse = await _supabase
          .from('pedidos')
          .insert({
            'user_id': userId,
            'funeraria_id': funerariaId,
            'total': total,
            'forma_pagamento': formaPagamento,
            'observacoes': observacoes,
            'status': 'pendente',
          })
          .select()
          .single();

      final pedidoId = pedidoResponse['id'] as int;

      // Buscar itens do carrinho
      final carrinho = await getCarrinho();

      // Adicionar itens ao pedido
      final itens = carrinho.map((item) {
        final precoUnitario = item.produto!.precoFinal;
        return {
          'pedido_id': pedidoId,
          'produto_id': item.produtoId,
          'quantidade': item.quantidade,
          'preco_unitario': precoUnitario,
          'subtotal': precoUnitario * item.quantidade,
        };
      }).toList();

      await _supabase.from('pedido_itens').insert(itens);

      // Limpar carrinho
      await limparCarrinho();

      return pedidoId;
    } catch (e) {
      throw Exception('Erro ao criar pedido: $e');
    }
  }

  // Buscar pedidos do usuário
  Future<List<Map<String, dynamic>>> getPedidosUsuario() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _supabase
          .from('pedidos')
          .select('*, funerarias(nome)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar pedidos: $e');
    }
  }

  // Buscar itens de um pedido
  Future<List<Map<String, dynamic>>> getItensPedido(int pedidoId) async {
    try {
      final response = await _supabase
          .from('pedido_itens')
          .select('*, produtos(nome, imagem)')
          .eq('pedido_id', pedidoId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Erro ao buscar itens do pedido: $e');
    }
  }
}
