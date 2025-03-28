class QuarterlyCommission {
  final int year;
  final Map<int, List<int>> quarters;

  QuarterlyCommission({required this.year, required this.quarters});

  factory QuarterlyCommission.fromFirestore(int year, Map<String, dynamic> data) {
    Map<int, List<int>> parsedData = {};
    data.forEach((key, value) {
      int quarter = int.tryParse(key) ?? 0;
      if (quarter > 0 && value is List) {
        parsedData[quarter] = value.map((e) => (e as num).toInt()).toList();
      }
    });
    return QuarterlyCommission(year: year, quarters: parsedData);
  }

  @override
  String toString() {
    return 'Year: $year, Quarters: $quarters';
  }
}