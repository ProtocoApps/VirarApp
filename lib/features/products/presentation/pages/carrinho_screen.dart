import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';
import '../providers/carrinho_provider.dart';
import 'checkout_screen.dart';

class CarrinhoScreen extends ConsumerWidget {
  const CarrinhoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrinhoState = ref.watch(carrinhoProvider);

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Carrinho de Compras',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.gold),
        actions: [
          carrinhoState.maybeWhen(
            data: (itens) => itens.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _mostrarDialogoLimpar(context, ref),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: carrinhoState.when(
        data: (itens) {
          if (itens.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.gold.withValues(alpha: 0.3),
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Seu carrinho está vazio',
                      style: TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adicione produtos para continuar',
                      style: TextStyle(
                        color: AppColors.softWhite.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.deepBlack,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Continuar Comprando',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final total = itens.fold(0.0, (sum, item) => sum + item.subtotal);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    return _buildCarrinhoItem(context, ref, item);
                  },
                ),
              ),
              _buildResumo(context, ref, itens, total),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.gold,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao carregar carrinho',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(carrinhoProvider.notifier).loadCarrinho(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.deepBlack,
                  ),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarrinhoItem(BuildContext context, WidgetRef ref, item) {
    final produto = item.produto;
    if (produto == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.graphiteGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Imagem do produto
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.deepBlack.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: produto.imagem != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      produto.imagem!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackProductImage(produto.categoria);
                      },
                    ),
                  )
                : _buildFallbackProductImage(produto.categoria),
          ),
          const SizedBox(width: 12),

          // Informações do produto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${produto.precoFinal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),

                // Controles de quantidade
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.deepBlack.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            color: AppColors.gold,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              if (item.quantidade > 1) {
                                ref.read(carrinhoProvider.notifier).atualizarQuantidade(
                                      item.id,
                                      item.quantidade - 1,
                                    );
                              } else {
                                _mostrarDialogoRemover(context, ref, item);
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              item.quantidade.toString(),
                              style: const TextStyle(
                                color: AppColors.softWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            color: AppColors.gold,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              if (item.quantidade < produto.estoque) {
                                ref.read(carrinhoProvider.notifier).atualizarQuantidade(
                                      item.id,
                                      item.quantidade + 1,
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Estoque insuficiente',
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () => _mostrarDialogoRemover(context, ref, item),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Subtotal
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'R\$ ${item.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumo(BuildContext context, WidgetRef ref, List itens, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.graphiteGray,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        itens: itens,
                        total: total,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.deepBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Finalizar Compra',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackProductImage(String categoria) {
    final imageUrl = _getFallbackImageUrl(categoria);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          IconData icon;
          switch (categoria) {
            case 'caixao':
              icon = Icons.inventory_2_outlined;
              break;
            case 'urna':
              icon = Icons.local_florist_outlined;
              break;
            case 'flores':
              icon = Icons.local_florist;
              break;
            case 'servico':
              icon = Icons.room_service_outlined;
              break;
            case 'acessorio':
              icon = Icons.category_outlined;
              break;
            default:
              icon = Icons.shopping_bag_outlined;
          }

          return Icon(
            icon,
            color: AppColors.gold.withValues(alpha: 0.3),
            size: 32,
          );
        },
      ),
    );
  }

  String _getFallbackImageUrl(String categoria) {
    switch (categoria) {
      case 'caixao':
        return 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800&q=80';
      case 'urna':
        return 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800&q=80';
      case 'flores':
        return 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=800&q=80';
      case 'servico':
        return 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&q=80';
      case 'acessorio':
        return 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800&q=80';
    }
  }

  void _mostrarDialogoRemover(BuildContext context, WidgetRef ref, item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.graphiteGray,
        title: const Text(
          'Remover item',
          style: TextStyle(
            color: AppColors.softWhite,
            fontFamily: 'Poppins',
          ),
        ),
        content: Text(
          'Deseja remover "${item.produto?.nome}" do carrinho?',
          style: const TextStyle(
            color: AppColors.softWhite,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.softWhite,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(carrinhoProvider.notifier).removerItem(item.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Remover',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoLimpar(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.graphiteGray,
        title: const Text(
          'Limpar carrinho',
          style: TextStyle(
            color: AppColors.softWhite,
            fontFamily: 'Poppins',
          ),
        ),
        content: const Text(
          'Deseja remover todos os itens do carrinho?',
          style: TextStyle(
            color: AppColors.softWhite,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.softWhite,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(carrinhoProvider.notifier).limparCarrinho();
              Navigator.pop(context);
            },
            child: const Text(
              'Limpar',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
