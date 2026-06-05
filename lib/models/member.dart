class Member {
  final int id;
  final String nombres;
  final String apellidos;
  final String? sexo;
  final DateTime? fechaNacimiento;
  final String? dni;
  final String? telefono;
  final String? email;
  final String? estadoCivil;
  final bool miembroActivo;
  final String? fotoUrl;
  final int? familiaId;
  final String? estadoEspiritual;

  Member({
    required this.id,
    required this.nombres,
    required this.apellidos,
    this.sexo,
    this.fechaNacimiento,
    this.dni,
    this.telefono,
    this.email,
    this.estadoCivil,
    required this.miembroActivo,
    this.fotoUrl,
    this.familiaId,
    this.estadoEspiritual,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      sexo: json['sexo'],
      fechaNacimiento: json['fecha_nacimiento'] != null 
          ? DateTime.parse(json['fecha_nacimiento']) : null,
      dni: json['dni'],
      telefono: json['telefono'],
      email: json['email'],
      estadoCivil: json['estado_civil'],
      miembroActivo: json['miembro_activo'] ?? true,
      fotoUrl: json['foto_url'],
      familiaId: json['familia_id'],
      estadoEspiritual: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'dni': dni,
      'telefono': telefono,
      'email': email,
      'estado_civil': estadoCivil,
      'miembro_activo': miembroActivo,
      'foto_url': fotoUrl,
      'familia_id': familiaId,
    };
  }
}
