class CategoryCardData {
  final String name;
  final String imagePath;
  final String id;
  final Object? extraData;

  const CategoryCardData({
    required this.name,
    required this.imagePath,
    required this.id,
    this.extraData,
  });

  // Static factory methods for each category
  static CategoryCardData pathology() {
    return const CategoryCardData(
      id: 'pathology',
      name: 'Patoloji',
      imagePath: 'assets/images/pathology.png',
    );
  }

  static CategoryCardData oncology() {
    return const CategoryCardData(
      id: 'oncology',
      name: 'Onkoloji',
      imagePath: 'assets/images/oncology.png',
    );
  }

  static CategoryCardData demography() {
    return const CategoryCardData(
      id: 'demography',
      name: 'Demografik',
      imagePath: 'assets/images/demography.png',
    );
  }

  static CategoryCardData comorbidity() {
    return const CategoryCardData(
      id: 'comorbidity',
      name: 'Komorbite',
      imagePath: 'assets/images/comorbidity.png',
    );
  }

  static CategoryCardData biochemistry() {
    return const CategoryCardData(
      id: 'biochemistry',
      name: 'Biyokimya',
      imagePath: 'assets/images/biochemistry.png',
    );
  }

  static CategoryCardData radiology() {
    return const CategoryCardData(
      id: 'radiology',
      name: 'Radyoloji',
      imagePath: 'assets/images/radiology.png',
    );
  }

  static CategoryCardData pet() {
    return const CategoryCardData(
      id: 'pet',
      name: 'PET',
      imagePath: 'assets/images/pet.png',
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
      case 'pet':
        return pet();
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
      pet(),
    ];
  }
}
