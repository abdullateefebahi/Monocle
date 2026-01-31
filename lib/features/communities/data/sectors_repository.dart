import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/sector_model.dart';
import '../../../shared/models/community_model.dart';

class SectorsRepository {
  final SupabaseClient _supabase;

  SectorsRepository(this._supabase);

  /// Fetch all active sectors with stats
  Future<List<SectorModel>> getSectors() async {
    try {
      final response = await _supabase
          .from('sector_stats')
          .select()
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => SectorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch sectors: $e');
    }
  }

  /// Fetch a single sector by ID
  Future<SectorModel> getSectorById(String sectorId) async {
    try {
      final response = await _supabase
          .from('sector_stats')
          .select()
          .eq('id', sectorId)
          .single();

      return SectorModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch sector: $e');
    }
  }

  /// Fetch communities for a specific sector
  Future<List<CommunityModel>> getCommunitiesBySector(String sectorId) async {
    try {
      final response = await _supabase
          .from('community')
          .select()
          .eq('sector_id', sectorId)
          .eq('is_public', true)
          .order('member_count', ascending: false);

      return (response as List)
          .map((json) => CommunityModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch communities: $e');
    }
  }

  /// Search sectors by name or description
  Future<List<SectorModel>> searchSectors(String query) async {
    try {
      final response = await _supabase
          .from('sector_stats')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => SectorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search sectors: $e');
    }
  }

  /// Get top sectors by member count
  Future<List<SectorModel>> getTopSectorsByMembers({int limit = 5}) async {
    try {
      final response = await _supabase
          .from('sector_stats')
          .select()
          .order('total_members', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => SectorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top sectors: $e');
    }
  }

  /// Get top sectors by community count
  Future<List<SectorModel>> getTopSectorsByCommunities({int limit = 5}) async {
    try {
      final response = await _supabase
          .from('sector_stats')
          .select()
          .order('community_count', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => SectorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top sectors: $e');
    }
  }
}
