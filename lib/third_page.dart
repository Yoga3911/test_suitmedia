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
  String selectedName = "";

  @override
  void initState() {
    userService = UserService();
    super.initState();
  }

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: FutureBuilder<List<UserModel>>(
          future: userService.getAllUser(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(
                child: Text("Tidak ada data"),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data[index].avatar),
                    ),
                    title: Text(
                      "${data[index].firstName} ${data[index].lastName}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      data[index].email,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      selectedName = "${data[index].firstName} ${data[index].lastName}";
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
