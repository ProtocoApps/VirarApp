import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';
import '../../data/repositories/produtos_repository.dart';
import '../../domain/models/produto_model.dart';
import '../providers/carrinho_provider.dart';
import 'produto_detail_screen.dart';
import 'carrinho_screen.dart';

class ProdutosListScreen extends ConsumerStatefulWidget {
  final int funerariaId;
  final String funerariaNome;

  const ProdutosListScreen({
    super.key,
    required this.funerariaId,
    required this.funerariaNome,
  });

  @override
  ConsumerState<ProdutosListScreen> createState() => _ProdutosListScreenState();
}

class _ProdutosListScreenState extends ConsumerState<ProdutosListScreen> {
  final _repository = ProdutosRepository();
  List<ProdutoModel> _produtos = [];
  List<ProdutoModel> _produtosFiltrados = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _categoriaFiltro = 'todos';

  final List<Map<String, String>> _categorias = [
    {'id': 'todos', 'nome': 'Todos'},
    {'id': 'caixao', 'nome': 'Caixões'},
    {'id': 'urna', 'nome': 'Urnas'},
    {'id': 'flores', 'nome': 'Flores'},
    {'id': 'servico', 'nome': 'Serviços'},
    {'id': 'acessorio', 'nome': 'Acessórios'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final produtos = await _repository.getProdutosByFuneraria(widget.funerariaId);
      setState(() {
        _produtos = produtos;
        _filtrarProdutos();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filtrarProdutos() {
    if (_categoriaFiltro == 'todos') {
      _produtosFiltrados = _produtos;
    } else {
      _produtosFiltrados = _produtos
          .where((p) => p.categoria == _categoriaFiltro)
          .toList();
    }
  }

  void _selecionarCategoria(String categoria) {
    setState(() {
      _categoriaFiltro = categoria;
      _filtrarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrinhoCount = ref.watch(carrinhoCountProvider);

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 76,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.funerariaNome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Produtos e Serviços',
              style: TextStyle(
                color: AppColors.softWhite,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.gold, size: 30),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 4),
            child: Stack(
              children: [
                IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarrinhoScreen(),
                    ),
                  );
                },
              ),
              if (carrinhoCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      carrinhoCount > 99 ? '99+' : carrinhoCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de categorias
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                final isSelected = _categoriaFiltro == categoria['id'];
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(categoria['nome']!),
                    selected: isSelected,
                    onSelected: (_) => _selecionarCategoria(categoria['id']!),
                    backgroundColor: AppColors.graphiteGray,
                    selectedColor: AppColors.gold,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.deepBlack : AppColors.softWhite,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              },
            ),
          ),

          // Lista de produtos
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  )
                : _errorMessage != null
                    ? Center(
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
                              Text(
                                'Erro ao carregar produtos',
                                style: const TextStyle(
                                  color: AppColors.softWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.softWhite,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadProdutos,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.deepBlack,
                                ),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _produtosFiltrados.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    color: AppColors.gold,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _categoriaFiltro == 'todos'
                                        ? 'Nenhum produto disponível'
                                        : 'Nenhum produto nesta categoria',
                                    style: const TextStyle(
                                      color: AppColors.softWhite,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadProdutos,
                            color: AppColors.gold,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _produtosFiltrados.length,
                              itemBuilder: (context, index) {
                                final produto = _produtosFiltrados[index];
                                return _buildProdutoCard(produto);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdutoCard(ProdutoModel produto) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdutoDetailScreen(produto: produto),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.graphiteGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: produto.destaque
                ? AppColors.gold.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.deepBlack.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: produto.imagem != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              produto.imagem!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderIcon(produto.categoria);
                              },
                            ),
                          )
                        : _buildPlaceholderIcon(produto.categoria),
                  ),
                ),
                if (produto.temPromocao)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${produto.percentualDesconto.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                if (produto.destaque)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: AppColors.deepBlack,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),

            // Informações do produto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.categoriaNome,
                      style: TextStyle(
                        color: AppColors.gold.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      produto.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    if (produto.temPromocao)
                      Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.softWhite.withValues(alpha: 0.5),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    Text(
                      'R\$ ${produto.precoFinal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(String categoria) {
    final imageUrl = _getFallbackImageUrl(categoria);

    return Image.network(
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
          size: 48,
        );
      },
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
}
