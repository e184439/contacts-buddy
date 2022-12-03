import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required GlobalKey<FormState> searchFormKey,
    required TextEditingController searchController,
  })  : _searchFormKey = searchFormKey,
        _searchController = searchController,
        super(key: key);

  final GlobalKey<FormState> _searchFormKey;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _searchFormKey,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                    hintText: 'Search contacts'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
