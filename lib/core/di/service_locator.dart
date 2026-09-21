import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/core/networking/dio_factory.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
const String routeApiService = 'routeApiService';
const String ticketMasterApiService = 'ticketMasterApiService';
void setupGetIt() {
  // services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(DioFactory(baseUrl: ApiConstants.routeBaseUrl)),
    instanceName: routeApiService,
  );
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(DioFactory(baseUrl: ApiConstants.ticketMasterBaseUrl)),
    instanceName: ticketMasterApiService,
  );
  // repos
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(getIt<ApiService>(instanceName: routeApiService)),
    instanceName: routeApiService,
  );

  // cubits
  getIt.registerFactory(
    () => RegisterCubit(
      registerRepo: getIt<RegisterRepo>(instanceName: routeApiService),
    ),
  );
}
