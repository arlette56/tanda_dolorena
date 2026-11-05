import '../modelos/tanda.dart';
import '../modelos/cierre_ronda.dart';
import 'resultado_aportacion.dart';
import 'resultado_cierre.dart';

class ServicioTanda {
  final Tanda tanda;

  ServicioTanda(this.tanda);

  // 1. MÉTODO NUEVO AGREGADO EN LA RONDA 7
  bool haTerminado() => tanda.turnoActual >= tanda.ordenTurnos.length;

  // 2. MÉTODO MODIFICADO CON LA NUEVA VALIDACIÓN AL INICIO
  ResultadoAportacion registrarAportacion(String idParticipante) {
    if (haTerminado()) return ResultadoAportacion.tandaTerminada;

    final esParticipante = tanda.participantes.any((p) => p.id == idParticipante);
    if (!esParticipante) return ResultadoAportacion.participanteInvalido;

    final yaAporto = tanda.aportacionesRondaActual.contains(idParticipante);
    if (yaAporto) return ResultadoAportacion.yaAporto;

    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }

  bool puedeCerrarRonda() {
    return tanda.participantes.every((p) => tanda.aportacionesRondaActual.contains(p.id));
  }

  CierreRonda cerrarRondaYAvanzar() {
    if (!puedeCerrarRonda()) {
      return CierreRonda(ResultadoCierre.faltanAportaciones, null);
    }
    final idBeneficiario = tanda.ordenTurnos[tanda.turnoActual];
    final beneficiario = tanda.participantes.firstWhere((p) => p.id == idBeneficiario);

    beneficiario.yaRecibioTurno = true;
    tanda.aportacionesRondaActual.clear();
    tanda.turnoActual++;

    return CierreRonda(ResultadoCierre.rondaCerrada, beneficiario);
  }
}