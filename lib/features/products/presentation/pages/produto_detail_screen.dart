import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';
import '../../domain/models/produto_model.dart';
import '../providers/carrinho_provider.dart';

class ProdutoDetailScreen extends ConsumerStatefulWidget {
  final ProdutoModel produto;

  const ProdutoDetailScreen({
    super.key,
    required this.produto,
  });

  @override
  ConsumerState<ProdutoDetailScreen> createState() => _ProdutoDetailScreenState();
}

class _ProdutoDetailScreenState extends ConsumerState<ProdutoDetailScreen> {
  int _quantidade = 1;
  bool _isAdding = false;

  void _incrementar() {
    if (_quantidade < widget.produto.estoque) {
      setState(() {
        _quantidade++;
      });
    }
  }

  void _decrementar() {
    if (_quantidade > 1) {
      setState(() {
        _quantidade--;
      });
    }
  }

  Future<void> _adicionarAoCarrinho() async {
    if (_isAdding) return;

    setState(() {
      _isAdding = true;
    });

    try {
      await ref.read(carrinhoProvider.notifier).adicionarProduto(
            widget.produto.id,
            _quantidade,
          );

      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.produto.nome} adicionado ao carrinho',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.gold,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Ver carrinho',
              textColor: AppColors.deepBlack,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao adicionar ao carrinho: $e',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.produto.precoFinal * _quantidade;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detalhes do Produto',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem do produto
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.graphiteGray,
                        ),
                        child: widget.produto.imagem != null
                            ? Image.network(
                                widget.produto.imagem!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderIcon();
                                },
                              )
                            : _buildPlaceholderIcon(),
                      ),
                      if (widget.produto.temPromocao)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '-${widget.produto.percentualDesconto.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      if (widget.produto.destaque)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: AppColors.deepBlack,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Destaque',
                                  style: TextStyle(
                                    color: AppColors.deepBlack,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Informações do produto
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categoria
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.produto.categoriaNome,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Nome do produto
                        Text(
                          widget.produto.nome,
                          style: const TextStyle(
                            color: AppColors.softWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Preço
                        Row(
                          children: [
                            if (widget.produto.temPromocao) ...[
                              Text(
                                'R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: AppColors.softWhite.withValues(alpha: 0.5),
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              'R\$ ${widget.produto.precoFinal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Estoque
                        Row(
                          children: [
                            Icon(
                              widget.produto.emEstoque
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              color: widget.produto.emEstoque
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.produto.emEstoque
                                  ? 'Em estoque (${widget.produto.estoque} disponíveis)'
                                  : 'Fora de estoque',
                              style: TextStyle(
                                color: widget.produto.emEstoque
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),

                        if (widget.produto.descricao != null) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Descrição',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.produto.descricao!,
                            style: TextStyle(
                              color: AppColors.softWhite.withValues(alpha: 0.8),
                              fontSize: 14,
                              height: 1.5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Seletor de quantidade
                        if (widget.produto.emEstoque) ...[
                          const Text(
                            'Quantidade',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.graphiteGray,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: _decrementar,
                                      icon: const Icon(Icons.remove),
                                      color: AppColors.gold,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        _quantidade.toString(),
                                        style: const TextStyle(
                                          color: AppColors.softWhite,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _incrementar,
                                      icon: const Icon(Icons.add),
                                      color: AppColors.gold,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      color: AppColors.softWhite,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão adicionar ao carrinho
          if (widget.produto.emEstoque)
            Container(
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAdding ? null : _adicionarAoCarrinho,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.deepBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isAdding
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.deepBlack,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shopping_cart_outlined),
                              SizedBox(width: 8),
                              Text(
                                'Adicionar ao Carrinho',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    final imageUrl = _getFallbackImageUrl(widget.produto.categoria);

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        IconData icon;
        switch (widget.produto.categoria) {
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

        return Center(
          child: Icon(
            icon,
            color: AppColors.gold.withValues(alpha: 0.3),
            size: 80,
          ),
        );
      },
    );
  }

  String _getFallbackImageUrl(String categoria) {
    switch (widget.produto.categoria) {
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
}
