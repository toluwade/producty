import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  const Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class CountryPickerBottomSheet extends StatefulWidget {
  final Function(Country) onCountrySelected;
  final bool isDark;

  const CountryPickerBottomSheet({
    Key? key,
    required this.onCountrySelected,
    required this.isDark,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CountryPickerBottomSheetState createState() => _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  final List<Country> countries = [
    const Country(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸'),
    const Country(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧'),
    const Country(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬'),
    const Country(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦'),
    const Country(name: 'Australia', code: 'AU', dialCode: '+61', flag: '🇦🇺'),
    const Country(name: 'Germany', code: 'DE', dialCode: '+49', flag: '🇩🇪'),
    const Country(name: 'France', code: 'FR', dialCode: '+33', flag: '🇫🇷'),
    const Country(name: 'India', code: 'IN', dialCode: '+91', flag: '🇮🇳'),
    const Country(name: 'Japan', code: 'JP', dialCode: '+81', flag: '🇯🇵'),
    const Country(name: 'Brazil', code: 'BR', dialCode: '+55', flag: '🇧🇷'),
  ];

  List<Country> filteredCountries = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where((country) => 
            country.name.toLowerCase().contains(query.toLowerCase()) ||
            country.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: 'Search Country',
                prefixIcon: Icon(Icons.search, color: widget.isDark ? Colors.white : Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                return ListTile(
                  title: Text(
                    country.name,
                    style: GoogleFonts.dmSans(
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  leading: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  trailing: Text(
                    country.dialCode,
                    style: GoogleFonts.dmSans(
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
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

void showCountryPickerBottomSheet(
  BuildContext context, {
  required Function(Country) onCountrySelected,
  required bool isDark,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CountryPickerBottomSheet(
      onCountrySelected: onCountrySelected,
      isDark: isDark,
    ),
  );
}
