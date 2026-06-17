import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/localization/app_language.dart';
import '../../../../../core/providers/app_language_provider.dart';
import '../providers/auth_provider.dart';
import '../../../../../core/services/profile_service.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import 'partner_terms_of_use_screen.dart';
import 'register_privacy_policy_screen.dart';
import 'register_terms_of_use_screen.dart';

// Custom TextInputFormatter for phone
class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    
    if (digits.length <= 2) {
      formatted = digits;
    } else if (digits.length <= 6) {
      formatted = '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      formatted = '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else {
      formatted = '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Custom TextInputFormatter for document (CPF/CNPJ)
class DocumentFormatter extends TextInputFormatter {
  final bool isCnpj;
  
  DocumentFormatter({this.isCnpj = false});
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    
    if (isCnpj) {
      // CNPJ format: 00.000.000/0000-00
      if (digits.length <= 2) {
        formatted = digits;
      } else if (digits.length <= 5) {
        formatted = '${digits.substring(0, 2)}.${digits.substring(2)}';
      } else if (digits.length <= 8) {
        formatted = '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5)}';
      } else if (digits.length <= 12) {
        formatted = '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8)}';
      } else {
        formatted = '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12, 14)}';
      }
    } else {
      // CPF format: 000.000.000-00
      if (digits.length <= 3) {
        formatted = digits;
      } else if (digits.length <= 6) {
        formatted = '${digits.substring(0, 3)}.${digits.substring(3)}';
      } else if (digits.length <= 9) {
        formatted = '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6)}';
      } else {
        formatted = '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyController = TextEditingController();
  final _documentController = TextEditingController();
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _districtController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _countryController = TextEditingController(text: 'Brasil');
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final TapGestureRecognizer _termsRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _privacyRecognizer = TapGestureRecognizer();

  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFetchingCep = false;
  String? _lastFetchedCep;

  @override
  void initState() {
    super.initState();
    final controllers = [
      _nameController,
      _emailController,
      _phoneController,
      _passwordController,
      _confirmPasswordController,
      _companyController,
      _documentController,
      _cepController,
      _addressController,
      _districtController,
      _numberController,
      _complementController,
      _cityController,
      _regionController,
    ];
    for (final controller in controllers) {
      controller.addListener(_refreshFormState);
      controller.addListener(_clearAuthError);
    }
    _termsRecognizer.onTap = () {
      HapticFeedback.lightImpact();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterTermsOfUseScreen(),
        ),
      );
    };
    _privacyRecognizer.onTap = () {
      HapticFeedback.lightImpact();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPrivacyPolicyScreen(),
        ),
      );
    };
  }

  void _clearAuthError() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.errorMessage != null) {
      authProvider.clearError();
    }
  }

  void _refreshFormState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _announce(String message) {
    SemanticsService.announce(message, Directionality.of(context));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyController.dispose();
    _documentController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLibrasSelected =
        context.watch<AppLanguageProvider>().currentLanguage == AppLanguage.libras;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: () {
            HapticFeedback.lightImpact();
            _announce('Voltando para a tela anterior');
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'VIRAR',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

              // Brand Logo
              Center(
                child: Column(
                  children: [
                    Semantics(
                      image: true,
                      label: 'Logo do aplicativo Virar',
                      child: SizedBox(
                        width: 160,
                        height: 96,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'VIRAR',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              
              // Title Section with Icon
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: AppColors.gold,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Crie sua conta',
                          style: TextStyle(
                            color: AppColors.softWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Conectamos você a serviços, apoio e cuidado com respeito e agilidade.',
                          style: TextStyle(
                            color: AppColors.lightGray.withOpacity(0.8),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Form Fields
              Column(
                children: [
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Nome completo em Libras',
                    gifAssetPath: 'assets/images/NOME COMPLETO.gif',
                    child: _buildTextFormField(
                      controller: _nameController,
                      label: 'Nome completo',
                      hint: 'Digite seu nome completo',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu nome';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'E-mail em Libras',
                    gifAssetPath: 'assets/images/E-MAIL.gif',
                    child: _buildTextFormField(
                      controller: _emailController,
                      label: 'E-mail',
                      hint: 'exemplo@email.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Celular em Libras',
                    gifAssetPath: 'assets/images/numero CELULAR.gif',
                    child: _buildTextFormField(
                      controller: _phoneController,
                      label: 'Celular',
                      hint: '(00) 00000-0000',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneFormatter(),
                      ],
                      validator: _validatePhone,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // CPF
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'CPF em Libras',
                    gifAssetPath: 'assets/images/CPF.gif',
                    child: _buildTextFormField(
                      controller: _documentController,
                      label: 'CPF',
                      hint: '000.000.000-00',
                      icon: Icons.description,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DocumentFormatter(),
                      ],
                      validator: _validateDocument,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'CEP em Libras',
                    gifAssetPath: 'assets/images/CEP.gif',
                    child: _buildTextFormField(
                      controller: _cepController,
                      label: 'CEP',
                      hint: '00000-000',
                      icon: Icons.markunread_mailbox_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
                          String formatted = digits;
                          if (digits.length > 5) {
                            formatted = '${digits.substring(0, 5)}-${digits.substring(5)}';
                          }
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: formatted.length),
                          );
                        }),
                      ],
                      onChanged: _handleCepChanged,
                      validator: _validateCep,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Address
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Endereço em Libras',
                    gifAssetPath: 'assets/images/ENDEREÇO COMPLETO.gif',
                    child: _buildTextFormField(
                      controller: _addressController,
                      label: 'Endereço completo',
                      hint: 'Rua / Avenida',
                      icon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o endereço completo';
                        }
                        return null;
                      },
                      suffix: _isFetchingCep
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Bairro em Libras',
                    gifAssetPath: 'assets/images/BAIRRO.gif',
                    child: _buildTextFormField(
                      controller: _districtController,
                      label: 'Bairro',
                      hint: 'Seu bairro',
                      icon: Icons.map,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite o bairro';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildFieldWithLibrasSupport(
                          isLibrasSelected: isLibrasSelected,
                          gifTitle: 'Número em Libras',
                          gifAssetPath: 'assets/images/NÚMERO.gif',
                          child: _buildTextFormField(
                            controller: _numberController,
                            label: 'Número',
                            hint: '123',
                            icon: Icons.pin_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o número';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFieldWithLibrasSupport(
                          isLibrasSelected: isLibrasSelected,
                          gifTitle: 'Complemento em Libras',
                          gifAssetPath: 'assets/images/COMPLEMENTO.gif',
                          child: _buildTextFormField(
                            controller: _complementController,
                            label: 'Complemento',
                            hint: 'Apto / Sala',
                            icon: Icons.add_business_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Location Fields Row
                  Row(
                    children: [
                      // City
                      Expanded(
                        child: _buildFieldWithLibrasSupport(
                          isLibrasSelected: isLibrasSelected,
                          gifTitle: 'Cidade em Libras',
                          gifAssetPath: 'assets/images/CIDADE.gif',
                          child: _buildTextFormField(
                            controller: _cityController,
                            label: 'Cidade',
                            hint: 'Sua cidade',
                            icon: Icons.location_city,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite sua cidade';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFieldWithLibrasSupport(
                          isLibrasSelected: isLibrasSelected,
                          gifTitle: 'Estado em Libras',
                          gifAssetPath: 'assets/images/ESTADO(UF).gif',
                          child: _buildTextFormField(
                            controller: _regionController,
                            label: 'Estado (UF)',
                            hint: 'SP',
                            icon: Icons.map_outlined,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                return TextEditingValue(
                                  text: newValue.text.toUpperCase(),
                                  selection: newValue.selection,
                                );
                              }),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o estado';
                              }
                              if (value.trim().length != 2) {
                                return 'Use a UF';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Criar senha em Libras',
                    gifAssetPath: 'assets/images/CRIAR SENHA.gif',
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontFamily: 'Poppins',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, crie uma senha';
                        }
                        if (value.length < 8) {
                          return 'A senha deve ter pelo menos 8 caracteres';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'A senha deve conter pelo menos um número';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Criar senha',
                        labelStyle: const TextStyle(
                          color: AppColors.softWhite,
                          fontFamily: 'Poppins',
                        ),
                        hintText: 'Mínimo de 8 caracteres e 1 número',
                        hintStyle: TextStyle(
                          color: AppColors.lightGray.withOpacity(0.6),
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.gold,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.gold,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.darkBrown,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.gold, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Confirmar senha em Libras',
                    gifAssetPath: 'assets/images/CONFIRMAR SENHA.gif',
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontFamily: 'Poppins',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha';
                        }
                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        labelStyle: const TextStyle(
                          color: AppColors.softWhite,
                          fontFamily: 'Poppins',
                        ),
                        hintText: 'Repita sua senha',
                        hintStyle: TextStyle(
                          color: AppColors.lightGray.withOpacity(0.6),
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.gold,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.gold,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.darkBrown,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.gold, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              
              // Terms Checkbox
              _buildFieldWithLibrasSupport(
                isLibrasSelected: isLibrasSelected,
                gifTitle: 'Acordo em Libras',
                gifAssetPath: 'assets/images/LI E CONCORDO COM OS TERMOS DE USO.gif',
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _agreeToTerms = !_agreeToTerms;
                    });
                    _announce(
                      _agreeToTerms
                          ? 'Termos de uso aceitos'
                          : 'Termos de uso desmarcados',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _agreeToTerms ? AppColors.gold.withOpacity(0.6) : AppColors.gold.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _agreeToTerms ? AppColors.gold : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _agreeToTerms ? AppColors.gold : AppColors.softWhite.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: _agreeToTerms
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.deepBlack,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: AppColors.lightGray.withOpacity(0.9),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'Li e concordo com os '),
                                TextSpan(
                                  text: 'Termos de Uso',
                                  recognizer: _termsRecognizer,
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' e a '),
                                TextSpan(
                                  text: 'Política de Privacidade',
                                  recognizer: _privacyRecognizer,
                                  style: const TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Register Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Semantics(
                    button: true,
                    label: 'Criar conta',
                    hint: 'Toque para enviar seu cadastro',
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading || !_isSubmitEnabled
                            ? null
                            : () {
                                HapticFeedback.mediumImpact();
                                _handleRegister();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: authProvider.isLoading || !_isSubmitEnabled
                              ? AppColors.gold.withOpacity(0.6)
                              : AppColors.gold,
                          foregroundColor: AppColors.deepBlack,
                          elevation: 8,
                          shadowColor: AppColors.gold.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepBlack),
                                ),
                              )
                            : const Text(
                                'Criar conta',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já possui uma conta? ',
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Entre aqui',
                    hint: 'Toque para voltar para a tela de login',
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _announce('Abrindo tela de login');
                        Navigator.pop(context);
                      },
                    child: const Text(
                      'Entre aqui',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    ),
                  ),
                ],
              ),
              
              // Error Message
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage != null) {
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildFieldWithLibrasSupport({
    required bool isLibrasSelected,
    required Widget child,
    required String gifTitle,
    required String gifAssetPath,
  }) {
    if (!isLibrasSelected) {
      return child;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: child),
        const SizedBox(width: 12),
        _buildLibrasGifButton(
          title: gifTitle,
          assetPath: gifAssetPath,
        ),
      ],
    );
  }

  Widget _buildLibrasGifButton({
    required String title,
    required String assetPath,
  }) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLibrasVideo(context, title, assetPath),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.touch_app,
                color: AppColors.gold,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLibrasVideo(BuildContext context, String title, String assetPath) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1614),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.softWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: AppColors.gold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    Widget? suffix,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        _refreshFormState();
        onChanged?.call(value);
      },
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.softWhite,
        fontFamily: 'Poppins',
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.softWhite,
          fontFamily: 'Poppins',
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.lightGray.withOpacity(0.6),
          fontFamily: 'Poppins',
        ),
        prefixIcon: Semantics(
          label: 'Ícone do campo $label',
          child: Icon(
            icon,
            color: AppColors.gold,
          ),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.darkBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Phone validator
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu celular';
    }
    
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }

  String? _validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o CEP';
    }

    final digits = _sanitizeCep(value);
    if (!RegExp(r'^[0-9]{8}$').hasMatch(digits)) {
      return 'CEP inválido';
    }

    return null;
  }

  String _sanitizeCep(String value) {
    return value.replaceAll(RegExp(r'[-\s]'), '').replaceAll(RegExp(r'\D'), '');
  }

  Future<void> _handleCepChanged(String value) async {
    final sanitizedCep = _sanitizeCep(value);

    if (!RegExp(r'^[0-9]{8}$').hasMatch(sanitizedCep)) {
      return;
    }

    if (_lastFetchedCep == sanitizedCep || _isFetchingCep) {
      return;
    }

    await _fetchAddressByCep(sanitizedCep);
  }

  Future<void> _fetchAddressByCep(String cep) async {
    setState(() {
      _isFetchingCep = true;
    });

    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      final data = response.data;

      if (data is! Map || data['erro'] == true) {
        _lastFetchedCep = null;
        if (mounted) {
          _announce('CEP não encontrado');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('CEP não encontrado'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      _addressController.text = (data['logradouro'] ?? '').toString();
      _districtController.text = (data['bairro'] ?? '').toString();
      _cityController.text = (data['localidade'] ?? '').toString();
      _regionController.text = (data['uf'] ?? '').toString();

      if (_complementController.text.trim().isEmpty) {
        _complementController.text = (data['complemento'] ?? '').toString();
      }

      _lastFetchedCep = (data['cep'] ?? cep).toString().replaceAll(RegExp(r'\D'), '');
      _refreshFormState();
      _announce('Endereço preenchido automaticamente pelo CEP');
    } catch (_) {
      _lastFetchedCep = null;
      if (mounted) {
        _announce('Erro ao consultar CEP');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao consultar CEP'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingCep = false;
        });
      }
    }
  }

  // CNPJ/CPF validator
  String? _validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o documento';
    }
    
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 11) {
      return 'CPF inválido';
    }

    if (_validateCPF(digits) == false) {
      return 'CPF inválido';
    }
    
    return null;
  }

  // Basic CPF validation
  bool _validateCPF(String cpf) {
    if (cpf.length != 11) return false;
    
    // Check if all digits are the same
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;
    
    // Calculate first verification digit
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int remainder = sum % 11;
    int digit1 = remainder < 2 ? 0 : 11 - remainder;
    
    if (digit1 != int.parse(cpf[9])) return false;
    
    // Calculate second verification digit
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    remainder = sum % 11;
    int digit2 = remainder < 2 ? 0 : 11 - remainder;
    
    return digit2 == int.parse(cpf[10]);
  }

  // Basic CNPJ validation
  bool _validateCNPJ(String cnpj) {
    if (cnpj.length != 14) return false;
    
    // Check if all digits are the same
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) return false;
    
    // Calculate first verification digit
    List<int> weights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weights[i];
    }
    int remainder = sum % 11;
    int digit1 = remainder < 2 ? 0 : 11 - remainder;
    
    if (digit1 != int.parse(cnpj[12])) return false;
    
    // Calculate second verification digit
    weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weights[i];
    }
    remainder = sum % 11;
    int digit2 = remainder < 2 ? 0 : 11 - remainder;
    
    return digit2 == int.parse(cnpj[13]);
  }

  bool get _isSubmitEnabled {
    final hasBaseFields =
        _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _documentController.text.trim().isNotEmpty &&
        _cepController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty &&
        _districtController.text.trim().isNotEmpty &&
        _numberController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _regionController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _agreeToTerms;

    return hasBaseFields;
  }

  void _showLinkPlaceholder(String title) {
    _announce('$title em breve');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title será vinculado quando você me enviar a URL final.'),
        backgroundColor: AppColors.graphiteGray,
      ),
    );
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      _announce('Existem campos inválidos no formulário');
      return;
    }

    if (!_agreeToTerms) {
      _announce('Você precisa aceitar os termos de uso');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos de uso'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.signUp(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      document: _documentController.text.trim(),
      address: _buildFullAddress(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      region: _regionController.text.trim(),
    );

    if (success) {
      await ProfileService().saveProfileType(UserProfileType.citizen);
      _announce('Cadastro realizado com sucesso');
      
      if (mounted) {
        final isLibras = Provider.of<AppLanguageProvider>(context, listen: false).currentLanguage == AppLanguage.libras;
        Navigator.pushReplacementNamed(context, isLibras ? '/accessibility/home' : '/citizen/home');
      }
    } else {
      _announce(authProvider.errorMessage ?? 'Não foi possível concluir o cadastro');
    }
  }

  String _buildFullAddress() {
    final parts = [
      _addressController.text.trim(),
      _districtController.text.trim(),
      'Nº ${_numberController.text.trim()}',
      if (_complementController.text.trim().isNotEmpty) _complementController.text.trim(),
      'CEP ${_cepController.text.trim()}',
    ];

    return parts.join(', ');
  }
}
