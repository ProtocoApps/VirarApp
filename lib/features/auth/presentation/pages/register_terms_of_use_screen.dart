import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';

class RegisterTermsOfUseScreen extends StatelessWidget {
  const RegisterTermsOfUseScreen({super.key});

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
          'Termos de Uso',
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
                Text(
                  'Termos de Uso da Plataforma VIRAR',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Estes Termos de Uso regulam o acesso e a utilização da plataforma VIRAR, desenvolvida pela VIRAR Soluções Digitais Ltda.',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ao utilizar o aplicativo, o usuário declara que leu, compreendeu e concorda com os presentes termos.',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 24),
                _TermsBlock(
                  title: '1. Objeto da plataforma',
                  paragraphs: [
                    'A plataforma VIRAR tem como objetivo facilitar o acesso a informações, empresas e profissionais do ecossistema de apoio em situações de falecimento e pós-falecimento, conectando usuários a prestadores de serviços relacionados à despedida, apoio à família, documentação, homenagens e demandas posteriores.',
                    'A plataforma atua como intermediadora de informações, organização e contato, não sendo responsável pela execução direta dos serviços contratados.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '2. Cadastro e uso',
                  paragraphs: [
                    'O uso da plataforma pode exigir o fornecimento de informações básicas, que deverão ser verdadeiras, atualizadas e completas.',
                    'O usuário é responsável pelas informações fornecidas e pelo uso adequado da plataforma.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '3. Funcionamento do serviço',
                  paragraphs: [
                    'A plataforma oferece:',
                  ],
                  bullets: [
                    'assistente digital para orientação do usuário;',
                    'localização de empresas e profissionais por região;',
                    'visualização e comparação de serviços disponíveis no ecossistema da plataforma;',
                    'contato com prestadores cadastrados.',
                    'A escolha e contratação dos serviços são de responsabilidade exclusiva do usuário.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '4. Responsabilidade da plataforma',
                  paragraphs: [
                    'A VIRAR não se responsabiliza:',
                  ],
                  bullets: [
                    'pela execução dos serviços prestados por terceiros;',
                    'pelos valores cobrados pelas empresas;',
                    'por eventuais falhas na prestação dos serviços oferecidos dentro do ecossistema da plataforma;',
                    'por negociações realizadas diretamente entre usuário e prestador.',
                    'A plataforma compromete-se a disponibilizar informações com clareza, mas não garante a ausência de erros ou omissões.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '5. Responsabilidade dos prestadores',
                  paragraphs: [
                    'As empresas e profissionais integrantes do ecossistema da plataforma são responsáveis:',
                  ],
                  bullets: [
                    'pela veracidade das informações fornecidas;',
                    'pela qualidade dos serviços prestados;',
                    'pelo cumprimento das normas legais aplicáveis.',
                    'A plataforma poderá suspender ou remover cadastros que descumpram estas regras.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '6. Uso adequado da plataforma',
                  paragraphs: [
                    'O usuário compromete-se a utilizar a plataforma de forma ética, sendo proibido:',
                  ],
                  bullets: [
                    'fornecer informações falsas;',
                    'utilizar a plataforma para fins ilícitos;',
                    'prejudicar o funcionamento do sistema ou outros usuários.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '7. Proteção de dados',
                  paragraphs: [
                    'O tratamento de dados pessoais segue a Política de Privacidade da plataforma, em conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018).',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '8. Situações de vulnerabilidade',
                  paragraphs: [
                    'A plataforma reconhece que pode ser utilizada em momentos de fragilidade emocional, buscando oferecer informações de forma respeitosa, ética e responsável.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '9. Transparência de preços e conduta dos prestadores',
                  paragraphs: [
                    'As empresas e profissionais integrantes do ecossistema da plataforma comprometem-se a atuar com ética, transparência e responsabilidade.',
                    'Devem:',
                  ],
                  bullets: [
                    'fornecer informações claras, verdadeiras e atualizadas;',
                    'apresentar valores compatíveis com os informados na plataforma;',
                    'evitar alterações injustificadas de preços no atendimento presencial;',
                    'informar previamente qualquer alteração de valores;',
                    'respeitar o usuário em momento de sensibilidade emocional.',
                    'Não é permitido:',
                    'divulgar preços no aplicativo e praticar valores diferentes sem justificativa;',
                    'omitir informações relevantes;',
                    'adotar práticas abusivas ou enganosas;',
                    'se aproveitar da vulnerabilidade do usuário.',
                    'Em caso de descumprimento, a plataforma poderá:',
                    'emitir advertência;',
                    'suspender o cadastro;',
                    'remover definitivamente o prestador.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '10. Alterações dos termos',
                  paragraphs: [
                    'A plataforma poderá atualizar estes Termos de Uso a qualquer momento, sendo recomendada a consulta periódica.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '11. Aceite',
                  paragraphs: [
                    'Ao utilizar o aplicativo, o usuário declara estar ciente e de acordo com estes Termos de Uso.',
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

class _TermsBlock extends StatelessWidget {
  const _TermsBlock({
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
