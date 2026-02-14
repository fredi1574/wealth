import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/net_worth_provider.dart';

class FinanceLogScreen extends ConsumerStatefulWidget {
  const FinanceLogScreen({super.key});

  @override
  ConsumerState<FinanceLogScreen> createState() => _FinanceLogScreenState();
}

class _FinanceLogScreenState extends ConsumerState<FinanceLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final netWorth = ref.watch(netWorthProvider);
    final currencyFormatter = NumberFormat.currency(
      symbol: '₪',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FINANCE LOGS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF0AF47),
          labelColor: const Color(0xFFF0AF47),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'MONTHLY'),
            Tab(text: 'YEARLY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MonthlyTab(
            transactions: netWorth.transactions,
            formatter: currencyFormatter,
          ),
          _YearlyTab(
            transactions: netWorth.transactions,
            formatter: currencyFormatter,
          ),
        ],
      ),
    );
  }
}

class _MonthlyTab extends StatelessWidget {
  final List<Transaction> transactions;
  final NumberFormat formatter;

  const _MonthlyTab({required this.transactions, required this.formatter});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions yet'));
    }

    final grouped = _groupTransactionsByMonth(transactions);

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: grouped.keys.length,
      itemBuilder: (context, index) {
        final monthKey = grouped.keys.elementAt(index);
        final monthTransactions = grouped[monthKey]!;
        final summary = _calculateSummary(monthTransactions);

        return _LogGroupCard(
          title: monthKey,
          summary: summary,
          transactions: monthTransactions,
          formatter: formatter,
        );
      },
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByMonth(
    List<Transaction> txs,
  ) {
    final groups = <String, List<Transaction>>{};
    for (var tx in txs) {
      final key = DateFormat('MMMM yyyy').format(tx.date);
      groups.putIfAbsent(key, () => []).add(tx);
    }
    return groups;
  }

  _LogSummary _calculateSummary(List<Transaction> txs) {
    double income = 0;
    double expenses = 0;
    for (var tx in txs) {
      if (tx.isExpense) {
        expenses += tx.amount;
      } else {
        income += tx.amount;
      }
    }
    return _LogSummary(income: income, expenses: expenses);
  }
}

class _YearlyTab extends StatelessWidget {
  final List<Transaction> transactions;
  final NumberFormat formatter;

  const _YearlyTab({required this.transactions, required this.formatter});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions yet'));
    }

    final grouped = _groupTransactionsByYear(transactions);

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: grouped.keys.length,
      itemBuilder: (context, index) {
        final yearKey = grouped.keys.elementAt(index);
        final yearTransactions = grouped[yearKey]!;
        final summary = _calculateSummary(yearTransactions);

        return _LogGroupCard(
          title: yearKey,
          summary: summary,
          transactions: yearTransactions,
          formatter: formatter,
          showDetails: false,
        );
      },
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByYear(
    List<Transaction> txs,
  ) {
    final groups = <String, List<Transaction>>{};
    for (var tx in txs) {
      final key = DateFormat('yyyy').format(tx.date);
      groups.putIfAbsent(key, () => []).add(tx);
    }
    return groups;
  }

  _LogSummary _calculateSummary(List<Transaction> txs) {
    double income = 0;
    double expenses = 0;
    for (var tx in txs) {
      if (tx.isExpense) {
        expenses += tx.amount;
      } else {
        income += tx.amount;
      }
    }
    return _LogSummary(income: income, expenses: expenses);
  }
}

class _LogSummary {
  final double income;
  final double expenses;
  double get net => income - expenses;

  _LogSummary({required this.income, required this.expenses});
}

class _LogGroupCard extends StatelessWidget {
  final String title;
  final _LogSummary summary;
  final List<Transaction> transactions;
  final NumberFormat formatter;
  final bool showDetails;

  const _LogGroupCard({
    required this.title,
    required this.summary,
    required this.transactions,
    required this.formatter,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2228),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '+${formatter.format(summary.income)}',
              style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
            ),
            const SizedBox(width: 12),
            Text(
              '-${formatter.format(summary.expenses)}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
            const Spacer(),
            Text(
              'Net: ${summary.net >= 0 ? '+' : ''}${formatter.format(summary.net)}',
              style: TextStyle(
                color: summary.net >= 0 ? Colors.greenAccent : Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: showDetails
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: transactions
                        .map(
                          (t) => _TransactionItem(t: t, formatter: formatter),
                        )
                        .toList(),
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction t;
  final NumberFormat formatter;

  const _TransactionItem({required this.t, required this.formatter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF0F1115),
            child: Icon(
              t.isExpense
                  ? Icons.shopping_bag_outlined
                  : Icons.account_balance_wallet_outlined,
              size: 14,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.title,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
          Text(
            '${t.isExpense ? '-' : '+'} ${formatter.format(t.amount)}',
            style: TextStyle(
              fontSize: 13,
              color: t.isExpense ? Colors.redAccent : Colors.greenAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
