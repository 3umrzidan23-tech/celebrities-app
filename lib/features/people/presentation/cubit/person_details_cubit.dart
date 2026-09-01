import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_person_details.dart';
import '../../domain/usecases/get_person_images.dart';
import 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  final GetPersonDetails getPersonDetails;
  final GetPersonImages getPersonImages;

  PersonDetailsCubit({
    required this.getPersonDetails,
    required this.getPersonImages,
  }) : super(PersonDetailsInitial());

  Future<void> fetchPersonDetails(int id) async {
    emit(PersonDetailsLoading());

    final failureOrDetails = await getPersonDetails(id);
    
    failureOrDetails.fold(
      (failure) => emit(PersonDetailsError(failure.message)),
      (details) async {
        final failureOrImages = await getPersonImages(id);
        failureOrImages.fold(
          (failure) => emit(PersonDetailsError(failure.message)),
          (images) => emit(PersonDetailsLoaded(details: details, images: images)),
        );
      },
    );
  }
}
