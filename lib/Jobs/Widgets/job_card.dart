import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../detail_page.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final DocumentSnapshot? doc; // <-- nullable
  final bool isExpired;
  final String? currentUserEmail;

  const JobCard({
    Key? key,
    required this.data,
    this.doc,
    this.isExpired = false,
    this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = [
      data['country']?.toString(),
      data['state']?.toString(),
    ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: InkWell(
        onTap: () {
          if (doc != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JobDetailScreen(job: doc!)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This job is available offline only.")),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isExpired ? Colors.red.shade100 : Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: data['jobImage'] != null
                      ? Image.memory(
                    base64Decode(data['jobImage']),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey),
                  )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data['comName'] ?? 'COMPANY NAME').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['jobTitle'] ?? 'Job Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          location.isNotEmpty ? location : 'Job Location',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data['jobCat'] ?? 'Job Category',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
