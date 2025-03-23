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
    'Afghan Hound',
    'American Bully',
    'American Staffordshire Terrier',
    'Basset Hound',
    'Beagle',
    'Belgian Malinois',
    'Border Collie',
    'Boxer',
    'Bulldog',
    'Chihuahua',
    'Cocker Spaniel',
    'Dalmatian',
    'Dachshund',
    'Doberman',
    'French Bulldog',
    'German Shepherd',
    'German Spitz',
    'Golden Retriever',
    'Great Dane',
    'Great Pyrenees',
    'Indian Pariah Dog (Desi Dog)',
    'Jack Russell Terrier',
    'Japanese Spitz',
    'Labrador Retriever',
    'Lhasa Apso',
    'Maltese',
    'Mixed Breed (Mongrel)',
    'Pekingese',
    'Pomeranian',
    'Poodle',
    'Pug',
    'Rottweiler',
    'Saint Bernard',
    'Samoyed',
    'Shih Tzu',
    'Siberian Husky',
    'Spitz',
    'Sri Lankan Hound',
    'Sri Lankan Mastiff',
    'Terrier',
    'Tibetan Mastiff',
    'Weimaraner',
    'Whippet'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
