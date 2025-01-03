import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/chat';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  bool _search = false;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: _search
            ? TextField(
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
                  _search = !_search;
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
              child: Column(
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
