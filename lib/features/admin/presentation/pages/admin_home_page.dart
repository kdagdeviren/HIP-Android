import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/shared/widgets/custom_card_with_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_medical_data_app/features/admin/presentation/viewmodel/admin_viewmodel.dart';
import 'package:flutter_medical_data_app/features/admin/presentation/widgets/user_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().loadUnverifiedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AdminViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomCardWithImage(
                    title: "Hesabınızdan çıkış yapın",
                    buttonName: "ÇIKIŞ YAP",
                    image: "assets/images/existing_patinet.png",
                    buttonPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      NavigationService.instance.navigateToReplacement(
                        '/auth-guard',
                      );
                    },
                  ),
                  SizedBox(height: 1.h),
                  PageInformationBox(title: "Kullanıcı Onayları"),
                  SizedBox(height: 1.h),
                  if (viewModel.isLoading)
                    const Center(child: CircularProgressIndicator()),

                  if (viewModel.unverifiedUsers.isEmpty && !viewModel.isLoading)
                    const Center(child: Text('Onay bekleyen kullanıcı yok.')),

                  RefreshIndicator(
                    onRefresh: () async {
                      await viewModel.loadUnverifiedUsers();
                    },
                    child: ListView.builder(
                      itemCount: viewModel.unverifiedUsers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = viewModel.unverifiedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              UserCard(
                                user: user,
                                onApprove: () =>
                                    viewModel.verifyUser(context, user.docID),
                                onReject: () =>
                                    viewModel.rejectUser(context, user.docID),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
