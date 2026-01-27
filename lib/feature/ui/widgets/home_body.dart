import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_app/feature/data/manager/fatch_data/fetch_data_cubit.dart';
import 'package:sqflite_app/feature/ui/widgets/empty_tasks_view.dart';
import 'package:sqflite_app/feature/ui/widgets/home_task_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<FetchDataCubit, FetchDataState>(
        builder: (context, state) {
          if (state is FetchDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchDataError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 30),
              ),
            );
          }
          if (state is FetchDataSuccess) {
            if (state.tasks.isEmpty) {
              return const EmptyTasksView();
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) =>
                  HomeTaskCard(task: state.tasks[index]),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
