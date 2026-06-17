import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';
import '../../data/repositories/produtos_repository.dart';
import '../providers/carrinho_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List itens;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.itens,
    required this.total,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _repository = ProdutosRepository();
  final _observacoesController = TextEditingController();
  
  String _formaPagamento = 'pix';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _formasPagamento = [
    {
      'id': 'pix',
      'nome': 'PIX',
      'icone': Icons.qr_code_2,
      'descricao': 'Pagamento instantâneo',
    },
    {
      'id': 'cartao_credito',
      'nome': 'Cartão de Crédito',
      'icone': Icons.credit_card,
      'descricao': 'Parcelamento disponível',
    },
    {
      'id': 'cartao_debito',
      'nome': 'Cartão de Débito',
      'icone': Icons.credit_card,
      'descricao': 'Débito em conta',
    },
    {
      'id': 'boleto',
      'nome': 'Boleto Bancário',
      'icone': Icons.receipt_long,
      'descricao': 'Vencimento em 3 dias',
    },
    {
      'id': 'dinheiro',
      'nome': 'Dinheiro',
      'icone': Icons.attach_money,
      'descricao': 'Pagamento na entrega',
    },
  ];

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _finalizarPedido() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Pegar a funerária do primeiro item (assumindo que todos são da mesma funerária)
      final funerariaId = widget.itens.first.produto.funerariaId;

      // Criar pedido
      final pedidoId = await _repository.criarPedido(
        funerariaId: funerariaId,
        total: widget.total,
        formaPagamento: _formaPagamento,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );

      if (mounted) {
        HapticFeedback.heavyImpact();
        
        // Mostrar diálogo de sucesso
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.graphiteGray,
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text(
                  'Pedido Realizado!',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seu pedido #$pedidoId foi realizado com sucesso!',
                  style: const TextStyle(
                    color: AppColors.softWhite,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A funerária entrará em contato em breve para confirmar os detalhes.',
                  style: TextStyle(
                    color: AppColors.softWhite.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Voltar para a tela inicial
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao finalizar pedido: $e',
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
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Finalizar Compra',
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumo do pedido
                  const Text(
                    'Resumo do Pedido',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.graphiteGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ...widget.itens.map((item) {
                          final produto = item.produto;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantidade}x ${produto.nome}',
                                    style: const TextStyle(
                                      color: AppColors.softWhite,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Text(
                                  'R\$ ${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const Divider(color: AppColors.gold),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: AppColors.softWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'R\$ ${widget.total.toStringAsFixed(2)}',
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
                  ),

                  const SizedBox(height: 24),

                  // Forma de pagamento
                  const Text(
                    'Forma de Pagamento',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._formasPagamento.map((forma) {
                    final isSelected = _formaPagamento == forma['id'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _formaPagamento = forma['id'] as String;
                        });
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.graphiteGray,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              forma['icone'] as IconData,
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.softWhite,
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    forma['nome'] as String,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.gold
                                          : AppColors.softWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    forma['descricao'] as String,
                                    style: TextStyle(
                                      color: AppColors.softWhite.withValues(alpha: 0.7),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.gold,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Observações
                  const Text(
                    'Observações (Opcional)',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _observacoesController,
                    maxLines: 4,
                    maxLength: 500,
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Adicione informações adicionais sobre o pedido...',
                      hintStyle: TextStyle(
                        color: AppColors.softWhite.withValues(alpha: 0.5),
                        fontFamily: 'Poppins',
                      ),
                      filled: true,
                      fillColor: AppColors.graphiteGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.gold,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão finalizar
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
                  onPressed: _isProcessing ? null : _finalizarPedido,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.deepBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
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
                      : const Text(
                          'Confirmar Pedido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
