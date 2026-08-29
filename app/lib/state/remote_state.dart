/// Modela el estado de una operación remota (ej. cargar productos) como
/// un TIPO CERRADO con casos mutuamente excluyentes, reemplazando el
/// patrón de banderas booleanas sueltas (isLoading + errorMessage + data)
/// que antes exigía revisar tres variables independientes para saber en
/// qué estado real se encuentra la pantalla — con el riesgo de que
/// queden combinaciones inconsistentes (ej. isLoading=true y data
/// no vacía al mismo tiempo).
///
/// Al ser `sealed`, el compilador de Dart EXIGE que cualquier `switch`
/// sobre este tipo cubra todos los casos (o incluya un `default`),
/// evitando que se olvide manejar alguno.
sealed class RemoteState<T> {
  const RemoteState();
}

/// Aún no se ha iniciado ninguna carga.
class RemoteIdle<T> extends RemoteState<T> {
  const RemoteIdle();
}

/// La operación está en curso.
class RemoteLoading<T> extends RemoteState<T> {
  const RemoteLoading();
}

/// La operación terminó con éxito y trajo datos.
class RemoteSuccess<T> extends RemoteState<T> {
  final T data;
  const RemoteSuccess(this.data);
}

/// La operación terminó con éxito, pero no hay datos que mostrar
/// (caso distinto de un error: la petición funcionó, la colección
/// simplemente está vacía).
class RemoteEmpty<T> extends RemoteState<T> {
  const RemoteEmpty();
}

/// La operación falló.
class RemoteFailure<T> extends RemoteState<T> {
  final String message;
  const RemoteFailure(this.message);
}