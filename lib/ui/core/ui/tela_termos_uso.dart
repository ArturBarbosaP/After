import 'package:flutter/material.dart';

class TelaTermosUso extends StatelessWidget {
  const TelaTermosUso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de uso'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Text(
            _termoTexto,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ),
    );
  }
}

const String _termoTexto = '''
Última atualização: 30 de agosto de 2026

1. ACEITAÇÃO DOS TERMOS

Ao criar uma conta ou utilizar este aplicativo ("App"), você concorda integralmente com estes Termos de Uso e com a nossa Política de Privacidade. Caso não concorde com qualquer disposição aqui prevista, não utilize o App.

2. DESCRIÇÃO DO SERVIÇO

O App permite que usuários encontrem festas e eventos próximos com base em geolocalização, salvem eventos de interesse, visualizem eventos que seus amigos pretendem frequentar e participem de comunidades com chat ao vivo vinculadas a cada evento, para interação em tempo real entre os participantes.

3. ELEGIBILIDADE

O uso do App é restrito a pessoas com 18 (dezoito) anos completos ou mais. Ao se cadastrar, você declara e garante possuir capacidade civil plena e que as informações fornecidas são verdadeiras, completas e atualizadas. Reservamo-nos o direito de solicitar comprovação de idade e de suspender ou encerrar contas de usuários que não atendam a este requisito.

4. CADASTRO E CONTA DE USUÁRIO

4.1. Para utilizar determinadas funcionalidades, é necessário criar uma conta, fornecendo informações precisas.
4.2. Você é responsável por manter a confidencialidade de sua senha e por todas as atividades realizadas em sua conta.
4.3. Você deve nos notificar imediatamente sobre qualquer uso não autorizado de sua conta.
4.4. Reservamo-nos o direito de recusar cadastro, suspender ou encerrar contas a nosso critério, especialmente em caso de violação destes Termos.

5. GEOLOCALIZAÇÃO

5.1. O funcionamento do App depende do acesso à localização do dispositivo para exibir eventos próximos.
5.2. Você pode revogar essa permissão a qualquer momento nas configurações do seu dispositivo, ciente de que isso pode limitar ou impedir o funcionamento de determinadas funcionalidades.
5.3. O compartilhamento de sua localização com outros usuários (quando aplicável) ocorre apenas nos termos descritos na Política de Privacidade.

6. COMUNIDADES E CHAT AO VIVO

6.1. Cada evento possui uma comunidade com chat ao vivo destinada à interação entre participantes.
6.2. É proibido utilizar o chat para:
a) Discurso de ódio, discriminação ou assédio;
b) Ameaças, violência ou incitação a atos ilícitos;
c) Divulgação de conteúdo ilegal, pornográfico ou que exponha menores de idade;
d) Spam, propaganda não autorizada ou golpes;
e) Compartilhamento de dados pessoais de terceiros sem consentimento.
6.3. Reservamo-nos o direito de remover mensagens, suspender ou banir usuários que violem estas regras, sem aviso prévio, a nosso exclusivo critério.
6.4. Não somos responsáveis pelo conteúdo publicado por usuários nos chats, mas nos comprometemos a agir mediante denúncias.

7. EVENTOS CRIADOS POR USUÁRIOS

7.1. Caso o App permita a criação ou divulgação de eventos por usuários, o criador é o único responsável pela veracidade das informações, pela legalidade do evento e pela segurança dos participantes.
7.2. Não nos responsabilizamos por danos, prejuízos ou incidentes ocorridos em eventos divulgados no App, incluindo cancelamentos, alterações de local/horário ou condutas de terceiros.
7.3. Recomendamos que os usuários adotem cautela ao comparecer a eventos e ao interagir com pessoas conhecidas por meio do App.

8. ASSINATURAS E COMPRAS DENTRO DO APP

8.1. O App oferece funcionalidades gratuitas e recursos pagos, disponíveis via assinatura e/ou compras avulsas dentro do aplicativo.
8.2. Os preços, formas de pagamento e condições de cada plano serão exibidos no momento da contratação, dentro do App ou da loja de aplicativos (App Store/Google Play).
8.3. As assinaturas podem ser renovadas automaticamente, salvo cancelamento pelo usuário antes do fim do período vigente, conforme as configurações da loja de aplicativos utilizada.
8.4. Reembolsos seguem as políticas da loja de aplicativos (Apple App Store ou Google Play Store) por meio da qual a compra foi realizada, além do disposto no Código de Defesa do Consumidor (Lei nº 8.078/1990), incluindo o direito de arrependimento em compras realizadas fora do estabelecimento comercial, quando aplicável.
8.5. Reservamo-nos o direito de alterar preços mediante aviso prévio, não afetando cobranças já realizadas.

9. PROPRIEDADE INTELECTUAL

9.1. Todos os direitos sobre o App, incluindo marca, layout, código-fonte, funcionalidades e conteúdo original, pertencem aos seus desenvolvedores/titulares, sendo protegidos pela Lei nº 9.610/1998 (Lei de Direitos Autorais) e pela Lei nº 9.609/1998 (Lei de Software).
9.2. É vedada a reprodução, engenharia reversa, distribuição ou exploração comercial do App sem autorização expressa.
9.3. O conteúdo gerado pelo usuário (mensagens, eventos criados, fotos, etc.) permanece de titularidade do usuário, que concede ao App uma licença não exclusiva para exibição e operação das funcionalidades relacionadas.

10. PRIVACIDADE E PROTEÇÃO DE DADOS

10.1. O tratamento de dados pessoais realizado pelo App observa a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 - LGPD).
10.2. Informações detalhadas sobre coleta, uso, armazenamento e compartilhamento de dados constam em nossa Política de Privacidade, parte integrante destes Termos.
10.3. Dados de geolocalização e mensagens de chat são tratados com base nas hipóteses legais previstas na LGPD, podendo ser utilizados para viabilizar as funcionalidades do App.

11. CONDUTAS PROIBIDAS

Além do disposto na cláusula 6.2, é proibido:
a) Utilizar o App para fins ilegais ou fraudulentos;
b) Tentar acessar áreas restritas do sistema, realizar engenharia reversa ou explorar vulnerabilidades;
c) Utilizar robôs, scripts automatizados ou qualquer meio artificial para interagir com o App;
d) Criar contas falsas ou se passar por terceiros;
e) Comercializar, revender ou sublicenciar o acesso ao App sem autorização.

12. LIMITAÇÃO DE RESPONSABILIDADE

12.1. O App é fornecido "como está", sem garantias de disponibilidade ininterrupta ou ausência de falhas.
12.2. Não nos responsabilizamos por danos indiretos, lucros cessantes ou prejuízos decorrentes do uso do App, de eventos divulgados por terceiros ou de interações entre usuários, salvo nos casos de dolo ou culpa grave, conforme a legislação brasileira aplicável.
12.3. Nada nestes Termos exclui direitos irrenunciáveis previstos no Código de Defesa do Consumidor.

13. SUSPENSÃO E ENCERRAMENTO

Podemos suspender ou encerrar, a qualquer momento, o acesso de usuários que violem estes Termos, sem prejuízo de outras medidas cabíveis. O usuário pode encerrar sua conta a qualquer momento através das configurações do App.

14. ALTERAÇÕES DESTES TERMOS

Podemos atualizar estes Termos periodicamente. Alterações relevantes serão comunicadas por meio do App ou por e-mail. O uso continuado após a alteração constitui aceitação dos novos Termos.

15. LEGISLAÇÃO APLICÁVEL E FORO

Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro do domicílio do usuário para dirimir eventuais controvérsias, conforme o Código de Defesa do Consumidor, ressalvada competência específica de foro diverso quando aplicável.

16. CONTATO

Em caso de dúvidas sobre estes Termos de Uso, entre em contato através de: 72300400@aluno.faculdadecotemig.br
''';