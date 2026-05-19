import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/constant/app_colors/app_colors.dart';
import 'package:store/core/constant/text_styles/app_text_style.dart';
import 'package:store/core/constant/text_styles/font_size.dart';
import 'package:store/core/services/documents/cubit/document_cubit.dart';
import 'document_card.dart';

class HousingCardWidget extends StatelessWidget {
  const HousingCardWidget({super.key});

  String _getDocumentUrl(String masterType) {
    return "https://resident.api.jasim-erp.com/api/app/document/current_user?entityType=&masterType=$masterType";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "My documents",
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_24,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Residence Permit Card - Front
                  DocumentCard(
                    title: "Residence Permit Card - Front",
                    imageUrl: _getDocumentUrl("front_residence_permit"),
                    masterType: "front_residence_permit",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),

                  // Residence Permit Card - Back
                  DocumentCard(
                    title: "Residence Permit Card - Back",
                    imageUrl: _getDocumentUrl("back_residence_permit"),
                    masterType: "back_residence_permit",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),

                  // National ID Card - Front
                  DocumentCard(
                    title: "National ID Card - Front",
                    imageUrl: _getDocumentUrl("front_national_id"),
                    masterType: "front_national_id",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),

                  // National ID Card - Back
                  DocumentCard(
                    title: "National ID Card - Back",
                    imageUrl: _getDocumentUrl("back_national_id"),
                    masterType: "back_national_id",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),

                  // Unified Identity Card - Front
                  DocumentCard(
                    title: "Unified Identity Card - Front",
                    imageUrl: _getDocumentUrl("front_unified_id"),
                    masterType: "front_unified_id",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),

                  // Unified Identity Card - Back
                  DocumentCard(
                    title: "Unified Identity Card - Back",
                    imageUrl: _getDocumentUrl("back_unified_id"),
                    masterType: "back_unified_id",
                    onDelete: (id) =>
                        context.read<DocumentCubit>().deleteDocument(id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
