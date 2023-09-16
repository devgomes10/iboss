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
                SizedBox(height: 20),
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
                Divider(color: Colors.white, height: 15),
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
                Divider(color: Colors.white, height: 15),
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
                Divider(color: Colors.white, height: 15),
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
                Divider(color: Colors.white, height: 15),
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
                Divider(color: Colors.white, height: 15),
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
                Divider(color: Colors.white, height: 15),
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
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    "Orçamento Pessoal",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Gestão de Dívidas Pessoais",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Poupança e Investimentos Pessoais",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Planejamento para a Aposentadoria",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Seguro Pessoal e Proteção Financeira",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Impostos",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Divider(color: Colors.white, height: 15),
                ListTile(
                  title: Text(
                    "Objetivos Financeiros de Curto e Longo Prazo",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
