import 'package:flutter/material.dart';
import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/helpers/app_exception.dart';
import 'package:responsi1/ui/review_page.dart';
import 'package:responsi1/ui/edit_review_page.dart';
import 'package:responsi1/ui/sidemenu_page.dart';
import 'package:responsi1/widget/warning_dialog.dart';
import 'dart:developer' as developer;

class ReviewDetail extends StatefulWidget {
  @override
  _ReviewDetailState createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  List<Map<String, dynamic>> reviews = [];
  final Api _api = Api('');

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response = await _api.get(ApiUrl.baseUrl + '/ulasan');
      developer.log('Raw API Response: ${response.toString()}');
      developer.log('API Response: $response');

      if (response is List) {
        setState(() {
          reviews = List<Map<String, dynamic>>.from(response.map((item) {
            if (item is Map<String, dynamic>) {
              return {
                'id': item['id'] ?? 0,
                'reviewer': item['reviewer'] ?? '',
                'rating': item['rating'] ?? 0,
                'comments': item['comments'] ?? '',
              };
            } else {
              developer.log('Invalid item in response: $item');
              return {};
            }
          }));
        });
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        setState(() {
          reviews = List<Map<String, dynamic>>.from(response['data'].map((item) {
            return {
              'id': item['id'] ?? 0,
              'reviewer': item['reviewer'] ?? '',
              'rating': item['rating'] ?? 0,
              'comments': item['comments'] ?? '',
            };
          }));
        });
      } else {
        throw Exception('Invalid response format');
      }
    } on FetchDataException catch (e) {
      _showWarningDialog("Gagal mengambil data ulasan: ${e.message}");
    } catch (e) {
      developer.log('Error in fetchReviews: $e');
      _showWarningDialog("Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<void> deleteReview(int id) async {
    try {
      await _api.delete(ApiUrl.deleteReview(id));
      setState(() {
        reviews.removeWhere((review) => review['id'] == id);
      });
    } on FetchDataException catch (e) {
      _showWarningDialog("Gagal menghapus ulasan: ${e.message}");
    } catch (e) {
      developer.log('Error in deleteReview: $e');
      _showWarningDialog("Terjadi kesalahan: ${e.toString()}");
    }
  }

  void navigateToUpdatePage(Map<String, dynamic> review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReviewPage(review: review),
      ),
    ).then((_) => fetchReviews());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Ulasan'),
      ),
      drawer: Sidemenu(),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ListTile(
            title: Text(review['reviewer'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    review['rating'] ?? 0,
                        (index) => Icon(Icons.star, color: Colors.amber, size: 18),
                  ),
                ),
                Text(review['comments'] ?? ''),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => navigateToUpdatePage(review),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteReview(review['id'] ?? 0),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewPage()),
          ).then((_) => fetchReviews());
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Ulasan',
      ),
    );
  }
}