import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ── Candidatos por ámbito (peru / extranjero) ────────────────────────────
  static Stream<List<Candidato>> candidatos(String ambito) {
    return _db
        .collection('candidatos')
        .where('ambito', isEqualTo: ambito)
        .snapshots()
        .map((snap) {
      final docs = snap.docs.toList()
        ..sort((a, b) => ((a.data()['orden'] as num?) ?? 0)
            .compareTo((b.data()['orden'] as num?) ?? 0));
      return docs.map((doc) {
        final d = doc.data();
        return Candidato(
          nombre: d['nombre'] ?? '',
          partido: d['partido'] ?? '',
          porcentaje: (d['porcentaje'] as num).toDouble(),
          porcentajeEmitidos: (d['porcentajeEmitidos'] as num).toDouble(),
          votos: (d['votos'] as num).toInt(),
          foto: doc.id.startsWith('ppk')
              ? 'assets/images/ppk.png'
              : 'assets/images/keiko.png',
        );
      }).toList();
    });
  }

  // ── Estadísticas por ámbito (peru / extranjero) ──────────────────────────
  static Stream<RegionalStats?> stats(String ambito) {
    return _db.collection('stats').doc(ambito).snapshots().map((doc) {
      if (!doc.exists) return null;
      final d = doc.data()!;
      return RegionalStats(
        totalActas:      d['totalActas']      ?? '0',
        procesadas:      d['procesadas']      ?? '0',
        contabilizadas:  d['contabilizadas']  ?? '0',
        electoresHabiles: d['electoresHabiles'] ?? '0',
        participantes:   d['participantes']   ?? '0',
        porcentajeFinal: d['porcentajeFinal'] ?? '0%',
        ausentismo:      d['ausentismo']      ?? '0%',
        votosValidos:    d['votosValidos']    ?? '0',
        pctValidos:      (d['pctValidos']  as num).toDouble(),
        votosBlancos:    d['votosBlancos']    ?? '0',
        pctBlancos:      (d['pctBlancos']  as num).toDouble(),
        votosNulos:      d['votosNulos']      ?? '0',
        pctNulos:        (d['pctNulos']    as num).toDouble(),
        totalEmitidos:   d['totalEmitidos']   ?? '0',
      );
    });
  }
}
