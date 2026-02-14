import 'package:flutter_riverpod/flutter_riverpod.dart';

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isExpense;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    this.isExpense = true,
  });
}

class FinancialGoal {
  final String id;
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String colorHex;

  FinancialGoal({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    this.colorHex = 'F0AF47',
  });

  double get progress => currentAmount / targetAmount;

  FinancialGoal copyWith({
    String? title,
    double? currentAmount,
    double? targetAmount,
    String? colorHex,
  }) {
    return FinancialGoal(
      id: this.id,
      title: title ?? this.title,
      currentAmount: currentAmount ?? this.currentAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}

class NetWorthState {
  final double totalBalance;
  final List<Transaction> transactions;
  final List<FinancialGoal> goals;

  NetWorthState({
    required this.totalBalance,
    List<Transaction>? transactions,
    List<FinancialGoal>? goals,
  }) : this.transactions = transactions ?? [],
       this.goals = goals ?? [];

  NetWorthState copyWith({
    double? totalBalance,
    List<Transaction>? transactions,
    List<FinancialGoal>? goals,
  }) {
    return NetWorthState(
      totalBalance: totalBalance ?? this.totalBalance,
      transactions: transactions ?? this.transactions,
      goals: goals ?? this.goals,
    );
  }
}

class NetWorthNotifier extends StateNotifier<NetWorthState> {
  NetWorthNotifier()
    : super(
        NetWorthState(
          totalBalance: 1245670.0,
          transactions: [
            Transaction(
              title: 'Salary',
              amount: 25000,
              date: DateTime(2026, 2, 1),
              isExpense: false,
            ),
            Transaction(
              title: 'Rent',
              amount: 5500,
              date: DateTime(2026, 2, 2),
              isExpense: true,
            ),
            Transaction(
              title: 'Groceries',
              amount: 1200,
              date: DateTime(2026, 2, 5),
              isExpense: true,
            ),
            Transaction(
              title: 'Salary',
              amount: 25000,
              date: DateTime(2026, 1, 1),
              isExpense: false,
            ),
            Transaction(
              title: 'Rent',
              amount: 5500,
              date: DateTime(2026, 1, 2),
              isExpense: true,
            ),
          ],
          goals: [
            FinancialGoal(
              id: '1',
              title: 'House Fund',
              currentAmount: 900000,
              targetAmount: 2000000,
              colorHex: 'F0AF47',
            ),
          ],
        ),
      );

  void addTransaction(String title, double amount, {bool isExpense = true}) {
    final newTransaction = Transaction(
      title: title,
      amount: amount,
      date: DateTime.now(),
      isExpense: isExpense,
    );

    // Defensive check for potential null list during reload
    final currentTransactions = state.transactions;

    state = state.copyWith(
      totalBalance: isExpense
          ? state.totalBalance - amount
          : state.totalBalance + amount,
      transactions: [newTransaction, ...currentTransactions],
    );
  }

  void updateGoal(String id, double addition) {
    final currentGoals = state.goals;
    state = state.copyWith(
      goals: currentGoals.map((g) {
        if (g.id == id) {
          return g.copyWith(currentAmount: g.currentAmount + addition);
        }
        return g;
      }).toList(),
    );
  }

  void addGoal(String title, double target) {
    final newGoal = FinancialGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      currentAmount: 0,
      targetAmount: target,
    );
    final currentGoals = state.goals;
    state = state.copyWith(goals: [...currentGoals, newGoal]);
  }
}

final netWorthProvider = StateNotifierProvider<NetWorthNotifier, NetWorthState>(
  (ref) {
    return NetWorthNotifier();
  },
);
