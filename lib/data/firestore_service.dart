import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // Obtener candidatos por ámbito (peru / extranjero)
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
          foto: doc.id == 'ppk'
              ? 'assets/images/ppk.png'
              : 'assets/images/keiko.png',
        );
      }).toList();
    });
  }
}
