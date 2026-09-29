import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/core/networking/route_error_parser.dart';
import 'package:event_ticket_booking/core/networking/dio_factory.dart';
import 'package:event_ticket_booking/core/networking/ticket_master_error_parser.dart';
import 'package:event_ticket_booking/features/home/data/repos/home_repo.dart';
import 'package:event_ticket_booking/features/home/presentation/cubit/home_cubit.dart';
import 'package:event_ticket_booking/features/login/data/repos/login_repo.dart';
import 'package:event_ticket_booking/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
const String routeApiService = 'routeApiService';
const String ticketMasterApiService = 'ticketMasterApiService';
void setupGetIt() {
  getIt.registerLazySingleton<TicketmasterErrorParser>(
    () => TicketmasterErrorParser(),
  );
  getIt.registerLazySingleton<RoutErrorParser>(() => RoutErrorParser());

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
  getIt.registerLazySingleton<LoginRepo>(
    () => LoginRepo(getIt<ApiService>(instanceName: routeApiService)),
    instanceName: routeApiService,
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(getIt<ApiService>(instanceName: ticketMasterApiService)),
  );

  // cubits
  getIt.registerFactory(
    () => RegisterCubit(
      registerRepo: getIt<RegisterRepo>(instanceName: routeApiService),
    ),
  );
  getIt.registerFactory(
    () =>
        LoginCubit(loginRepo: getIt<LoginRepo>(instanceName: routeApiService)),
  );
  getIt.registerFactory(() => HomeCubit(repo: getIt<HomeRepo>()));
}
