import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  final Function(String?, String?, String?) onApplyFilters;
  final String? initialBreed;
  final String? initialGender;
  final String? initialAge;

  const SearchFilterScreen({
    super.key,
    required this.onApplyFilters,
    this.initialBreed,
    this.initialGender,
    this.initialAge,
  });

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String? selectedBreed;
  String? selectedGender;
  String? selectedAge;

  final List<String> breeds = [
    'Labrador Retriever',
    'Golden Retriever',
    'Bulldog',
    'Beagle',
    'German Shepherd',
    'Poodle',
    'Dachshund',
    'Rottweiler',
    'Shih Tzu',
    'Doberman',
    'Chihuahua',
    'Great Dane',
    'Pug',
    'Cocker Spaniel',
    'Border Collie',
    'Siberian Husky',
    'Boxer',
    'Maltese',
    'Pomeranian',
    'Saint Bernard'
  ];

  final List<String> genders = ['Male', 'Female'];
  final List<String> ageCategories = [
    'Puppy (0-1 year)',
    'Young (1-3 years)',
    'Adult (3-7 years)',
    'Senior (7+ years)'
  ];

  TextEditingController breedController = TextEditingController();
  List<String> filteredBreeds = [];
  bool hasAppliedFilters = false;

  @override
  void initState() {
    super.initState();
    // Initialize with any existing filters
    selectedBreed = widget.initialBreed;
    selectedGender = widget.initialGender;
    selectedAge = widget.initialAge;

    // Set the breed controller text if we have an initial breed
    if (widget.initialBreed != null) {
      breedController.text = widget.initialBreed!;
    }

    filteredBreeds = breeds;
  }

  void filterBreeds(String query) {
    setState(() {
      filteredBreeds = breeds
          .where((breed) => breed.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _applyFilters() {
    // Debug output before applying filters
    print('Applying filters:');
    print('Selected breed: $selectedBreed');
    print('Selected gender: $selectedGender');
    print('Selected age: $selectedAge');

    setState(() {
      hasAppliedFilters = true;
    });

    widget.onApplyFilters(
      selectedBreed,
      selectedGender,
      selectedAge,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Perfect Match',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchableDropdown('Breed', breedController, filteredBreeds,
                    (value) {
                  setState(() {
                    selectedBreed = value;
                    print('Selected breed: $value');
                  });
                }),
            _buildDropdown('Gender', selectedGender, genders, (value) {
              setState(() {
                selectedGender = value;
                print('Selected gender: $value');
              });
            }),
            _buildDropdown('Age', selectedAge, ageCategories, (value) {
              setState(() {
                selectedAge = value;
                print('Selected age: $value');
              });
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Search', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedBreed = null;
                    selectedGender = null;
                    selectedAge = null;
                    breedController.clear();
                    print('Cleared all filters');
                  });

                  // If we had applied filters before, apply the cleared filters
                  if (hasAppliedFilters) {
                    widget.onApplyFilters(null, null, null);
                    Navigator.pop(context);
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Clear Filters',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text('Select $label'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchableDropdown(
      String label,
      TextEditingController controller,
      List<String> items,
      Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Type to search...",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    filteredBreeds = []; // Hide dropdown when cleared
                    selectedBreed = null;
                  });
                },
              )
                  : null,
            ),
            onChanged: (query) {
              setState(() {
                filteredBreeds = query.isNotEmpty
                    ? breeds
                    .where((breed) =>
                    breed.toLowerCase().contains(query.toLowerCase()))
                    .toList()
                    : []; // Hide dropdown when input is empty
              });
            },
          ),
          const SizedBox(height: 5),
          if (controller.text.isNotEmpty && filteredBreeds.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 4, spreadRadius: 2),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredBreeds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredBreeds[index]),
                    onTap: () {
                      onSelected(filteredBreeds[index]);
                      setState(() {
                        controller.text = filteredBreeds[index];
                        filteredBreeds = []; // Hide dropdown after selection
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

