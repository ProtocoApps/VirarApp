import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/global_zoom_fab.dart';

class PartnerTermsOfUseScreen extends StatelessWidget {
  const PartnerTermsOfUseScreen({super.key});

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
                  'Termos de Uso para Empresas Parceiras – Plataforma VIRAR',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Estes Termos de Uso regulam o cadastro e a utilização da plataforma VIRAR, desenvolvida pela VIRAR Soluções Digitais Ltda., por empresas e profissionais prestadores de serviços.',
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ao se cadastrar na plataforma, a empresa ou profissional declara que leu, compreendeu e concorda com os presentes termos.',
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
                    'A plataforma VIRAR tem como finalidade conectar empresas e profissionais a usuários que necessitam de serviços relacionados ao ecossistema de apoio em situações de falecimento e pós-falecimento, incluindo serviços funerários, apoio à família, documentação, homenagens e serviços complementares.',
                    'A plataforma atua como intermediadora de visibilidade, organização de informações e contato, não sendo responsável pela execução direta dos serviços prestados.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '2. Cadastro da empresa',
                  paragraphs: [
                    'Para utilização da plataforma, a empresa ou profissional deverá:',
                  ],
                  bullets: [
                    'fornecer informações verdadeiras, completas e atualizadas;',
                    'informar corretamente os serviços oferecidos dentro do ecossistema da plataforma;',
                    'manter os dados atualizados sempre que houver alteração.',
                    'A empresa é integralmente responsável pelas informações cadastradas.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '3. Responsabilidade pelos serviços',
                  paragraphs: [
                    'A empresa ou profissional é responsável:',
                  ],
                  bullets: [
                    'pela qualidade dos serviços prestados;',
                    'pelo cumprimento das normas legais e regulatórias aplicáveis;',
                    'pelo atendimento ao usuário;',
                    'pelos valores cobrados.',
                    'A plataforma VIRAR não se responsabiliza pela execução dos serviços.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '4. Transparência de preços',
                  paragraphs: [
                    'A empresa compromete-se a:',
                  ],
                  bullets: [
                    'informar preços claros, acessíveis e atualizados na plataforma;',
                    'manter compatibilidade entre os valores divulgados no aplicativo e os praticados no atendimento;',
                    'informar previamente qualquer alteração de preço;',
                    'evitar cobranças inesperadas ou não informadas.',
                    'Não é permitido:',
                    'divulgar um preço no aplicativo e praticar valor diferente sem justificativa;',
                    'omitir custos adicionais relevantes;',
                    'alterar preços de forma abusiva no momento do atendimento;',
                    'se aproveitar da condição emocional do usuário para aumentar valores.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '5. Conduta ética',
                  paragraphs: [
                    'A empresa deverá atuar com:',
                  ],
                  bullets: [
                    'respeito aos usuários;',
                    'responsabilidade, considerando o contexto de fragilidade emocional;',
                    'transparência nas informações;',
                    'ética na prestação dos serviços.',
                    'É proibido:',
                    'fornecer informações falsas ou enganosas;',
                    'adotar práticas abusivas;',
                    'prejudicar outros prestadores dentro da plataforma;',
                    'utilizar a plataforma de forma indevida.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '6. Uso da plataforma',
                  paragraphs: [
                    'A empresa compromete-se a:',
                  ],
                  bullets: [
                    'utilizar a plataforma de forma adequada e responsável;',
                    'não interferir no funcionamento do sistema;',
                    'não utilizar a plataforma para fins ilícitos;',
                    'respeitar as diretrizes estabelecidas pela plataforma VIRAR.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '7. Avaliação e monitoramento',
                  paragraphs: [
                    'A plataforma poderá:',
                  ],
                  bullets: [
                    'monitorar o desempenho das empresas;',
                    'analisar denúncias ou reclamações de usuários;',
                    'solicitar atualização de informações;',
                    'avaliar a qualidade dos serviços com base na experiência do usuário.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '8. Penalidades',
                  paragraphs: [
                    'Em caso de descumprimento destes termos, a plataforma poderá:',
                  ],
                  bullets: [
                    'emitir advertência;',
                    'suspender temporariamente o cadastro;',
                    'remover definitivamente a empresa da plataforma.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '9. Proteção de dados',
                  paragraphs: [
                    'O tratamento de dados seguirá a Política de Privacidade da plataforma, em conformidade com a Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018).',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '10. Relação comercial',
                  paragraphs: [
                    'A utilização da plataforma poderá envolver planos, destaques ou condições comerciais específicas, que serão informadas previamente às empresas cadastradas.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '11. Alterações dos termos',
                  paragraphs: [
                    'A plataforma poderá atualizar estes termos a qualquer momento, sendo recomendada a consulta periódica.',
                  ],
                ),
                SizedBox(height: 20),
                _TermsBlock(
                  title: '12. Aceite',
                  paragraphs: [
                    'Ao se cadastrar na plataforma, a empresa declara estar ciente e de acordo com estes Termos de Uso.',
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
