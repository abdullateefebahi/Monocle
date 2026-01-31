import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/models/sector_model.dart';
import '../../../shared/models/community_model.dart';
import '../data/sectors_repository.dart';

// Repository Provider
final sectorsRepositoryProvider = Provider<SectorsRepository>((ref) {
  return SectorsRepository(SupabaseService.client);
});

// Sectors List Provider
final sectorsProvider = FutureProvider<List<SectorModel>>((ref) async {
  final repository = ref.watch(sectorsRepositoryProvider);
  return repository.getSectors();
});

// Single Sector Provider
final sectorByIdProvider = FutureProvider.family<SectorModel, String>((
  ref,
  sectorId,
) async {
  final repository = ref.watch(sectorsRepositoryProvider);
  return repository.getSectorById(sectorId);
});

// Communities by Sector Provider
final communitiesBySectorProvider =
    FutureProvider.family<List<CommunityModel>, String>((ref, sectorId) async {
      final repository = ref.watch(sectorsRepositoryProvider);
      return repository.getCommunitiesBySector(sectorId);
    });

// Search Sectors Provider
final searchSectorsProvider = FutureProvider.family<List<SectorModel>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return ref.watch(sectorsProvider.future);
  }
  final repository = ref.watch(sectorsRepositoryProvider);
  return repository.searchSectors(query);
});

// Top Sectors by Members Provider
final topSectorsByMembersProvider = FutureProvider<List<SectorModel>>((
  ref,
) async {
  final repository = ref.watch(sectorsRepositoryProvider);
  return repository.getTopSectorsByMembers();
});

// Top Sectors by Communities Provider
final topSectorsByCommunitiesProvider = FutureProvider<List<SectorModel>>((
  ref,
) async {
  final repository = ref.watch(sectorsRepositoryProvider);
  return repository.getTopSectorsByCommunities();
});
