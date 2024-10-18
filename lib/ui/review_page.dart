import 'package:flutter/material.dart';
import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/helpers/app_exception.dart';
import 'package:responsi1/widget/success_dialog.dart';
import 'package:responsi1/widget/warning_dialog.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _reviewerController = TextEditingController();
  final _commentsController = TextEditingController();
  int _rating = 0;
  final Api _api = Api('');

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          description: "Ulasan berhasil ditambahkan.",
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

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      try {
        final response = await _api.post(
          ApiUrl.createReview,
          {
            'reviewer': _reviewerController.text,
            'rating': _rating,
            'comments': _commentsController.text,
          },
        );

        _showSuccessDialog();
      } on BadRequestException catch (e) {
        _showWarningDialog("Data tidak valid: ${e.message}");
      } on UnauthorisedException catch (e) {
        _showWarningDialog("Akses tidak sah: ${e.message}");
      } on FetchDataException catch (e) {
        _showWarningDialog("Gagal menambahkan ulasan: ${e.message}");
      } catch (e) {
        _showWarningDialog("Terjadi kesalahan: ${e.toString()}");
      }
    } else if (_rating == 0) {
      _showWarningDialog("Silakan pilih rating.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Ulasan'),
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
                decoration: InputDecoration(
                  labelText: 'Nama Reviewer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap isi nama reviewer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Rating:', style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
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
                decoration: InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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
                  child: Text('Kirim Ulasan'),
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
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