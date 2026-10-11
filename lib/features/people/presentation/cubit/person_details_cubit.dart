import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_person_details.dart';
import '../../domain/usecases/get_person_images.dart';
import '../../domain/usecases/get_person_credits.dart';
import 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  final GetPersonDetails getPersonDetails;
  final GetPersonImages getPersonImages;
  final GetPersonCredits getPersonCredits;

  PersonDetailsCubit({
    required this.getPersonDetails,
    required this.getPersonImages,
    required this.getPersonCredits,
  }) : super(PersonDetailsInitial());

  Future<void> fetchPersonDetails(int id) async {
    emit(PersonDetailsLoading());

    final failureOrDetails = await getPersonDetails(id);
    
    failureOrDetails.fold(
      (failure) => emit(PersonDetailsError(failure.message)),
      (details) async {
        final failureOrImages = await getPersonImages(id);
        await failureOrImages.fold(
          (failure) async => emit(PersonDetailsError(failure.message)),
          (images) async {
            final failureOrCredits = await getPersonCredits(id);
            failureOrCredits.fold(
              (failure) => emit(PersonDetailsError(failure.message)),
              (credits) => emit(PersonDetailsLoaded(
                details: details,
                images: images,
                credits: credits,
              )),
            );
          },
        );
      },
    );
  }
}
