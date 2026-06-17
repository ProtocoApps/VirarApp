import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

class EntrepreneurRegisterScreen extends StatefulWidget {
  const EntrepreneurRegisterScreen({super.key});

  @override
  State<EntrepreneurRegisterScreen> createState() => _EntrepreneurRegisterScreenState();
}

class _EntrepreneurRegisterScreenState extends State<EntrepreneurRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _responsibleNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _companyNameController.dispose();
    _cnpjController.dispose();
    _responsibleNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o CNPJ';
    }
    
    // Remove formatação
    String cnpj = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    
    // Validação básica de CNPJ
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }
    
    return null;
  }

  String _formatCNPJ(String text) {
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (text.length >= 14) {
      return '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5, 8)}/${text.substring(8, 12)}-${text.substring(12, 14)}';
    } else if (text.length >= 12) {
      return '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5, 8)}/${text.substring(8, 12)}-';
    } else if (text.length >= 8) {
      return '${text.substring(0, 2)}.${text.substring(2, 5)}.${text.substring(5, 8)}/';
    } else if (text.length >= 5) {
      return '${text.substring(0, 2)}.${text.substring(2, 5)}.';
    } else if (text.length >= 2) {
      return '${text.substring(0, 2)}.';
    }
    
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const GlobalZoomFAB(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1614),
              const Color(0xFF2D2420),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.gold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: AppColors.gold,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cadastro Empresarial',
                      style: TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastre sua empresa para oferecer serviços',
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.8),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Nome da Empresa',
                        hint: 'Nome fantasia da empresa',
                        icon: Icons.business,
                        controller: _companyNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome da empresa';
                          }
                          if (value.length < 3) {
                            return 'Nome deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'CNPJ',
                        hint: '00.000.000/0000-00',
                        icon: Icons.description,
                        controller: _cnpjController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              return TextEditingValue(
                                text: _formatCNPJ(newValue.text),
                                selection: TextSelection.collapsed(
                                  offset: _formatCNPJ(newValue.text).length,
                                ),
                              );
                            },
                          ),
                        ],
                        validator: _validateCNPJ,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'Nome do Responsável',
                        hint: 'Nome completo do responsável',
                        icon: Icons.person_outline,
                        controller: _responsibleNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o nome do responsável';
                          }
                          if (value.length < 3) {
                            return 'Nome deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'E-mail Empresarial',
                        hint: 'empresa@exemplo.com',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite seu e-mail';
                          }
                          if (!value.contains('@')) {
                            return 'Digite um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'Telefone Comercial',
                        hint: '(00) 00000-0000',
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite seu telefone';
                          }
                          if (value.length < 14) {
                            return 'Digite um número válido';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'Senha de Acesso',
                        hint: 'Crie uma senha segura',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite uma senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      AuthTextField(
                        label: 'Confirmar Senha',
                        hint: 'Repita sua senha',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua senha';
                          }
                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Register Button
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading ? null : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                
                                final success = await authProvider.signUp(
                                  fullName: _responsibleNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text,
                                  document: _cnpjController.text.trim(),
                                );
                                
                                if (success) {
                                  Navigator.pushReplacementNamed(context, '/entrepreneur/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.errorMessage ?? 'Erro no cadastro'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: const Color(0xFF1A1614),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: authProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF1A1614),
                                    )
                                  : const Text(
                                      'Cadastrar Empresa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui cadastro?',
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/entrepreneur/login');
                      },
                      child: const Text(
                        'Faça login',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
