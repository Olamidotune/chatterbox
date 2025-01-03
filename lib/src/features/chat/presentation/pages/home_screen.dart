// ignore_for_file: strict_raw_type

import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:chatterbox/src/features/authentication/services/database.dart';
import 'package:chatterbox/src/services/shared_prefs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  bool _search = false;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  List queryResultSet = [];
  List tempSearchStore = [];
  bool _isSearching = false;
  String? myName;
  String? myProfilePic;
  String? myUserName;
  String? myEmail;
  String getChatRoomIDByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: _search
            ? TextField(
                onChanged: (value) {
                  _initiateSearch(value.toUpperCase());
                  debugPrint(value);
                },
                onSubmitted: (value) {
                  debugPrint(value);
                  _initiateSearch(value.toUpperCase());
                },
                textInputAction: TextInputAction.search,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14.fontSize,
                      color: AppColors.primaryTextColor,
                    ),
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.greyColor.withOpacity(0.2),
                  hintText: AppStrings.searchUser,
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.greyColor,
                        fontSize: 15.fontSize,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.greenColor),
                  ),
                ),
              )
            : Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.fontSize,
                    ),
              ),
        actions: [
          if (_search)
            GestureDetector(
              onTap: () {
                setState(() {
                  _search = false;
                  controller.clear();
                  focusNode.unfocus();
                });
              },
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            )
          else
            IconButton(
              onPressed: () {
                setState(() {
                  _search = !_search;
                });
              },
              icon: const Icon(
                Icons.search,
                color: AppColors.primaryTextColor,
              ),
            ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RawScrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalSpacing,
              ),
              child: _search
                  ? ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore
                          .map<Widget>((element) =>
                              buildResultCard(element as Map<String, dynamic>))
                          .toList(),
                    )
                  : Column(
                      children: [
                        if (_search)
                          AppSpacing.verticalSpaceMedium
                        else
                          AppSpacing.verticalSpaceSmall,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                        AppSpacing.verticalSpaceMedium,
                        const ChatContainer(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _initiateSearch(String value) async {
    // First handle empty value case
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];

        _isSearching = false;
      });
      return;
    }

    // Set search and loading state
    setState(() {
      _search = true;
      _isSearching = true;
    });

    try {
      final capitalizedValue = value[0].toUpperCase() + value.substring(1);

      if (queryResultSet.isEmpty && value.length == 1) {
        // Fetch new data from database
        final docs = await DatabaseMethod().searchByName(value);

        // Handle the case where the search term changed while fetching
        if (!mounted) return;

        setState(() {
          queryResultSet = docs.docs.map((doc) => doc.data()).toList();
          tempSearchStore = queryResultSet;
          _isSearching = false;
        });
      } else {
        // Filter existing results
        setState(() {
          tempSearchStore = queryResultSet
              .where((element) =>
                  element['name'].toString().startsWith(capitalizedValue))
              .toList();
          _isSearching = false;
        });
      }
    } catch (e) {
      // Handle any errors that might occur during search
      if (!mounted) return;

      setState(() {
        _isSearching = false;
        // You might want to add error handling here
        // errorMessage = e.toString();
      });
    }
  }

  getMySharedPrefs() async {
    myName = await SharedPrefs().getDisplayUserNameSharedPreference();
    myProfilePic = await SharedPrefs().getUserProfilePicSharedPreference();
    myUserName = await SharedPrefs().getUserNameSharedPreference();
    myEmail = await SharedPrefs().getUserEmailSharedPreference();

    setState(() {});
  }

  Widget buildResultCard(Map<String, dynamic> data) {
    return _isSearching
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
        : GestureDetector(
            onTap: () async {
              _search = false;

              setState(() {});

              final chatRoomId = getChatRoomIDByUsername(
                myUserName!,
                data['username'] as String,
              );

              final chatRoomInfoMap = {
                'users': [myUserName, data['username']],
              };

              await DatabaseMethod()
                  .createChatRoom(chatRoomId, chatRoomInfoMap);
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Material(
                elevation: 5,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greyColor.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      child: Image.network(
                        data['photoUrl'] as String,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      data['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.fontSize,
                          ),
                    ),
                    subtitle: Text(
                      data['email'] as String,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 11.fontSize,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class ChatContainer extends StatelessWidget {
  const ChatContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor,
        ),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 24,
        ),
        title: Text(
          'User Name',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.fontSize,
              ),
        ),
        subtitle: Text(
          'Last message',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.greyColor,
                fontSize: 11.fontSize,
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '12:00 PM',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.greyColor,
                    fontSize: 11.fontSize,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '2',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 11.fontSize,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
