class University {
  final String id;
  final String name;
  final List<String> domains;
  final double lat;
  final double lng;

  University({
    required this.id,
    required this.name,
    required this.domains,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'domains': domains,
      'lat': lat,
      'lng': lng,
    };
  }

  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      domains: List<String>.from(map['domains'] ?? []),
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
    );
  }
}

// Bangladesh Universities Database
class UniversityDatabase {
  static final List<University> universities = [
    University(
      id: 'aiub',
      name: 'American International University-Bangladesh',
      domains: ['aiub.edu'],
      lat: 23.7925,
      lng: 90.4078,
    ),
    University(
      id: 'nsu',
      name: 'North South University',
      domains: ['northsouth.edu', 'nsu.edu.bd'],
      lat: 23.8103,
      lng: 90.4125,
    ),
    University(
      id: 'brac',
      name: 'BRAC University',
      domains: ['bracu.ac.bd', 'g.bracu.ac.bd'],
      lat: 23.7808,
      lng: 90.4067,
    ),
    University(
      id: 'du',
      name: 'University of Dhaka',
      domains: ['du.ac.bd'],
      lat: 23.7359,
      lng: 90.3936,
    ),
    University(
      id: 'buet',
      name: 'Bangladesh University of Engineering and Technology',
      domains: ['buet.ac.bd'],
      lat: 23.7261,
      lng: 90.3916,
    ),
    University(
      id: 'iu',
      name: 'Independent University Bangladesh',
      domains: ['iub.edu.bd'],
      lat: 23.7517,
      lng: 90.3766,
    ),
    University(
      id: 'ewu',
      name: 'East West University',
      domains: ['ewubd.edu'],
      lat: 23.7708,
      lng: 90.4250,
    ),
    University(
      id: 'uiu',
      name: 'United International University',
      domains: ['uiu.ac.bd'],
      lat: 23.8236,
      lng: 90.3672,
    ),
    University(
      id: 'daffodil',
      name: 'Daffodil International University',
      domains: ['daffodilvarsity.edu.bd', 'diu.edu.bd'],
      lat: 23.8769,
      lng: 90.3258,
    ),
    University(
      id: 'ruet',
      name: 'Rajshahi University of Engineering & Technology',
      domains: ['ruet.ac.bd'],
      lat: 24.3636,
      lng: 88.6241,
    ),
    University(
      id: 'cuet',
      name: 'Chittagong University of Engineering & Technology',
      domains: ['cuet.ac.bd'],
      lat: 22.4625,
      lng: 91.9714,
    ),
    // Add more universities as needed
  ];

  // Verify if email domain matches any university
  static University? verifyUniversityEmail(String email) {
    final domain = email.split('@').length > 1 
        ? email.split('@')[1].toLowerCase() 
        : '';
    
    for (var university in universities) {
      for (var uniDomain in university.domains) {
        if (domain == uniDomain || domain.endsWith(uniDomain)) {
          return university;
        }
      }
    }
    return null;
  }

  // Get university by ID
  static University? getUniversityById(String id) {
    try {
      return universities.firstWhere((uni) => uni.id == id);
    } catch (e) {
      return null;
    }
  }
}
