import 'package:flutter/material.dart';
import 'package:test_suitmedia/user_model.dart';

import 'constant.dart';
import 'user_service.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  late UserService userService;
  late ScrollController scrollController;
  List<UserModel> userData = [];
  int page = 1;
  bool isLoading = false;
  String selectedName = "";

  Future<void> refresh() async {
    userData = [];
    page = 1;
    fetchData(page);
    setState(() {});
  }

  Future<void> fetchData(int page) async {
    final data = await userService.getAllUser(page);
    // Dua kali loop agar data bisa memenuhi layar
    for (var item in data) {
      userData.add(item);
    }

    for (var item in data) {
      userData.add(item);
    }
    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    isLoading = true;

    scrollController = ScrollController();
    userService = UserService();

    fetchData(page);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        isLoading = true;
        page += 1;
        fetchData(page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Third Screen",
            style: TextStyle(
              color: MyColor.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, [selectedName]),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF554AF0),
            ),
            splashRadius: 25,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => refresh(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (isLoading)
                        ? const CircularProgressIndicator()
                        : Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: userData.length,
                              itemBuilder: (_, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userData[index].avatar),
                                  ),
                                  title: Text(
                                    "${userData[index].firstName} ${userData[index].lastName}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    userData[index].email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    selectedName =
                                        "${userData[index].firstName} ${userData[index].lastName}";
                                  },
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 10),
                    (isLoading)
                        ? const Text(
                            "Loading ...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
