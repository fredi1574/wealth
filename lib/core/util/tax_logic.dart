class TaxLogic {
  /// Calculates Israeli tax credit points (Nekudot Zikuy) for a 2025 graduate.
  ///
  /// Standard points for resident: 2.25
  /// Additional points for academic degree (First degree): 1 point for 1 year or 0.5 points for 2 years (depending on rules).
  /// For a 2025 graduate, they usually get additional points starting from the year after graduation.
  static double calculateCreditPoints({
    bool isResident = true,
    bool isMan = true, // Men get 2.25, Women get 2.75 standard
    bool is2025Graduate = false,
  }) {
    double points = 0;

    if (isResident) {
      points += 2.25;
    }

    if (!isMan) {
      points += 0.5;
    }

    if (is2025Graduate) {
      // Graduates get 1 extra point for 12 months after graduation year.
      // Since it's 2025 graduate, they might start receiving it in 2026.
      // But we can model the logic here.
      points += 1.0;
    }

    return points;
  }

  /// Value of one credit point per month in 2024 (approx 242 ILS)
  static const double pointValueMonth = 242.0;

  static double calculateMonthlyTaxBenefit(double points) {
    return points * pointValueMonth;
  }
}
