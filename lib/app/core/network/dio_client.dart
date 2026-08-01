import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(_interceptor());
  }

  InterceptorsWrapper _interceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final box = GetStorage();
        final token = box.read<String>('token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          final box = GetStorage();
          box.remove('token');
          box.remove('user_id');
        }
        final exception = _handleError(error);
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['detail'] ?? 'Unknown error';
        switch (statusCode) {
          case 400:
            return ApiException(message, statusCode: 400);
          case 401:
            return UnauthorizedException();
          case 404:
            return NotFoundException();
          case 500:
            return ServerException();
          default:
            return ApiException(message, statusCode: statusCode);
        }
      default:
        return ApiException('Unexpected error occurred');
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
  }) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
