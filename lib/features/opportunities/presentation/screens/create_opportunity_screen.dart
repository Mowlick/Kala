import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  State<CreateOpportunityScreen> createState() => _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _compensationController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Audition';
  final List<String> _categories = ['Audition', 'Gig', 'Competition', 'Internship', 'Workshop'];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _compensationController.dispose();
    _requirementsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an Opportunity'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Reach India\'s Best Talent',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Post details about your audition, gig, or event to find professional creators.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: KalaColors.mediumGrey,
                        ),
                  ),
                  const SizedBox(height: 28),

                  // Opportunity Title
                  Text(
                    'Opportunity Title',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Lead Female Dancer for Indie MV',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category Dropdown
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(),
                    items: _categories.map((String cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Location
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Mumbai, Maharashtra (or Online)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Compensation
                  Text(
                    'Compensation / Pay',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _compensationController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Paid (₹15,000 - ₹20,000) or Unpaid',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter compensation info';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'Description / Details',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Provide details about the project, schedules, and what selected artists will get to do...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Requirements
                  Text(
                    'Requirements (One per line)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _requirementsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Min 2 years hip hop experience\nMust reside in Mumbai\nPortfolio reels are required',
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showSuccessDialog(context);
                      }
                    },
                    child: const Text('Post Opportunity'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.softBeige,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: KalaColors.burntOrange,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Opportunity Posted!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your opportunity has been successfully reviewed and is now live for all KALĀ creators.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KalaColors.mediumGrey,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to listings
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
