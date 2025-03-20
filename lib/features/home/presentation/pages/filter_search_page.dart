import 'package:flutter/material.dart';
import 'package:furrpal/features/home/presentation/pages/home_page.dart';
import 'package:furrpal/features/home/presentation/pages/home_page.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String? selectedBreed;

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
    'husky',
    'husky',
    'Cocker Spaniel',
    'Border Collie',
    'Siberian Husky',
    'Boxer',
    'Maltese',
    'Pomeranian',
    'Saint Bernard'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Perfect Match'),
        title: const Text('Find Your Perfect Match'),
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
            DropdownButtonFormField<String>(
              value: selectedBreed,
              decoration: InputDecoration(
                labelText: 'Breed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: breeds.map((String breed) {
                return DropdownMenuItem<String>(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBreed = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedBreed,
              decoration: InputDecoration(
                labelText: 'Breed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: breeds.map((String breed) {
                return DropdownMenuItem<String>(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBreed = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedBreed);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  const Text('Search', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
