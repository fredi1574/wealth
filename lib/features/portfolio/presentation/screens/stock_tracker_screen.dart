import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/stock_model.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data for now
    final stocks = [
      Stock(
        ticker: 'AAPL',
        name: 'Apple Inc.',
        shares: 10,
        costBasis: 150,
        currentPrice: 185,
      ),
      Stock(
        ticker: 'VOO',
        name: 'Vanguard S&P 500',
        shares: 5,
        costBasis: 380,
        currentPrice: 420,
      ),
      Stock(
        ticker: 'VGT',
        name: 'Vanguard IT ETF',
        shares: 8,
        costBasis: 400,
        currentPrice: 460,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('THE QUANT'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAllocationChart(),
            const SizedBox(height: 30),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stocks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildStockCard(stocks[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              color: const Color(0xFFF0AF47),
              radius: 20,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 30,
              color: const Color(0xFF1E2228),
              radius: 20,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 30,
              color: Colors.blueAccent,
              radius: 20,
              showTitle: false,
            ),
          ],
          centerSpaceRadius: 60,
        ),
      ),
    );
  }

  Widget _buildStockCard(Stock stock) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16191E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2228),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              stock.ticker[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0AF47),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.ticker,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  stock.name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₪${(stock.marketValue * 3.7).toStringAsFixed(0)}', // Simplified ILS conversion
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${stock.profitLossPercentage > 0 ? '+' : ''}${stock.profitLossPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: stock.profitLossPercentage > 0
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
