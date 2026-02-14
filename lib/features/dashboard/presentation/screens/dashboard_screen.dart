import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/net_worth_provider.dart';
import 'quick_add_form.dart';
import 'finance_log_screen.dart';
import '../../../portfolio/presentation/screens/stock_tracker_screen.dart';
import '../../../goals/presentation/screens/goal_tracker_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const PortfolioScreen(),
    const GoalTrackerScreen(),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F1115),
        selectedItemColor: const Color(0xFFF0AF47),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Ledger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Quant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_rounded),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netWorth = ref.watch(netWorthProvider);
    final currencyFormatter = NumberFormat.currency(
      symbol: '₪',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('THE LEDGER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetWorthCard(netWorth, currencyFormatter),
            const SizedBox(height: 30),
            _buildQuickActions(context),
            const SizedBox(height: 30),
            _buildRecentTransactions(context, netWorth, currencyFormatter),
            const SizedBox(height: 30),
            _buildGoalsPreview(netWorth),
          ],
        ),
      ),
    );
  }

  Widget _buildNetWorthCard(NetWorthState state, NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2228), Color(0xFF16191E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NET WORTH',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: 1.5,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(state.totalBalance),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF0AF47),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward,
                color: Colors.greenAccent,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                '+₪ 12,400 (2.4%)',
                style: TextStyle(color: Colors.greenAccent, fontSize: 14),
              ),
              const Spacer(),
              Text(
                '\$ ${(state.totalBalance / 3.7).toStringAsFixed(0)}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(context, Icons.add_rounded, 'Add Entry', () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const QuickAddForm(),
          );
        }),
        _buildActionItem(context, Icons.trending_up_rounded, 'Invest', () {}),
        _buildActionItem(
          context,
          Icons.account_balance_rounded,
          'Tax Info',
          () {},
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2228),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(icon, color: const Color(0xFFF0AF47)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    NetWorthState state,
    NumberFormat formatter,
  ) {
    if (state.transactions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT TRANSACTIONS',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinanceLogScreen(),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(color: Color(0xFFF0AF47), fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...state.transactions
            .take(3)
            .map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF1E2228),
                      child: Icon(
                        t.isExpense
                            ? Icons.shopping_bag_outlined
                            : Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.MMMd().format(t.date),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${t.isExpense ? '-' : '+'} ${formatter.format(t.amount)}',
                      style: TextStyle(
                        color: t.isExpense
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildGoalsPreview(NetWorthState state) {
    if (state.goals.isEmpty) return const SizedBox.shrink();
    final goal = state.goals.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GOALS',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF16191E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(goal.title),
                  Text('${(goal.progress * 100).toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: goal.progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF0F1115),
                  valueColor: AlwaysStoppedAnimation(
                    Color(int.parse('FF${goal.colorHex}', radix: 16)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₪ ${NumberFormat.decimalPattern().format(goal.currentAmount)} / ₪ ${NumberFormat.decimalPattern().format(goal.targetAmount)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
