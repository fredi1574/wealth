class Stock {
  final String ticker;
  final String name;
  final double shares;
  final double costBasis;
  final double currentPrice;

  Stock({
    required this.ticker,
    required this.name,
    required this.shares,
    required this.costBasis,
    required this.currentPrice,
  });

  double get marketValue => shares * currentPrice;
  double get totalCost => shares * costBasis;
  double get profitLoss => marketValue - totalCost;
  double get profitLossPercentage => (profitLoss / totalCost) * 100;

  Stock copyWith({
    String? ticker,
    String? name,
    double? shares,
    double? costBasis,
    double? currentPrice,
  }) {
    return Stock(
      ticker: ticker ?? this.ticker,
      name: name ?? this.name,
      shares: shares ?? this.shares,
      costBasis: costBasis ?? this.costBasis,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }
}
