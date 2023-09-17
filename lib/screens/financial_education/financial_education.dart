import 'package:flutter/material.dart';
import 'package:iboss/components/financial_education_alert.dart';

class FinancialEducation extends StatefulWidget {
  const FinancialEducation({Key? key}) : super(key: key);

  @override
  State<FinancialEducation> createState() => _FinancialEducationState();
}

class _FinancialEducationState extends State<FinancialEducation> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Educação Financeira'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Empreendimento',
              ),
              Tab(
                text: 'Pessoal',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "Pró-labore",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(
                        context,
                        "Pró-labore",
                        "O pró-labore é uma remuneração que um sócio ou proprietário"
                            " de uma empresa recebe por seu trabalho na empresa. "
                            "É um valor retirado mensalmente ou periodicamente para "
                            "compensar o trabalho e a administração do negócio. É importante"
                            " diferenciar o pró-labore dos lucros da empresa, pois o pró-labore"
                            " é uma retirada que não está diretamente relacionada aos resultados "
                            "financeiros da empresa, enquanto os lucros são distribuídos aos "
                            "sócios de acordo com o desempenho do negócio. É uma maneira de o "
                            "proprietário receber um salário pelos seus esforços, assim como "
                            "qualquer funcionário, mesmo que a empresa não tenha lucro.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Orçamento Empresarial",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(
                        context,
                        "Orçamento Empresarial",
                        "Um orçamento é uma estimativa financeira que ajuda a planejar e controlar"
                            " os gastos do seu empreendimento. Para fazer um orçamento simples como trabalhador independente,"
                            " siga estes passos:\n\n- Liste todas as suas despesas mensais, como aluguel,"
                            " contas de serviços públicos, materiais, etc.\n\n- Registre todas as suas fontes de renda,"
                            " como vendas ou serviços prestados.\n\n- Defina metas financeiras,"
                            " como economizar uma porcentagem do lucro ou reinvestir em seu negócio.\n\n- Monitore "
                            " regularmente seu orçamento para ajustar conforme necessário.\n\nIsso ajudará você"
                            " a manter suas finanças sob controle e a tomar decisões informadas para o sucesso"
                            " do seu negócio.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Gestão de Fluxo de Caixa",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(
                        context,
                        "Gestão de Fluxo de Caixa",
                        "Fluxo de caixa é"
                            " um registro das entradas e saídas de dinheiro no seu negócio ao longo do tempo."
                            " Ele mostra quanto dinheiro você recebe (Faturamento) e gasta (Despesas) em"
                            " um período específico, como um mês. Isso ajuda a acompanhar de onde "
                            "vem e para onde vai o dinheiro, permitindo uma gestão financeira eficiente "
                            "e a tomada de decisões informadas sobre seu empreendimento.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Contabilidade Básica",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(
                        context,
                        "Contabilidade Básica",
                        "A contabilidade básica "
                            "é um sistema de registro e acompanhamento das finanças do seu negócio. "
                            "Ela envolve registrar todas as transações financeiras, como receitas e despesas, "
                            "para que você possa entender o desempenho financeiro do seu empreendimento. "
                            "Isso ajuda na tomada de decisões, no pagamento de impostos e "
                            " gestão eficaz do dinheiro. Em resumo, a contabilidade básica ajuda você a "
                            "manter o controle do dinheiro que entra e sai do seu negócio.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Impostos",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(
                        context,
                        "Impostos",
                        "- Declaração de Imposto de Renda\n- "
                            "Carnê-Leão\n- "
                            "Deduções\n- "
                            "Alíquotas Progressivas\n- "
                            "Retenção na Fonte \n");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Investimentos no Negócio",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Investimentos no Negócio", "Investir no seu negócio como"
                        " trabalhador independente envolve alocar recursos financeiros para "
                        "melhorar e expandir suas operações.\n\n- Identifique as Necessidades: "
                        "Primeiro, identifique as áreas do seu negócio que podem se beneficiar de investimento,"
                        " como compra de equipamentos melhores, marketing, treinamento, "
                        "ou expansão de serviços.\n\n- Priorize Investimentos: Classifique as necessidades"
                        " de investimento por prioridade e impacto no seu negócio. "
                        "Comece com os mais importantes.\n\n- Execute com Cuidado: Ao investir, "
                        "certifique-se de que está gastando seu dinheiro de forma eficaz e monitorando os "
                        "resultados. Acompanhe como os investimentos afetam o desempenho do seu negócio.\n\n"
                        "Lembre-se de que investir no seu negócio é uma estratégia importante para "
                        "o crescimento, mas também envolve riscos. Certifique-se de planejar cuidadosamente"
                        " e buscar orientação, se necessário, para tomar decisões informadas e bem-sucedidas.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Planejamento Financeiro a Longo Prazo",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Planejamento Financeiro a Longo Prazo",
                        "- Estabeleça Metas Financeiras\n\n- Avalie sua Situação Atual\n\n- "
                            "Crie um Orçamento\n\n- Economize Regularmente\n\n- Reduza"
                            " Dívidas\n\n- Diversifique "
                            "Investimentos\n\n- Reveja e Ajuste Regularmente\n\n- "
                            "Prepare-se para Emergências\n\n- Pense na Aposentadoria");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Crédito e Financiamento",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Crédito e Financiamento", "- Crédito: É uma "
                        "quantia de dinheiro que um banco ou instituição financeira empresta "
                        "a você com a expectativa de que você o pague de volta em parcelas, "
                        "geralmente com juros.\n\n- Financiamento: É um tipo específico de "
                        "crédito usado para adquirir bens de alto valor, como um carro, casa "
                        "ou equipamentos comerciais. Você paga pelo bem em parcelas ao longo "
                        "do tempo, incluindo juros.\n\n- Juros: É a taxa extra que você paga "
                        "ao credor pelo uso do dinheiro emprestado. Os juros aumentam o custo "
                        "total do empréstimo ou financiamento.\n\n- Garantia: Alguns empréstimos "
                        "ou financiamentos podem exigir um ativo como garantia.\n\n- Taxa de Juros: "
                        "É a porcentagem que você paga anualmente sobre o valor emprestado.");
                  },
                ),
              ],
            ),
            ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "Orçamento Pessoal",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Orçamento Pessoal", "Um orçamento pessoal é "
                        "um plano que você cria para gerenciar seu dinheiro. Ele envolve "
                        "listar suas rendas (dinheiro que entra) e gastos (dinheiro que sai) para "
                        "um período de tempo, geralmente mensal. O objetivo é garantir que você"
                        " gaste seu dinheiro de forma consciente, economize e alcance seus objetivos"
                        " financeiros. Um orçamento ajuda a controlar seus gastos, evitar dívidas "
                        "desnecessárias e garantir que seu dinheiro seja usado da melhor maneira "
                        "possível para atender às suas necessidades e metas financeiras.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Gestão de Dívidas Pessoais",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Gestão de Dívidas Pessoais", "A "
                        "gestão de dívidas pessoais envolve tomar medidas para controlar e "
                        "pagar suas dívidas de forma eficaz. Aqui estão os passos simples:\n\n- "
                        "Priorize as dívidas: Classifique as dívidas com base nas taxas de juros. "
                        "Dê prioridade às dívidas com as taxas mais altas, pois elas custam mais ao "
                        "longo do tempo.\n\n- Reduza gastos: Identifique áreas onde pode cortar "
                        "gastos para liberar mais dinheiro para pagar as dívidas.\n\n- Pague"
                        " mais que o mínimo: Sempre que possível, faça pagamentos maiores"
                        " do que o mínimo exigido em suas dívidas de maior interesse. Isso"
                        " acelera o pagamento e economiza dinheiro.\n\n- Evite contrair mais"
                        " dívidas: Enquanto estiver pagando suas dívidas, evite contrair novas,"
                        " a menos que seja estritamente necessário.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Investimentos Pessoais",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Investimentos Pessoais", "- Poupança: Guardar dinheiro "
                        "em uma conta poupança ou conta corrente para ganhar juros, embora geralmente com"
                        " taxas baixas.\n- Ações: Comprar ações de empresas na bolsa de valores, com a"
                        " esperança de que seu valor aumente e você possa vender com lucro.\n- Títulos: "
                        "Investir em títulos do governo ou corporativos, que pagam juros ao longo do tempo."
                        "\n- Fundos de Investimento: Colocar seu dinheiro em fundos geridos por profissionais "
                        "que investem em ações, títulos ou outros ativos.\n- Imóveis: Comprar propriedades"
                        " para alugar ou vender com lucro.\n- Previdência Privada: Contribuir para planos"
                        " de previdência privada para garantir uma renda futura na aposentadoria.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Planejamento para a Aposentadoria",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Planejamento para a aposentadoria", "-Defina suas"
                        " metas de aposentadoria: Determine quanto dinheiro você deseja ter "
                        "disponível quando se aposentar, considerando seu estilo de vida desejado."
                        "\n- Calcule suas necessidades financeiras: Avalie suas despesas estimadas "
                        "na aposentadoria, incluindo moradia, alimentação, saúde e lazer.\n- Economize"
                        " consistentemente: Comece a economizar regularmente, de preferência desde cedo. "
                        "Pode ser através de um plano de previdência privada, investimentos ou outras"
                        " formas de poupança.\n- Diversifique seus investimentos: Distribua seu "
                        "dinheiro em diferentes tipos de investimentos para reduzir riscos.\n- "
                        "Reduza dívidas: Trabalhe para pagar dívidas antes da aposentadoria, para"
                        " não comprometer sua renda.\n- Estime sua renda na aposentadoria: Calcule"
                        " sua previdência social e outros recursos que você espera receber na aposentadoria.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Reserva de emergência",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Reserva de emergência", "Uma "
                        "reserva de emergência é uma quantia de dinheiro guardada para cobrir"
                        " despesas inesperadas, como emergências médicas ou reparos."
                        " Ela deve ser facilmente acessível e equivalente a 3-6 meses de"
                        " despesas essenciais. É uma proteção financeira importante contra imprevistos.");
                  },
                ),
                const Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Reserva de Oportunidade",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    AlertEducation.show(context, "Reserva de Oportunidade", "A reserva de oportunidade "
                        "é uma quantia de dinheiro separada para aproveitar oportunidades financeiras "
                        "inesperadas, como investimentos ou compras vantajosas. Ela é mais "
                        "flexível do que a reserva de emergência e usada para crescimento "
                        "financeiro, não apenas para emergências.");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
