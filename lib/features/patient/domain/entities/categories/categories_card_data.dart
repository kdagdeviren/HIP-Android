class CategoryCardData {
  final String imagePath;
  final String id;
  final Object? extraData;

  const CategoryCardData({
    required this.imagePath,
    required this.id,
    this.extraData,
  });

  // Static factory methods for each category
  static CategoryCardData pathology() {
    return const CategoryCardData(
      id: 'pathology',
      imagePath: 'assets/images/pathology.png',
    );
  }

  static CategoryCardData oncology() {
    return const CategoryCardData(
      id: 'oncology',
      imagePath: 'assets/images/oncology.png',
    );
  }

  static CategoryCardData demography() {
    return const CategoryCardData(
      id: 'demography',
      imagePath: 'assets/images/demography.png',
    );
  }

  static CategoryCardData comorbidity() {
    return const CategoryCardData(
      id: 'comorbidity',
      imagePath: 'assets/images/comorbidity.png',
    );
  }

  static CategoryCardData biochemistry() {
    return const CategoryCardData(
      id: 'biochemistry',
      imagePath: 'assets/images/biochemistry.png',
    );
  }

  static CategoryCardData radiology() {
    return const CategoryCardData(
      id: 'radiology',
      imagePath: 'assets/images/radiology.png',
    );
  }

  static CategoryCardData getCategoryById(String id) {
    switch (id) {
      case 'pathology':
        return pathology();
      case 'oncology':
        return oncology();
      case 'demography':
        return demography();
      case 'comorbidity':
        return comorbidity();
      case 'biochemistry':
        return biochemistry();
      case 'radiology':
        return radiology();
      default:
        throw Exception('Invalid category ID: $id');
    }
  }

  // Get all categories as a list
  static List<CategoryCardData> getAllCardCategories() {
    return [
      pathology(),
      oncology(),
      demography(),
      comorbidity(),
      biochemistry(),
      radiology(),
    ];
  }
}
