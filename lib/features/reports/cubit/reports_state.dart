part of 'reports_cubit.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

/// Emitted when any report filter (date range, grouping, toggles, ...) changes,
/// so the screen rebuilds and can re-trigger its GetModel/PaginationList fetch.
class ReportsFilterChanged extends ReportsState {}
