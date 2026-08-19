/// A minimal `major.minor.patch` comparator — enough for "is the installed
/// build at least as new as X", without pulling in a full semver package
/// for three integers.
class SemanticVersion implements Comparable<SemanticVersion> {
  const SemanticVersion(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  /// Parses "1.2.3" (or "1.2", or "1") — missing components default to 0.
  /// Returns null for anything that isn't a dot-separated run of integers,
  /// so a malformed remote value fails safe (no version gate shown) rather
  /// than crashing the app on startup.
  static SemanticVersion? tryParse(String value) {
    final parts = value.trim().split('.');
    if (parts.isEmpty || parts.length > 3) return null;
    final numbers = <int>[];
    for (final part in parts) {
      final n = int.tryParse(part);
      if (n == null) return null;
      numbers.add(n);
    }
    while (numbers.length < 3) {
      numbers.add(0);
    }
    return SemanticVersion(numbers[0], numbers[1], numbers[2]);
  }

  @override
  int compareTo(SemanticVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  bool operator <(SemanticVersion other) => compareTo(other) < 0;
  bool operator <=(SemanticVersion other) => compareTo(other) <= 0;
  bool operator >(SemanticVersion other) => compareTo(other) > 0;
  bool operator >=(SemanticVersion other) => compareTo(other) >= 0;

  @override
  String toString() => '$major.$minor.$patch';
}
