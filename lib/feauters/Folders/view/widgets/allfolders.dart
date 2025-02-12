import 'dart:developer';

import 'package:files_manger/const.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilecubit.dart';
import 'package:files_manger/feauters/Folders/data/cubit/getallfiles/getallfilestate.dart';
import 'package:files_manger/feauters/Folders/data/cubit/searchFoldersFiles/search_folders_files_cubit.dart';
import 'package:files_manger/feauters/Folders/view/widgets/dialog.dart';
import 'package:files_manger/feauters/Folders/view/widgets/floderfilepage.dart'; // تأكد من أن صفحة FolderFilesPage موجودة
import 'package:files_manger/feauters/Folders/view/widgets/text_feild_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Allfolders extends StatefulWidget {
  const Allfolders({super.key});

  @override
  State<Allfolders> createState() => _AllfoldersState();
}

class _AllfoldersState extends State<Allfolders> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Getallfilecubit, Getallfilestate>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is Getallfilestateloading) {
          return const LOAD();
        } else if (state is Getallfilestatesuccss) {
          return ListView.builder(
            shrinkWrap: true,
         
            itemCount: state.fileSystem.keys.length,
            itemBuilder: (context, index) {
              final dirPath = state.fileSystem.keys.elementAt(index);
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FolderFilesPage(folderPath: dirPath),
                          ),
                        );
                      },
                      child: Container(
                        height: 80.h,
                        padding: EdgeInsets.all(12.h),
                        margin: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                            color: Appcolor.second,
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(BlocProvider.of<Getallfilecubit>(context)
                                .getIconForFileType(dirPath)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: 180.w,
                                child: Text(
                                  dirPath.split('/').last,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'rename') {
                                  // عرض نافذة تعديل الاسم
                                  showAppDialog(
                                      datatext: 'Rename',
                                      function: () => BlocProvider.of<
                                              Getallfilecubit>(context)
                                          .renameFolder(
                                              dirPath,
                                              BlocProvider.of<Getallfilecubit>(
                                                      context)
                                                  .foldername
                                                  .text),
                                      textEditingController:
                                          textEditingController,
                                      context: context);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is Getallfilestatefailuer) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('No files available.'));
        }
      },
    );
  }
}
