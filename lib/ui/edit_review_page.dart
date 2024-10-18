import 'package:flutter/material.dart';
import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/helpers/app_exception.dart';
import 'package:responsi1/widget/success_dialog.dart';
import 'package:responsi1/widget/warning_dialog.dart';
import 'dart:developer' as developer;

class EditReviewPage extends StatefulWidget {
  final Map<String, dynamic> review;

  EditReviewPage({required this.review});

  @override
  _EditReviewPageState createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _reviewerController;
  late int _rating;
  late TextEditingController _commentsController;
  final Api _api = Api('');

  @override
  void initState() {
    super.initState();
    _reviewerController = TextEditingController(text: widget.review['reviewer']);
    _rating = widget.review['rating'];
    _commentsController = TextEditingController(text: widget.review['comments']);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          description: "Ulasan berhasil diperbarui.",
          okClick: () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        );
      },
    );
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          description: message,
          okClick: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _updateReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updateData = {
          'reviewer': _reviewerController.text,
          'rating': _rating,
          'comments': _commentsController.text,
        };

        developer.log('Update URL: ${ApiUrl.updateReview(widget.review['id'])}');
        developer.log('Update Data: $updateData');

        final response = await _api.put(
          ApiUrl.updateReview(widget.review['id']),
          updateData,
        );

        developer.log('Update Response: $response');

        _showSuccessDialog();
      } on BadRequestException catch (e) {
        _showWarningDialog("Data tidak valid: ${e.message}");
      } on UnauthorisedException catch (e) {
        _showWarningDialog("Akses tidak sah: ${e.message}");
      } on FetchDataException catch (e) {
        _showWarningDialog("Gagal memperbarui ulasan: ${e.message}");
      } catch (e) {
        developer.log('Error updating review: $e');
        _showWarningDialog("Terjadi kesalahan: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Ulasan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _reviewerController,
                decoration: InputDecoration(labelText: 'Nama Reviewer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap isi nama reviewer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Rating:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _commentsController,
                decoration: InputDecoration(labelText: 'Komentar'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap isi komentar';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _updateReview,
                  child: Text('Update Ulasan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewerController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
}