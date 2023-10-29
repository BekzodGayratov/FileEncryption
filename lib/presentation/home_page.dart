import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/application/bloc/user_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USER APP'),
      ),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        return state.when(
            initial: () => const Center(
                  child: Text("INITIAL"),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
            error: (err) => Center(
                  child: Text(err),
                ),
            success: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index].name.toString()),
                      subtitle: Text(data[index].email.toString()),
                    );
                  });
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(const UserEvent.getUsers());
        },
        child: const Text("Get"),
      ),
    );
  }
}
