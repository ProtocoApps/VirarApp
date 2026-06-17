import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';

class RegisterPrivacyPolicyScreen extends StatelessWidget {
  const RegisterPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Política de Privacidade',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.darkBrown.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.gold.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PolicyBlock(
                  title: '1. Coleta de dados',
                  paragraphs: [
                    'O aplicativo poderá coletar informações fornecidas pelo usuário durante a utilização da plataforma, tais como:',
                    'Esses dados são coletados com a finalidade de permitir o funcionamento adequado da plataforma e a conexão entre usuários e prestadores de serviços.',
                  ],
                  bullets: [
                    'nome e informações de contato;',
                    'localização (cidade ou região);',
                    'informações necessárias para organização de serviços relacionados ao ecossistema de apoio em situações de falecimento e pós-falecimento;',
                    'preferências de serviços selecionados no aplicativo.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '2. Uso das informações',
                  paragraphs: [
                    'As informações coletadas poderão ser utilizadas para:',
                  ],
                  bullets: [
                    'identificar as necessidades do usuário;',
                    'apresentar empresas e profissionais disponíveis na região;',
                    'facilitar o contato entre usuários e prestadores de serviços;',
                    'melhorar a experiência de uso da plataforma.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '3. Compartilhamento de dados',
                  paragraphs: [
                    'Os dados poderão ser compartilhados com empresas e profissionais cadastrados na plataforma apenas quando necessário para a prestação de serviços relacionados ao ecossistema da plataforma.',
                    'A plataforma VIRAR não comercializa dados pessoais.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '4. Armazenamento e segurança',
                  paragraphs: [
                    'A plataforma adotará medidas técnicas e administrativas para proteger os dados dos usuários contra acessos não autorizados, perda, alteração ou uso indevido.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '5. Direitos do usuário',
                  paragraphs: [
                    'O usuário poderá:',
                  ],
                  bullets: [
                    'solicitar acesso aos seus dados pessoais;',
                    'corrigir informações incorretas ou desatualizadas;',
                    'solicitar a exclusão de seus dados pessoais, observadas as obrigações legais e a necessidade de manutenção de informações essenciais para o funcionamento da plataforma.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '6. Dados sensíveis e contexto de uso',
                  paragraphs: [
                    'A plataforma reconhece que pode ser utilizada em momentos de fragilidade emocional. Por isso, compromete-se a tratar as informações com respeito, ética e responsabilidade.',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '7. Base legal',
                  paragraphs: [
                    'Esta política está em conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018).',
                  ],
                ),
                SizedBox(height: 20),
                _PolicyBlock(
                  title: '8. Aceite',
                  paragraphs: [
                    'Ao utilizar o aplicativo, o usuário declara estar ciente e de acordo com esta Política de Privacidade.',
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  '☑ Li e concordo com a Política de Privacidade',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyBlock extends StatelessWidget {
  const _PolicyBlock({
    required this.title,
    required this.paragraphs,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        ...paragraphs.map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              paragraph,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 14,
                height: 1.6,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        ...bullets.map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '• $bullet',
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 14,
                height: 1.6,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
