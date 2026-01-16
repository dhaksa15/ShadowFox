import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/logout_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Dogs',
    'Cats',
    'Rabbits',
    'Birds',
    'Others',
  ];

  final List<Map<String, dynamic>> _allPets = [
    {
      'name': 'Max',
      'type': 'Dog',
      'breed': 'Golden Retriever',
      'emoji': '🐕',
      'age': '2 years',
    },
    {
      'name': 'Luna',
      'type': 'Cat',
      'breed': 'Persian',
      'emoji': '🐈',
      'age': '1 year',
    },
    {
      'name': 'Buddy',
      'type': 'Dog',
      'breed': 'Labrador',
      'emoji': '🐕‍🦺',
      'age': '3 years',
    },
    {
      'name': 'Whiskers',
      'type': 'Cat',
      'breed': 'Siamese',
      'emoji': '🐱',
      'age': '2 years',
    },
    {
      'name': 'Coco',
      'type': 'Rabbit',
      'breed': 'Holland Lop',
      'emoji': '🐰',
      'age': '6 months',
    },
    {
      'name': 'Charlie',
      'type': 'Bird',
      'breed': 'Parakeet',
      'emoji': '🦜',
      'age': '8 months',
    },
    {
      'name': 'Bella',
      'type': 'Dog',
      'breed': 'Beagle',
      'emoji': '🐶',
      'age': '1 year',
    },
    {
      'name': 'Mittens',
      'type': 'Cat',
      'breed': 'Tabby',
      'emoji': '🐈‍⬛',
      'age': '4 years',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPets {
    var pets = _allPets;

    if (_selectedCategory != 'All') {
      pets = pets
          .where((pet) => pet['type'] == _selectedCategory.replaceAll('s', ''))
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      pets = pets.where((pet) {
        final searchLower = _searchController.text.toLowerCase();
        return pet['name'].toLowerCase().contains(searchLower) ||
            pet['breed'].toLowerCase().contains(searchLower);
      }).toList();
    }

    return pets;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                boxShadow: AppShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🔍 ', style: TextStyle(fontSize: 24)),
                          Text(
                            'Find Your Pet',
                            style: AppTextStyles.h4.copyWith(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.grey900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      LogoutButton(
                        backgroundColor: Colors.transparent,
                        iconColor: isDark ? AppColors.white : AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by name or breed...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark ? AppColors.grey800 : AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: isDark
                          ? AppColors.surfaceDark
                          : AppColors.white,
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : (isDark ? AppColors.white : AppColors.grey700),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppBorderRadius.round,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${_filteredPets.length} pets found',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Pet List
            Expanded(
              child: _filteredPets.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredPets.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildPetCard(_filteredPets[index], isDark),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadows.small,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPetDetails(pet),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet Emoji
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.primaryGradient),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      pet['emoji'],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Pet Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'],
                        style: AppTextStyles.h6.copyWith(
                          color: isDark ? AppColors.white : AppColors.grey900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet['breed'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.grey300 : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 14,
                            color: AppColors.grey500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            pet['age'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? AppColors.grey500 : AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            'No pets found',
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _showPetDetails(Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppBorderRadius.xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(pet['emoji'], style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                pet['name'],
                style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '${pet['breed']} • ${pet['age']}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Text('❤️'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${pet['name']} added to favorites!'),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.md,
                          ),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'Add to Favorites ❤️',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'Contact Shelter',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
