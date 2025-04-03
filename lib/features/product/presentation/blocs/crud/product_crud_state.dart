part of 'product_crud_bloc.dart';

abstract class ProductCrudState extends Equatable {
  const ProductCrudState();

  @override
  List<Object?> get props => [];
}

class ProductCrudInitial extends ProductCrudState {}

class ProductCrudLoading extends ProductCrudState {}

class ProductCrudSuccess extends ProductCrudState {
  final String message;

  const ProductCrudSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductCrudFailure extends ProductCrudState {
  final String error;

  const ProductCrudFailure(this.error);

  @override
  List<Object?> get props => [error];
}
