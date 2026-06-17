import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/produtos_repository.dart';
import '../../domain/models/carrinho_item_model.dart';

final produtosRepositoryProvider = Provider((ref) => ProdutosRepository());

final carrinhoProvider = StateNotifierProvider<CarrinhoNotifier, AsyncValue<List<CarrinhoItemModel>>>((ref) {
  return CarrinhoNotifier(ref.read(produtosRepositoryProvider));
});

class CarrinhoNotifier extends StateNotifier<AsyncValue<List<CarrinhoItemModel>>> {
  final ProdutosRepository _repository;

  CarrinhoNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCarrinho();
  }

  Future<void> loadCarrinho() async {
    state = const AsyncValue.loading();
    try {
      final carrinho = await _repository.getCarrinho();
      state = AsyncValue.data(carrinho);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> adicionarProduto(int produtoId, int quantidade) async {
    try {
      await _repository.adicionarAoCarrinho(produtoId, quantidade);
      await loadCarrinho();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizarQuantidade(int carrinhoId, int quantidade) async {
    try {
      await _repository.atualizarQuantidade(carrinhoId, quantidade);
      await loadCarrinho();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removerItem(int carrinhoId) async {
    try {
      await _repository.removerDoCarrinho(carrinhoId);
      await loadCarrinho();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> limparCarrinho() async {
    try {
      await _repository.limparCarrinho();
      await loadCarrinho();
    } catch (e) {
      rethrow;
    }
  }

  int get totalItens {
    return state.maybeWhen(
      data: (itens) => itens.fold(0, (sum, item) => sum + item.quantidade),
      orElse: () => 0,
    );
  }

  double get totalCarrinho {
    return state.maybeWhen(
      data: (itens) => itens.fold(0.0, (sum, item) => sum + item.subtotal),
      orElse: () => 0.0,
    );
  }
}

// Provider para contar itens no carrinho
final carrinhoCountProvider = Provider<int>((ref) {
  final carrinho = ref.watch(carrinhoProvider);
  return carrinho.maybeWhen(
    data: (itens) => itens.fold(0, (sum, item) => sum + item.quantidade),
    orElse: () => 0,
  );
});

// Provider para calcular total do carrinho
final carrinhoTotalProvider = Provider<double>((ref) {
  final carrinho = ref.watch(carrinhoProvider);
  return carrinho.maybeWhen(
    data: (itens) => itens.fold(0.0, (sum, item) => sum + item.subtotal),
    orElse: () => 0.0,
  );
});
